import 'package:cambridge_school/app/modules/class_management/class_management_controller.dart';
import 'package:cambridge_school/core/utils/constants/enums/class_name.dart';
import 'package:cambridge_school/core/utils/constants/text_styles.dart';
import 'package:cambridge_school/core/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/sizes.dart';
import '../../../../core/widgets/bottom_sheet_dropdown.dart';
import '../../../../core/widgets/text_field.dart';
import '../../../../core/widgets/time_picker.dart';
import '../routine_item.dart';
import '../routine_model.dart';
import 'create_routine_controller.dart';

class CreateRoutineScreen extends StatefulWidget {
  final String schoolId;

  const CreateRoutineScreen({super.key, required this.schoolId});

  @override
  State<CreateRoutineScreen> createState() => _CreateRoutineScreenState();
}

class _CreateRoutineScreenState extends State<CreateRoutineScreen> {
  final CreateRoutineController _controller =
      Get.find<CreateRoutineController>();

  @override
  void initState() {
    super.initState();
    _controller.schoolId.value = widget.schoolId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.fetchSchoolSectionsAndPrepareClassAndSectionOptions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Routine'),
      ),
      backgroundColor: MyColors.lightGrey,
      body: Obx(_buildBodyContent),
    );
  }

  Widget _buildBodyContent() {
    if (_controller.isLoadingOptions.value ||
        _controller.isLoadingClassData.value) {
      return _buildLoadingState();
    } else if (_controller.isLoadingClassData.value &&
        !_controller.isLoadingOptions.value) {
      return Column(
        children: [
          _buildFilterSection(),
          Expanded(child: _buildShimmerRoutineList()),
        ],
      );
    } else {
      return _buildContentState();
    }
  }

  Widget _buildLoadingState() {
    return Column(
      children: [
        _buildFilterSectionShimmer(),
        Expanded(child: _buildShimmerRoutineList()),
      ],
    );
  }

  Widget _buildContentState() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildFilterSection(),
          Column(
            children: [
              _buildRoutineDisplaySection(),
              _buildRoutineList(),
              const SizedBox(height: MySizes.md)
            ],
          )
        ],
      ),
    );
  }

  Widget _buildShimmerBox() {
    return Container(
      height: 40,
      width: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  Widget _buildFilterSectionShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(MySizes.md),
        child: Row(
          children: [
            const Icon(
              Icons.tune_rounded,
              color: MyColors.subtitleTextColor,
            ),
            const SizedBox(width: MySizes.md),
            Expanded(child: _buildShimmerBox()),
            const SizedBox(width: MySizes.md),
            Expanded(child: _buildShimmerBox()),
            const SizedBox(width: MySizes.md),
            Expanded(child: _buildShimmerBox()),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        vertical: MySizes.md,
        horizontal: MySizes.md,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.tune_rounded,
            color: MyColors.subtitleTextColor,
          ),
          const SizedBox(width: MySizes.md),
          _buildClassDropdown(),
          const SizedBox(width: MySizes.md),
          _buildSectionDropdown(),
          const SizedBox(width: MySizes.md),
          _buildDayDropdown(),
        ],
      ),
    );
  }

  Widget _buildClassDropdown() {
    return MyBottomSheetDropdown(
      optionsForChips: _controller.classNameOptions!,
      onSingleChanged: (value) async {
        _controller.selectedClassName.value = value;
        await _controller.fetchClassData();
        _controller.selectedSectionName.value =
            _controller.sectionNameOptions!.first;
        _controller.updateEventListForSelectedDay();
      },
      dropdownWidgetType: DropdownWidgetType.filter,
      hintText: 'Class',
      selectedValue: _controller.selectedClassName,
    );
  }

  Widget _buildSectionDropdown() {
    return MyBottomSheetDropdown(
      optionsForChips: _controller.sectionNameOptions!,
      selectedValue: _controller.selectedSectionName,
      onSingleChanged: (value) {
        _controller.selectedSectionName.value = value;
        _controller.updateEventListForSelectedDay();
      },
      dropdownWidgetType: DropdownWidgetType.filter,
      hintText: 'Section',
    );
  }

  Widget _buildDayDropdown() {
    return MyBottomSheetDropdown(
      optionsForChips: CreateRoutineController.dayOptions.obs,
      selectedValue: _controller.selectedDay,
      onSingleChanged: (value) {
        _controller.selectedDay.value = value;
        _controller.updateEventListForSelectedDay();
      },
      dropdownWidgetType: DropdownWidgetType.filter,
      hintText: 'Day',
    );
  }

  Widget _buildRoutineDisplaySection() {
    return (_controller.selectedClassName.value.isNotEmpty &&
            _controller.selectedSectionName.value.isNotEmpty)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_controller.userRole.value == 'Teacher')
                _buildTeacherActionsRow(),
              const SizedBox(height: MySizes.sm),
              const Divider(color: MyColors.dividerColor, height: 1),
              const SizedBox(height: MySizes.md),
              Padding(
                padding: const EdgeInsets.only(
                    left: MySizes.md, right: MySizes.md, bottom: MySizes.sm),
                child: Text(
                  '${_controller.selectedDay} Routine',
                  style: MyTextStyle.headlineSmall,
                ),
              ),
            ],
          )
        : const SizedBox.shrink();
  }

  Widget _buildTeacherActionsRow() {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: MySizes.sm, horizontal: MySizes.md),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: MySizes.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Edit Routine',
                style: MyTextStyle.headlineSmall,
              ),
              if (!_controller.isEditMode.value) _buildEditCancelButton(),
            ],
          ),
          if (_controller.isEditMode.value)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: MySizes.sm,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_controller.isUpdateMode.value) ...[
                      _buildUpdateButton(),
                      const SizedBox(
                        width: MySizes.md,
                      ),
                    ],
                    if (_controller.isEditMode.value) ...[
                      FilledButton.icon(
                        onPressed: _showAddEventDialog,
                        label: const Text('Add Event'),
                        icon: const Icon(Icons.add),
                        style: FilledButton.styleFrom(
                            backgroundColor: MyColors.activeGreen,
                            alignment: Alignment.centerRight),
                      ),
                      const SizedBox(
                        width: MySizes.md,
                      ),
                    ],
                    _buildEditCancelButton(),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildEditCancelButton() {
    return FilledButton.icon(
      onPressed: _controller.toggleEditMode,
      style: FilledButton.styleFrom(
        backgroundColor: _controller.isEditMode.value
            ? MyColors.activeRed
            : MyColors.activeBlue,
      ),
      icon: Icon(
        _controller.isEditMode.value ? Icons.close : Icons.edit,
        size: 18,
      ),
      label: Text(
        _controller.isEditMode.value ? 'Cancel' : 'Edit',
      ),
    );
  }

  Widget _buildUpdateButton() {
    return FilledButton.icon(
      onPressed: _controller.updateClassModelInFirebase,
      style: FilledButton.styleFrom(
        backgroundColor: MyColors.activeOrange,
      ),
      label: const Text('Update'),
      icon: const Icon(
        Icons.update,
        size: 18,
      ),
    );
  }

  Widget _buildRoutineList() {
    int periodCount = 0;

    return _controller.events.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _controller.events.length,
            itemBuilder: (context, index) {
              final event = _controller.events[index];
              int? period;
              if (event.eventType == 'Class') {
                periodCount++;
                period = periodCount;
              }

              return EventItem(
                key: ValueKey(event.startTime),
                period: period,
                interval: _controller.calculateTimeInterval(
                    event.startTime, event.endTime),
                startsAt: formatTimeOfDay(event.startTime),
                endsAt: formatTimeOfDay(event.endTime),
                subject: event.subject,
                classTeacherName: _controller.classModel.value?.className.label,
                className: _controller.classModel.value?.className.label,
                sectionName: _controller.selectedSectionName.value,
                itemType: TimelineItemTypeExtension.fromString(
                    event.eventType ?? 'Class'),
                isWrite: _controller.isEditMode,
                isStudent: _controller.userRole.value == 'Student',
                onDeletePressed: () {
                  _controller.deleteEvent(index);
                },
                onEditPressed: () {
                  Get.dialog(
                    AddRoutineDialog(
                      event: event,
                      index: index,
                      onSubmit: (Event updatedEvent) {
                        _controller.updateEvent(updatedEvent, index);
                      },
                    ),
                    barrierDismissible: false,
                  );
                },
              );
            },
          )
        : Center(
            child:
                Text('No Routine Found for ${_controller.selectedDay.value}'),
          );
  }

  Widget _buildShimmerRoutineList() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 8.0, horizontal: MySizes.md),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: MySizes.md,
                  backgroundColor: Colors.white,
                ),
                const SizedBox(width: MySizes.md),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    height: Get.width * 0.16,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dateTime = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    return DateFormat('h:mm a').format(dateTime);
  }

  void _showAddEventDialog() {
    if (_controller.selectedClassName.value.isNotEmpty &&
        _controller.selectedSectionName.value.isNotEmpty &&
        _controller.selectedDay.value.isNotEmpty) {
      Get.dialog(
        AddRoutineDialog(
          onSubmit: (Event event) {
            _controller.addEvent(event);
          },
        ),
        barrierDismissible: false,
      );
    } else {
      Get.snackbar(
        'Error',
        'Please select class, section, and day',
      );
    }
  }
}

