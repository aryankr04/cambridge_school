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

  const CreateRoutineScreen({Key? key, required this.schoolId})
      : super(key: key);

  @override
  State<CreateRoutineScreen> createState() => _CreateRoutineScreenState();
}

class _CreateRoutineScreenState extends State<CreateRoutineScreen> {
  final CreateRoutineController controller = Get.put(CreateRoutineController());

  @override
  void initState() {
    super.initState();
    controller.schoolId.value = widget.schoolId;
    // Load data after the widget is built and the controller is available.

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller
          .fetchSchoolSectionsAndPrepareClassAndSectionOption(); // Call the data loading function from the controller.
    });
  }

  @override
  Widget build(BuildContext context) {
    print(controller.events.length);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Routine'),
        actions: [
          TextButton(
            onPressed: () {
              if (controller.selectedClassName.value.isNotEmpty &&
                  controller.selectedSectionName.value.isNotEmpty &&
                  controller.selectedDay.value.isNotEmpty) {
                Get.dialog(
                  AddRoutineDialog(
                    onSubmit: (Event event) {
                      // Store the selected day with the event
                      // Corrected: Create a *new* `Event` with the day included
                      final updatedEvent = Event(
                        subject: event.subject,
                        eventType: event.eventType,
                        startTime: event.startTime,
                        endTime: event.endTime,
                        teacher: event.teacher,
                        location: event.location,
                      );
                      controller.addEvent(updatedEvent);
                    },
                  ),
                  barrierDismissible: false, // Prevent closing by tapping outside
                );
              } else {
                Get.snackbar('Error', 'Please select class, section, and day');
              }
            },
            child: const Text('Add Event'),
          ),        ],
      ),
      backgroundColor: MyColors.lightGrey,
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildShimmerList();
        } else if (controller.classNameOptions == null ||
            controller.sectionNameOptions == null) {
          // Handle the case where options are not loaded yet.
          return const Center(child: Text("Loading data..."));
        } else {
          return Column(
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                    vertical: MySizes.md, horizontal: MySizes.md),
                child: Row(
                  children: [
                    const Icon(
                      Icons.tune_rounded,
                      color: MyColors.subtitleTextColor,
                    ),
                    const SizedBox(
                      width: MySizes.md,
                    ),
                    Expanded(
                      child: MyBottomSheetDropdown(
                        optionsForChips: controller.classNameOptions!,
                        onSingleChanged: (value) {
                          controller.selectedClassName.value = value!;
                          controller.selectedSectionName.value = '';
                          controller.selectedDay.value = '';
                          controller.fetchClassData();
                        },
                        dropdownWidgetType: DropdownWidgetType.Filter,
                        hintText: 'Class',
                      ),
                    ),
                    const SizedBox(width: MySizes.md),
                    Expanded(
                      child: MyBottomSheetDropdown(
                        optionsForChips: controller.sectionNameOptions!,
                        onSingleChanged: (value) {
                          controller.selectedSectionName.value = value!;
                          controller.selectedDay.value = 'Mon';
                        },
                        dropdownWidgetType: DropdownWidgetType.Filter,
                        hintText: 'Section',
                      ),
                    ),
                    const SizedBox(width: MySizes.md),
                    Expanded(
                      child: MyBottomSheetDropdown(
                        optionsForChips: controller.dayOptions.obs,
                        onSingleChanged: (value) {
                          controller.selectedDay.value = value!;
                          controller.updateEventListForSelectedDay();
                        },
                        dropdownWidgetType: DropdownWidgetType.Filter,
                        hintText: 'Day',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: MySizes.spaceBtwSections),
              Expanded(
                child: Obx(() => ListView.builder(
                  itemCount: controller.events.length,
                  itemBuilder: (context, index) {
                    final event = controller.events[index];
                    return TimelineItem(
                      key: ValueKey(event.startTime),
                      id: event.startTime.toString(),
                      startsAt: formatTimeOfDay(event.startTime),
                      endsAt: formatTimeOfDay(event.endTime),
                      subject: event.subject,
                      classTeacherName:
                      controller.classModel.value?.className ?? '',
                      className:
                      controller.classModel.value?.className ?? '',
                      sectionName: controller.selectedSectionName.value,
                      itemType: TimelineItemTypeExtension.fromString(
                          event.eventType ?? 'Class'),
                      isMatch: true,
                      isWrite: true,
                      isStudent: false,
                      onDeletePressed: () {
                        controller.deleteEvent(index);
                      },
                      onEditPressed: () {
                        Get.dialog(
                          AddRoutineDialog(
                            event: event,
                            index: index,
                            onSubmit: (Event updatedEvent) {
                              controller.updateEvent(updatedEvent, index);
                            },
                          ),
                          barrierDismissible: false,
                        );
                      },
                    );
                  },
                )),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.updateClassModel();
                },
                child: const Text('Update Routine'),
              ),
            ],
          );
        }
      }),
    );
  }

  Widget _buildShimmerList() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5, // Adjust the number of shimmer items as needed
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(
                horizontal: MySizes.md, vertical: MySizes.sm),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            height: 100, // Adjust the height as needed
            width: double.infinity,
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

  String getItemType(String type) {
    switch (type) {
      case 'Class':
        return 'Class';
      case 'Break':
        return 'Break';
      case 'Assembly':
        return 'Assembly';
      case 'Departure':
        return 'Departure';
      default:
        return 'Start';
    }
  }
}


