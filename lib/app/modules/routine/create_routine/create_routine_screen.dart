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
  final CreateRoutineController controller =
      Get.find<CreateRoutineController>();

  @override
  void initState() {
    super.initState();
    controller.schoolId.value = widget.schoolId;
    // Load data after the widget is built and the controller is available.

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchSchoolSectionsAndPrepareClassAndSectionOption();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Routine'),
      ),
      backgroundColor: MyColors.lightGrey,
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildShimmerList();
        }

        if (controller.classNameOptions == null ||
            controller.sectionNameOptions == null) {
          return const Center(
              child:
                  CircularProgressIndicator()); // More descriptive loading indicator
        }

        return Column(
          children: [
            Container(
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
                  MyBottomSheetDropdown(
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
                  const SizedBox(width: MySizes.md),
                  MyBottomSheetDropdown(
                    optionsForChips: controller.sectionNameOptions!,
                    onSingleChanged: (value) {
                      controller.selectedSectionName.value = value!;
                      controller.selectedDay.value = 'Monday';
                      controller.updateEventListForSelectedDay();
                    },
                    dropdownWidgetType: DropdownWidgetType.Filter,
                    hintText: 'Section',
                  ),
                  const SizedBox(width: MySizes.md),
                  MyBottomSheetDropdown(
                    optionsForChips: controller.dayOptions.obs,
                    onSingleChanged: (value) {
                      controller.selectedDay.value = value!;
                      controller.updateEventListForSelectedDay();
                    },
                    dropdownWidgetType: DropdownWidgetType.Filter,
                    hintText: 'Day',
                  ),
                ],
              ),
            ),
            Obx(
                  () => controller.events.isNotEmpty
                  ? Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MySizes.md,
                  vertical: controller.userRole.value=='Teacher' ? MySizes.sm : MySizes.md,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${controller.selectedDay} Routine',
                      style: MyTextStyle.headlineSmall,
                    ),
                    if (controller.userRole.value == 'Teacher')
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Update Button (Orange)
                          if (controller.isEditMode.value && controller.isUpdateMode.value)
                            FilledButton(
                              onPressed: () {
                                controller.updateClassModel();
                              },
                              style: FilledButton.styleFrom(backgroundColor: MyColors.activeOrange),
                              child: const Text('Update'),
                            ),

                          // Edit/Cancel Button (Blue/Red)
                          FilledButton(
                            onPressed: () {
                              if (controller.isEditMode.value) {
                                controller.isEditMode.value = false;
                                controller.isUpdateMode.value = false;
                              } else {
                                controller.isEditMode.value = true;
                              }
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: controller.isEditMode.value ? MyColors.activeRed : MyColors.activeBlue,
                            ),
                            child: Text(
                              controller.isEditMode.value ? 'Cancel' : 'Edit',
                            ),
                          ),

                          // Add Event Button (Green)
                          if (controller.isEditMode.value && !controller.isUpdateMode.value)
                            FilledButton(
                              onPressed: () {
                                if (controller.selectedClassName.value.isNotEmpty &&
                                    controller.selectedSectionName.value.isNotEmpty &&
                                    controller.selectedDay.value.isNotEmpty) {
                                  Get.dialog(
                                    AddRoutineDialog(
                                      onSubmit: (Event event) {
                                        controller.addEvent(Event(
                                          subject: event.subject,
                                          eventType: event.eventType,
                                          startTime: event.startTime,
                                          endTime: event.endTime,
                                          teacher: event.teacher,
                                          location: event.location,
                                        ));
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
                              },
                              style: FilledButton.styleFrom(backgroundColor: MyColors.activeGreen),
                              child: const Text('Add Event'),
                            ),
                        ],
                      )
                  ],
                ),
              )
                  : const SizedBox.shrink(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Obx(
                  () => controller.events.isNotEmpty
                      ? ListView.builder(
                          itemCount: controller.events.length,
                          itemBuilder: (context, index) {
                            final event = controller.events[index];
                            return EventItem(
                              key: ValueKey(event.startTime),
                              period: index + 1,
                              interval: controller.calculateTimeInterval(
                                  event.startTime, event.endTime),
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
                              isWrite: controller.isEditMode,
                              isStudent: controller.userRole.value=='Student',
                              onDeletePressed: () {
                                controller.deleteEvent(index);
                              },
                              onEditPressed: () {
                                Get.dialog(
                                  AddRoutineDialog(
                                    event: event,
                                    index: index,
                                    onSubmit: (Event updatedEvent) {
                                      controller.updateEvent(
                                          updatedEvent, index);
                                    },
                                  ),
                                  barrierDismissible: false,
                                );
                              },
                            );
                          },
                        )
                      : Center(
                          child: Text(
                              'No Routine Found for ${controller.selectedDay}')),
                ),
              ),
            ),

          ],
        );
      }),
    );
  }

  Widget _buildShimmerList() {
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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final startTimeValue = _startTime.value;
      final endTimeValue = _endTime.value;

      if (startTimeValue == null || endTimeValue == null) {
        Get.snackbar('Error', 'Please select both start and end times.');
        return;
      }
      if (startTimeValue.hour > endTimeValue.hour) {
        Get.snackbar('Error', 'Start time must be before end time');
        return;
      }
      if (startTimeValue.hour == endTimeValue.hour &&
          startTimeValue.minute >= endTimeValue.minute) {
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

        // Await the onSubmit function.  This is crucial.
        await widget.onSubmit(newEvent);

        // Only close the dialog after onSubmit completes SUCCESSFULLY.
        Get.back();
      } catch (e) {
        // Display the error message.  Important for debugging.
        Get.snackbar('Error', 'Failed to submit event: $e');
      } finally {
        isLoading.value = false;
      }
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
                    _eventType.value = value ?? 'Class';
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
                    // Wrap MyButton with Obx
                    onPressed: _submitForm, // Remove Get.back() here
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
