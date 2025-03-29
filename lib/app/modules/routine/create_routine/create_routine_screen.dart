import 'package:cambridge_school/core/utils/constants/enums/class_name.dart';
import 'package:cambridge_school/core/utils/constants/enums/schedule_event_type.dart';
import 'package:cambridge_school/core/utils/constants/enums/subject.dart';
import 'package:cambridge_school/core/utils/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/sizes.dart';
import '../../../../core/widgets/bottom_sheet_dropdown.dart';
import '../../../../core/widgets/dropdown_field.dart';
import '../../../../core/widgets/search_field.dart';
import '../../../../core/widgets/snack_bar.dart';
import '../../../../core/widgets/text_field.dart';
import '../../../../core/widgets/time_picker.dart';
import '../../class_management/class_model.dart';
import '../routine_item.dart';
import '../routine_model.dart';
import 'create_routine_controller.dart';

class CreateRoutineScreen extends StatefulWidget {
  const CreateRoutineScreen({super.key});

  @override
  State<CreateRoutineScreen> createState() => _CreateRoutineScreenState();
}

class _CreateRoutineScreenState extends State<CreateRoutineScreen> {
  final CreateRoutineController controller =
      Get.find<CreateRoutineController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    try {
      await controller.fetchSchoolSectionsAndPrepareClassAndSectionOptions();
    } catch (e) {
      MySnackBar.showErrorSnackBar('Failed to load initial data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Routine'),
      ),
      backgroundColor: MyColors.lightGrey,
      body: Obx(() => _buildBodyContent()),
    );
  }

  Widget _buildBodyContent() {
    if (controller.isLoadingOptions.value ||
        controller.isLoadingClassData.value) {
      return _buildLoadingState();
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildFilterSection(),
          Column(
            children: [
              _buildRoutineDisplaySection(),
              _buildRoutineList(),
              const SizedBox(height: MySizes.md),
              if (controller.isEditMode.value) _buildAddEventButton(),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAddEventButton() {
    return Padding(
      padding: const EdgeInsets.only(right: MySizes.md),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton.icon(
          onPressed: () {
            _showAddRoutineDialog(context, null, null);
          },
          label: const Text('Add Event'),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: [
        _buildFilterSectionShimmer(),
        Expanded(child: _buildShimmerRoutineList()),
      ],
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
            _buildShimmerBox(),
            const SizedBox(width: MySizes.md),
            _buildShimmerBox(),
            const SizedBox(width: MySizes.md),
            _buildShimmerBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      alignment: Alignment.centerLeft,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        vertical: MySizes.md,
        horizontal: MySizes.md,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
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
      ),
    );
  }

  Widget _buildClassDropdown() {
    return MyBottomSheetDropdown(
      optionsForChips: controller.classNameOptions,
      onSingleChanged: (value) async {
        controller.selectedClassName.value = value;
        await controller.fetchClassData();
      },
      dropdownWidgetType: DropdownWidgetType.filter,
      hintText: 'Class',
      selectedValue: controller.selectedClassName,
    );
  }

  Widget _buildSectionDropdown() {
    return MyBottomSheetDropdown(
      optionsForChips: controller.sectionNameOptions,
      selectedValue: controller.selectedSectionName,
      onSingleChanged: (value) {
        controller.selectedSectionName.value = value;
      },
      dropdownWidgetType: DropdownWidgetType.filter,
      hintText: 'Section',
    );
  }

  Widget _buildDayDropdown() {
    return MyBottomSheetDropdown(
      optionsForChips: CreateRoutineController.dayOptions.obs,
      selectedValue: controller.selectedDay,
      onSingleChanged: (value) {
        controller.selectedDay.value = value;
      },
      dropdownWidgetType: DropdownWidgetType.filter,
      hintText: 'Day',
    );
  }

  Widget _buildRoutineDisplaySection() {
    return Obx(() => (controller.selectedClassName.value.isNotEmpty &&
            controller.selectedSectionName.value.isNotEmpty)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(MySizes.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${controller.selectedDay} Routine',
                      style: MyTextStyle.headlineSmall,
                    ),
                    if (controller.userRole.value == 'Teacher')
                      _buildTeacherActionsRow(),
                  ],
                ),
              ),
            ],
          )
        : const SizedBox.shrink());
  }

  Widget _buildTeacherActionsRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (controller.isEditMode.value) _buildUpdateButton(),
        const SizedBox(
          width: MySizes.md,
        ),
        _buildEditCancelButton(),
      ],
    );
  }

  Widget _buildEditCancelButton() {
    return FilledButton.icon(
      onPressed: controller.toggleEditMode,
      style: FilledButton.styleFrom(
        backgroundColor: controller.isEditMode.value
            ? MyColors.activeRed
            : MyColors.activeBlue,
      ),
      icon: Icon(
        controller.isEditMode.value ? Icons.close : Icons.edit,
        size: 18,
      ),
      label: Text(
        controller.isEditMode.value ? 'Cancel' : 'Edit',
      ),
    );
  }

  Widget _buildUpdateButton() {
    return FilledButton.icon(
      onPressed: () async {
        try {
          await controller.updateClassModelInFirebase();
        } catch (e) {
          MySnackBar.showErrorSnackBar('Failed to update routine: $e');
        }
      },
      style: FilledButton.styleFrom(
        backgroundColor: MyColors.activeOrange,
      ),
      label: const Text('Save'),
      icon: const Icon(
        Icons.save,
        size: 18,
      ),
    );
  }

  Future<void> _showAddRoutineDialog(
    BuildContext context,
    Event? event,
    int? index,
  ) async {
    Get.dialog(
      barrierDismissible: false,
      AddRoutineDialog(
        onSubmit: (Event newEvent) async {
          try {
            if (event != null) {
              controller.classModel.value?.updateEventInRoutine(
                controller.selectedSectionName.value,
                controller.selectedDay.value,
                index!,
                newEvent,
              );
            } else {
              controller.classModel.value?.addEventToRoutine(
                controller.selectedSectionName.value,
                controller.selectedDay.value,
                newEvent,
              );
            }
            controller.classModel.refresh();
          } catch (e) {
            MySnackBar.showErrorSnackBar('Failed to update routine: $e');
          }
        },
        event: event,
        index: index,
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/illustrations/empty_state_illustration/e_commerce_3.svg',
          ),
          const SizedBox(height: MySizes.sm),
          Text(
            message,
            style: MyTextStyle.titleLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRoutineList() {
    return Obx(() {
      final String currentSelectedSectionName =
          controller.selectedSectionName.value;
      final String currentSelectedDay = controller.selectedDay.value;

      if (controller.classModel.value == null) {
        return _buildEmptyState('No class selected.');
      }

      final SectionModel? selectedSection =
          controller.classModel.value?.sections.firstWhereOrNull(
        (section) => section.sectionName == currentSelectedSectionName,
      );

      if (selectedSection == null) {
        return _buildEmptyState('No section selected.');
      }

      final List<DailyRoutine> weeklyRoutine = selectedSection.routine;

      final DailyRoutine? dailyRoutine = weeklyRoutine.firstWhereOrNull(
        (routine) => routine.day == currentSelectedDay,
      );
      if (controller.selectedDay.value.isEmpty) {
        return _buildEmptyState('No Day selected.');
      }
      if (dailyRoutine == null) {
        return _buildEmptyState(
            'No routine found for  ${controller.selectedDay.value}');
      }

      if (dailyRoutine.events.isEmpty) {
        return _buildEmptyState(
            'No Routine Found for ${controller.selectedDay.value}');
      }

      dailyRoutine.events.sort((a, b) {
        // Compare hours first
        if (a.startTime.hour != b.startTime.hour) {
          return a.startTime.hour.compareTo(b.startTime.hour);
        }
        // If hours are the same, compare minutes
        return a.startTime.minute.compareTo(b.startTime.minute);
      });

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: dailyRoutine.events.length,
        itemBuilder: (context, index) {
          final Event event = dailyRoutine.events[index];

          return EventItem(
            period: index + 1,
            interval: controller.calculateTimeInterval(
                event.startTime, event.endTime),
            isWrite: controller.isEditMode,
            startsAt: controller.formatTimeOfDay(event.startTime),
            endsAt: controller.formatTimeOfDay(event.endTime),
            subject: event.subject,
            classTeacherName: selectedSection.classTeacherName,
            className: controller.classModel.value?.className.label,
            sectionName: selectedSection.sectionName,
            eventType: event.eventType,
            isStudent: true,
            onDeletePressed: () {
              _deleteEvent(
                  controller.selectedSectionName.value,
                  controller.selectedDay.value,
                  index); // Call the delete function
            },
            onEditPressed: () {
              _showAddRoutineDialog(context, event, index);
            },
          );
        },
      );
    });
  }

  void _deleteEvent(String sectionName, String day, int index) {
    controller.classModel.value?.deleteEventInRoutine(
      sectionName,
      day,
      index,
    );
    controller.classModel.refresh();
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
}

extension on CreateRoutineController {
  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
    if (!isEditMode.value) {
      isUpdateMode.value = false;
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
  late TextEditingController _subjectController;
  late TextEditingController _teacherNameController;
  late TextEditingController _teacherIdController;
  late TextEditingController _locationController;
  late Rx<TimeOfDay?> _startTime;
  late Rx<TimeOfDay?> _endTime;
  final RxString _eventType = 'Class'.obs;
  final RxBool _isLoading = false.obs; // Use a single RxBool for loading

  @override
  void initState() {
    super.initState();
    _subjectController =
        TextEditingController(text: widget.event?.subject ?? '');
    _teacherNameController =
        TextEditingController(text: widget.event?.teacherName ?? '');
    _teacherIdController =
        TextEditingController(text: widget.event?.teacherId ?? '');
    _locationController =
        TextEditingController(text: widget.event?.location ?? '');
    _startTime = Rx<TimeOfDay?>(widget.event?.startTime);
    _endTime = Rx<TimeOfDay?>(widget.event?.endTime);
    _eventType.value = widget.event?.eventType.label ?? 'Class';
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _teacherNameController.dispose();
    _teacherIdController.dispose();
    _locationController.dispose();
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
        MySnackBar.showErrorSnackBar('Please select both start and end times.');
        return;
      }

      if (!_isStartTimeBeforeEndTime(startTimeValue, endTimeValue)) {
        MySnackBar.showErrorSnackBar('Start time must be before end time');
        return;
      }

      try {
        _isLoading.value = true;

        final newEvent = Event(
          subject: _subjectController.text.trim(),
          eventType: ScheduleEventType.fromString(_eventType.value) ??
              ScheduleEventType.classSession,
          startTime: startTimeValue,
          endTime: endTimeValue,
          teacherId: _teacherIdController.text.trim(),
          teacherName: _teacherNameController.text.trim(),
          location: _locationController.text.trim(),
        );

        await widget.onSubmit(newEvent);
        Get.back();
      } catch (e) {
        MySnackBar.showErrorSnackBar('Failed to submit event: $e');
      } finally {
        _isLoading.value = false;
      }
    }
  }

  bool _isStartTimeBeforeEndTime(
      TimeOfDay startTimeValue, TimeOfDay endTimeValue) {
    final now = DateTime.now();

    final startDateTime = DateTime(now.year, now.month, now.day,
        startTimeValue.hour, startTimeValue.minute);
    final endDateTime = DateTime(
        now.year, now.month, now.day, endTimeValue.hour, endTimeValue.minute);
    return startDateTime.isBefore(endDateTime);
  }

  List<Map<String, dynamic>> teachers = [
    {'description': '1', 'title': 'Mr. Smith', 'icon': Icons.person},
    {'description': '2', 'title': 'Ms. Johnson', 'icon': Icons.person},
    {'description': '3', 'title': 'Dr. Williams', 'icon': Icons.person},
    {'description': '4', 'title': 'Prof. Davis', 'icon': Icons.person},
  ];
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.event != null ? 'Edit Event' : 'Add Event',
        style: MyTextStyle.headlineSmall,
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: SizedBox(
            width: Get.width,
            child: Obx(() => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MyDropdownField(
                      labelText: 'Event Type',
                      options: const [
                        'Class',
                        'Break',
                        'Assembly',
                        'Departure',
                        'Start',
                      ],
                      onSelected: (value) {
                        _eventType.value = value!;
                        if (value != 'Class') {
                          _subjectController.text = '';
                          _teacherNameController.text = '';
                          _teacherIdController.text = '';
                        }
                      },
                      selectedValue: _eventType,
                    ),
                    MyTimePickerField(
                      labelText: 'Start Time',
                      selectedTime: _startTime,
                      onTimeChanged: (time) {
                        _startTime.value = time;
                      },
                    ),
                    MyTimePickerField(
                      labelText: 'End Time',
                      selectedTime: _endTime,
                      onTimeChanged: (time) {
                        _endTime.value = time;
                      },
                    ),
                    if (_eventType.value == 'Class') ...[
                      MySearchField(
                        onSelected: (val) {
                          _subjectController.text = val;
                        },
                        controller: _subjectController,
                        options: SubjectName.labelsList,
                        labelText: 'Subject',
                        showClearIcon: true,
                      ),
                      MyBottomSheetDropdown(
                        labelText: 'Select Teacher',
                        hintText: 'Choose a teacher',
                        dropdownOptionType: DropdownOptionType
                            .iconWithDescription, // Correct Option type
                        optionsForIconWithDescription:
                            teachers, // Use the list of maps
                        onSingleChanged: (value) {
                          _teacherNameController.text = value = value;
                          // Find the teacher ID based on the selected name:
                          String teacherId = teachers.firstWhere((teacher) =>
                              teacher['title'] == value)['description'];
                          _teacherIdController.text = teacherId;
                        },
                      ),
                    ],
                    MyTextField(
                      controller: _locationController,
                      labelText: 'Location',
                    ),
                  ],
                )),
          ),
        ),
      ),
      actions: [
        Row(
          children: [
            FilledButton(
              onPressed: _submitForm,
              style: FilledButton.styleFrom(
                backgroundColor: MyColors.activeGreen,
                foregroundColor: Colors.white,
              ),
              child: Text(widget.event != null ? 'Update' : 'Add'),
            ),
            const SizedBox(width: MySizes.md),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              style: FilledButton.styleFrom(
                backgroundColor: MyColors.activeRed,
                foregroundColor: Colors.white,
              ),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ],
    );
  }
}