class AddRoutineDialog extends StatefulWidget {
  final Function(Event) onSubmit;
  final Event? event;
  final int? index;

  const AddRoutineDialog({
    Key? key,
    required this.onSubmit,
    this.event,
    this.index,
  }) : super(key: key);

  @override
  State<AddRoutineDialog> createState() => _AddRoutineDialogState();
}

class _AddRoutineDialogState extends State<AddRoutineDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _subjectController;
  late final Rx<TimeOfDay?> _startTime;
  late final Rx<TimeOfDay?> _endTime;
  final RxString _eventType = 'Class'.obs;

  @override
  void initState() {
    super.initState();
    _subjectController =
        TextEditingController(text: widget.event?.subject ?? '');
    _startTime =
        Rx<TimeOfDay?>(widget.event?.startTime); // Initialize Rx with value
    _endTime =
        Rx<TimeOfDay?>(widget.event?.endTime); // Initialize Rx with value
    _eventType.value = widget.event?.eventType ?? 'Class';
  }

  @override
  void dispose() {
    _subjectController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newEvent = Event(
        subject: _subjectController.text,
        eventType: _eventType.value,
        startTime: _startTime.value ?? TimeOfDay.now(),
        endTime: _endTime.value ?? TimeOfDay.now(),
        teacher: '',
      );
      widget.onSubmit(newEvent);
      Get.back();

    }
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
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter subject'
                      : null,
                ),
                const SizedBox(height: 16),
                Obx(() => MyBottomSheetDropdown(
                  labelText: 'Event Type',
                  optionsForChips: const [
                    'Class',
                    'Break',
                    'Assembly',
                    'Departure',
                    'Start',
                  ],
                  onSingleChanged: (value) {
                    _eventType.value = value ?? 'Class';
                    FocusScope.of(context).unfocus();
                  },
                  initialSelectedValues: [_eventType.value],
                )),
                const SizedBox(height: 16),
                MyTimePickerField(
                  labelText: 'Start Time',
                  selectedTime: _startTime,
                  onTimeChanged: (time) {
                    if (time != null) {
                      _startTime.value = time;
                      FocusScope.of(context).unfocus();
                    }
                  },
                ),
                const SizedBox(height: 16),
                MyTimePickerField(
                  labelText: 'End Time',
                  selectedTime: _endTime,
                  onTimeChanged: (time) {
                    if (time != null) {
                      _endTime.value = time;
                      FocusScope.of(context).unfocus();
                    }
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
            SizedBox(width: MySizes.md),
            Expanded(
              child: MyButton(
                onPressed: _submitForm,
                text: widget.event != null ? 'Update' : 'Add',
              ),
            ),
          ],
        ),
      ],
    );
  }
}