class AddRoutineDialog extends StatefulWidget {
  final Function(Event) onSubmit;
  final Event? event;
  final int? index;

  const AddRoutineDialog({
    super.key,
    required this.onSubmit,
    this.event,
    this.index,
  });

  @override
  State<AddRoutineDialog> createState() => _AddRoutineDialogState();
}

class _AddRoutineDialogState extends State<AddRoutineDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _subjectController;
  late final Rx<TimeOfDay?> _startTime;
  late final Rx<TimeOfDay?> _endTime;
  final RxString _eventType = 'Class'.obs;
  RxBool isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    _subjectController =
        TextEditingController(text: widget.event?.subject ?? '');
    _startTime = Rx<TimeOfDay?>(widget.event?.startTime);
    _endTime = Rx<TimeOfDay?>(widget.event?.endTime);
    _eventType.value = widget.event?.eventType ?? 'Class';
  }

  @override
  void dispose() {
    _subjectController.dispose();
    super.dispose();
  }

  String? _validateSubject(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the subject';
    }
    return null;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final startTimeValue = _startTime.value;
      final endTimeValue = _endTime.value;

      if (startTimeValue == null || endTimeValue == null) {
        Get.snackbar('Error', 'Please select both start and end times.');
        return;
      }

      if (_isStartTimeAfterEndTime(startTimeValue, endTimeValue)) {
        Get.snackbar('Error', 'Start time must be before end time');
        return;
      }

      isLoading.value = true;
      try {
        final newEvent = Event(
          subject: _subjectController.text,
          eventType: _eventType.value,
          startTime: startTimeValue,
          endTime: endTimeValue,
          teacher: '',
        );

        await widget.onSubmit(newEvent);
        Get.back();
      } catch (e) {
        Get.snackbar('Error', 'Failed to submit event: $e');
      } finally {
        isLoading.value = false;
      }
    }
  }

  //Extracted the validation for start time and end time in the function
  bool _isStartTimeAfterEndTime(
      TimeOfDay startTimeValue, TimeOfDay endTimeValue) {
    return startTimeValue.hour > endTimeValue.hour ||
        (startTimeValue.hour == endTimeValue.hour &&
            startTimeValue.minute >= endTimeValue.minute);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(16.0),
      title: Text(
        widget.event != null ? 'Edit Event' : 'Add Event',
        style: MyTextStyle.headlineSmall,
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: SizedBox(
            width: Get.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyTextField(
                  controller: _subjectController,
                  labelText: 'Subject',
                  validator: _validateSubject,
                ),
                const SizedBox(height: 16),
                MyBottomSheetDropdown(
                  labelText: 'Event Type',
                  optionsForChips: const [
                    'Class',
                    'Break',
                    'Assembly',
                    'Departure',
                    'Start',
                  ],
                  onSingleChanged: (value) {
                    _eventType.value = value;
                  },
                  initialSelectedValues: [_eventType.value],
                ),
                const SizedBox(height: 16),
                MyTimePickerField(
                  labelText: 'Start Time',
                  selectedTime: _startTime,
                  onTimeChanged: (time) {
                    _startTime.value = time;
                  },
                ),
                const SizedBox(height: 16),
                MyTimePickerField(
                  labelText: 'End Time',
                  selectedTime: _endTime,
                  onTimeChanged: (time) {
                    _endTime.value = time;
                  },
                )
              ],
            ),
          ),
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: MyButton(
                onPressed: Get.back,
                text: 'Cancel',
                isOutlined: true,
              ),
            ),
            const SizedBox(width: MySizes.md),
            Expanded(
              child: Obx(() => MyButton(
                    onPressed: _submitForm,
                    text: widget.event != null ? 'Update' : 'Add',
                    isLoading: isLoading.value,
                  )),
            ),
          ],
        ),
      ],
    );
  }
}

extension on CreateRoutineController {
  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
    if (!isEditMode.value) {
      isUpdateMode.value = false;
    }
  }

  void addEvent(Event event) {
    events.add(event);
  }

  void deleteEvent(int index) {
    events.removeAt(index);
  }

  void updateEvent(Event updatedEvent, int index) {
    events[index] = updatedEvent;
  }
}
