import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/utils/constants/text_styles.dart';
import 'package:cambridge_school/core/utils/formatters/date_time_formatter.dart';
import 'package:cambridge_school/core/widgets/bottom_sheet_dropdown.dart';
import 'package:cambridge_school/core/widgets/card_widget.dart';
import 'package:cambridge_school/app/modules/class_management/class_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'create_exam_controller.dart';

class ExamSyllabusForm extends GetView<CreateExamController> {
  const ExamSyllabusForm({super.key});

  @override
  Widget build(BuildContext context) {
    return _ExamSyllabusFormView();
  }
}

class _ExamSyllabusFormView extends GetView<CreateExamController> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController examNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text('Exam Syllabus'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildFilterSection(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (controller.classModel.value == null) {
                  return const _EmptyStateWidget();
                } else {
                  return _buildExamSyllabusForm(controller.classModel.value!);
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExamSyllabusForm(ClassModel classModel) {
    final examSyllabusList = classModel.examSyllabus;

    // Initialize examNameController with existing data if available
    if (examSyllabusList.isNotEmpty && examNameController.text.isEmpty) {
      examNameController.text = examSyllabusList.first.examName;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(MySizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (examSyllabusList.isNotEmpty)
            _buildExamSyllabus(examSyllabusList.first)
          else
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "No syllabus created for this class yet.",
                style: MyTextStyle.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                print('Syllabus Data: ${classModel.examSyllabus}');
                //controller.submitForm(classModel.examSyllabus); // Example of a submit function
              }
            },
            icon: const Icon(Icons.save, size: MySizes.iconSm),
            label: const Text(
              'Save Syllabus',
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: MySizes.md),
              backgroundColor: MyColors.activeGreen, // Custom button color
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamSyllabus(ExamSyllabus syllabus) {
    return MyCard(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              syllabus.examName,
              style: MyTextStyle.headlineSmall,
            ),
          ],
        ),
        Text(
          MyDateTimeFormatter.formatPrettyDateTime(syllabus.createdAt),
          style: MyTextStyle.labelMedium,
        ),
        const SizedBox(
          height: MySizes.md,
        ),
        ExpansionTile(
          leading: const Icon(Icons.subject, color: MyColors.activeBlue),
          minTileHeight: 24,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
            side: BorderSide.none,
          ),
          collapsedShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide.none,
          ),
          tilePadding: const EdgeInsets.symmetric(vertical: MySizes.xs),
          initiallyExpanded: true,
          title: Text(
            'Subjects (${syllabus.subjects.length})',
            style: MyTextStyle.titleMedium,
          ),
          children: [
            if (syllabus.subjects.isEmpty)
              const Padding(
                padding: EdgeInsets.all(MySizes.sm),
                child: Text(
                  'No subjects found',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: syllabus.subjects.length,
                itemBuilder: (context, index) {
                  final subject = syllabus.subjects[index];
                  return _buildSubject(subject);
                },
              ),
          ],
        ),
        const SizedBox(height: MySizes.sm),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            icon: const Icon(Icons.add,
                color: MyColors.activeBlue, size: MySizes.iconSm),
            onPressed: () {},
            label: const Text('Add Subject',
                style: TextStyle(color: MyColors.activeBlue)),
          ),
        ),
      ],
    ));
  }

  Widget _buildSubject(ExamSubject subject) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: MyColors.dividerColor, width: 1),
        borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
      ),
      margin: const EdgeInsets.only(bottom: MySizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: MySizes.md, vertical: MySizes.xs),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: Get.width * 0.1,
                      height: Get.width * 0.1,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(MySizes.cardRadiusXs),
                          border: Border.all(
                              width: 0.5, color: MyColors.borderColor)),
                      child: const Text('🧪', style: TextStyle(fontSize: 20)),
                    ),
                    const SizedBox(
                      width: MySizes.md,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(subject.subjectName,
                            style: MyTextStyle.titleLarge),
                        Text(
                            'Exam Date: ${MyDateTimeFormatter.formatPrettyLongDate(subject.examDate)}',
                            style: MyTextStyle.labelSmall),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.delete,
                      color: MyColors.activeRed, size: MySizes.iconMd),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const Divider(
            color: MyColors.dividerColor,
            height: 1,
            thickness: .5,
          ),
          Padding(
            padding: const EdgeInsets.all(MySizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      color: MyColors.iconColor,
                      size: 18,
                    ),
                    const SizedBox(
                      width: MySizes.md,
                    ),
                    Text(
                        'Total Marks: ${subject.totalMarks.toStringAsFixed(2)}',
                        style: MyTextStyle.titleSmall.copyWith(fontSize: 14)),
                  ],
                ),
                const SizedBox(
                  height: MySizes.md,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.assignment,
                      color: MyColors.iconColor,
                      size: 18,
                    ),
                    const SizedBox(
                      width: MySizes.md,
                    ),
                    Text('Exam Type: ${subject.examType.label}',
                        style: MyTextStyle.titleSmall.copyWith(fontSize: 14)),
                  ],
                ),
                const SizedBox(
                  height: MySizes.sm,
                ),
                ExpansionTile(
                  leading: const Icon(
                    Icons.topic,
                    color: MyColors.iconColor,
                    size: 18,
                  ),
                  minTileHeight: 24,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
                    side: BorderSide.none,
                  ),
                  collapsedShape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: BorderSide.none,
                  ),
                  initiallyExpanded: true,
                  tilePadding: EdgeInsets.zero,
                  title: Text(
                    'Topics (${subject.topics.length})',
                    style: MyTextStyle.titleSmall.copyWith(fontSize: 14),
                  ),
                  children: [
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: subject.topics.length,
                      itemBuilder: (context, index) {
                        final topic = subject.topics[index];
                        return _buildTopic(
                            topic); // You can also pass `index` if needed
                      },
                    ),
                  ],
                ),
                ExpansionTile(
                  leading: const Icon(
                    Icons.assessment,
                    color: MyColors.iconColor,
                    size: 18,
                  ),
                  minTileHeight: 24,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
                    side: BorderSide.none,
                  ),
                  collapsedShape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: BorderSide.none,
                  ),
                  tilePadding: EdgeInsets.zero,
                  title: Text(
                    'Assessments (${subject.assessmentComponents.length})',
                    style: MyTextStyle.titleSmall.copyWith(fontSize: 14),
                  ),
                  children: [
                    if (subject.assessmentComponents.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(MySizes.sm),
                        child: Text(
                          'No assessments available',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    else
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: subject.assessmentComponents.length,
                        itemBuilder: (context, index) {
                          final assessment =
                              subject.assessmentComponents[index];
                          return _buildAssessment(assessment);
                        },
                      ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAssessment(AssessmentComponent assessment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: MySizes.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(assessment.type.label, style: MyTextStyle.bodyLarge),
              Text('${assessment.marks!.toStringAsFixed(2)} Marks',
                  style: MyTextStyle.labelMedium),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.delete,
                    color: MyColors.activeRed, size: MySizes.iconSm),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.edit,
                    color: MyColors.activeBlue, size: MySizes.iconSm),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopic(SyllabusTopic topic) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
          border: Border.all(width: 0.5, color: MyColors.borderColor)),
      margin: const EdgeInsets.only(
        bottom: MySizes.md,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: MySizes.md, vertical: MySizes.xs),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Container(
                    //   padding: const EdgeInsets.all(MySizes.sm - 2),
                    //   decoration: const BoxDecoration(
                    //     shape: BoxShape.circle,
                    //     color: MyColors.activeBlue,
                    //   ),
                    //   child: Text(
                    //     '1',
                    //     style: MyTextStyle.labelLarge.copyWith(
                    //         color: Colors.white, fontWeight: FontWeight.bold),
                    //   ),
                    // ),
                    // const SizedBox(width: MySizes.md),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(topic.topicName, style: MyTextStyle.bodyLarge),
                        Text(
                            '${topic.topicMarksWeight.toStringAsFixed(2)} Marks',
                            style: MyTextStyle.labelMedium),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete,
                          color: MyColors.activeRed, size: 18),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit,
                          color: MyColors.activeBlue, size: 18),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            color: MyColors.dividerColor,
            height: 1,
            thickness: .5,
          ),
          Padding(
            padding: const EdgeInsets.all(MySizes.md),
            child: ExpansionTile(
              leading: const Icon(
                Icons.list_alt,
                color: MyColors.iconColor,
                size: 18,
              ),
              minTileHeight: 24,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
                side: BorderSide.none,
              ),
              collapsedShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
                side: BorderSide.none,
              ),
              tilePadding: EdgeInsets.zero,
              initiallyExpanded: true,
              title: Text(
                'Subtopics (${topic.subtopics.length})',
                style: MyTextStyle.bodyLarge,
              ),
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: topic.subtopics.length,
                  itemBuilder: (context, index) {
                    final subtopic = topic.subtopics[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: MySizes.xs),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: MyColors.activeBlue,
                            radius: 3,
                          ),
                          const SizedBox(width: MySizes.sm),
                          Expanded(
                            child: Text(
                              subtopic,
                              style: MyTextStyle.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    icon: const Icon(
                      Icons.add,
                      color: MyColors.activeBlue,
                      size: MySizes.iconSm,
                    ),
                    onPressed: () {
                      // TODO: Add Subtopic logic
                    },
                    label: const Text(
                      'Add Subtopic',
                      style: TextStyle(color: MyColors.activeBlue),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const Icon(
              Icons.filter_list,
              color: MyColors.subtitleTextColor,
              size: MySizes.iconMd,
            ),
            const SizedBox(width: MySizes.md),
            _buildClassDropdown(),
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
      hintText: 'Select Class',
      selectedValue: controller.selectedClassName,
    );
  }
}

class _EmptyStateWidget extends StatelessWidget {
  const _EmptyStateWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 50, color: MyColors.subtitleTextColor),
          SizedBox(height: MySizes.sm),
          Text("No class data found. Select a class to load syllabus.",
              style: MyTextStyle.bodyLarge, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
//
// class SubjectForm extends StatefulWidget {
//   final ExamSubject subject;
//   final Function(ExamSubject) onSubjectChanged;
//
//   const SubjectForm({
//     super.key,
//     required this.subject,
//     required this.onSubjectChanged,
//   });
//
//   @override
//   _SubjectFormState createState() => _SubjectFormState();
// }
//
// class _SubjectFormState extends State<SubjectForm> {
//   late TextEditingController subjectNameController;
//   late TextEditingController totalMarksController;
//   late RxString selectedExamType;
//   Rx<DateTime> selectedDate = DateTime.now().obs;
//   List<SyllabusTopic> topics = [];
//   List<AssessmentComponent> assessmentComponents = [];
//
//   @override
//   void initState() {
//     super.initState();
//     subjectNameController =
//         TextEditingController(text: widget.subject.subjectName);
//     totalMarksController =
//         TextEditingController(text: widget.subject.totalMarks.toString());
//     selectedExamType.value = widget.subject.examType.label;
//     selectedDate.value = widget.subject.examDate;
//     topics = List.from(widget.subject.topics);
//     assessmentComponents = List.from(widget.subject.assessmentComponents);
//   }
//
//   @override
//   void didUpdateWidget(covariant SubjectForm oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.subject != oldWidget.subject) {
//       subjectNameController.text = widget.subject.subjectName;
//       totalMarksController.text = widget.subject.totalMarks.toString();
//       selectedExamType.value = widget.subject.examType.value;
//       selectedDate.value = widget.subject.examDate;
//       topics = List.from(widget.subject.topics);
//       assessmentComponents = List.from(widget.subject.assessmentComponents);
//     }
//   }
//
//   @override
//   void dispose() {
//     subjectNameController.dispose();
//     totalMarksController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         MyTextField(
//           controller: subjectNameController,
//           labelText: 'Subject Name',
//           onChanged: (value) {
//             ExamSubject updatedSubject =
//                 widget.subject.copyWith(subjectName: value);
//             widget.onSubjectChanged(updatedSubject);
//           },
//         ),
//         MyTextField(
//           controller: totalMarksController,
//           labelText: 'Total Marks',
//           keyboardType: TextInputType.number,
//           onChanged: (value) {
//             ExamSubject updatedSubject = widget.subject
//                 .copyWith(totalMarks: double.tryParse(value) ?? 0.0);
//             widget.onSubjectChanged(updatedSubject);
//           },
//         ),
//         MyBottomSheetDropdown(
//             labelText: 'Exam Type',
//             optionsForChips: ExamType.values.map((e) => e.label).toList(),
//             selectedValue: widget.subject.examType.label.obs,
//             onSingleChanged: (value) {
//               ExamSubject updatedComponent =
//                   widget.subject.copyWith(examType: ExamType.fromString(value));
//               widget.onSubjectChanged(updatedComponent);
//             }),
//         MyDatePickerField(
//           labelText: 'Exam Date',
//           selectedDate: selectedDate,
//           firstDate: DateTime.now(),
//           lastDate: DateTime(DateTime.now().year + 5),
//           onDateChanged: (DateTime newDate) {
//             ExamSubject updatedSubject =
//                 widget.subject.copyWith(examDate: newDate);
//             widget.onSubjectChanged(updatedSubject);
//           },
//         ),
//         const SizedBox(height: 10),
//         const Row(
//           children: [
//             Text('Topics', style: MyTextStyle.headlineSmall),
//             SizedBox(width: MySizes.sm),
//             Expanded(child: MyDottedLine(dashColor: MyColors.iconColor)),
//           ],
//         ),
//         ..._buildTopicsList(),
//         FilledButton(
//           onPressed: () {
//             final newTopic = SyllabusTopic(
//                 topicName: '', subtopics: [], topicMarksWeight: 0.0);
//             final updatedTopics = List<SyllabusTopic>.from(topics)
//               ..add(newTopic);
//             ExamSubject updatedSubject =
//                 widget.subject.copyWith(topics: updatedTopics);
//             widget.onSubjectChanged(updatedSubject);
//             setState(() {});
//           },
//           child: const Text('Add Topic'),
//         ),
//         const SizedBox(height: 10),
//         const Row(
//           children: [
//             Text('Assessments', style: MyTextStyle.titleLarge),
//             SizedBox(width: MySizes.sm),
//             Expanded(child: MyDottedLine(dashColor: MyColors.iconColor)),
//           ],
//         ),
//         ..._buildAssessmentComponentsList(),
//         FilledButton(
//           onPressed: () {
//             final newComponent =
//                 AssessmentComponent(type: AssessmentType.theory, marks: 0);
//             final updatedComponents =
//                 List<AssessmentComponent>.from(assessmentComponents)
//                   ..add(newComponent);
//             ExamSubject updatedSubject = widget.subject
//                 .copyWith(assessmentComponents: updatedComponents);
//             widget.onSubjectChanged(updatedSubject);
//             setState(() {});
//           },
//           child: const Text('Add Assessment'),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTopic(SyllabusTopic topic) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(topic.topicName, style: MyTextStyle.bodyLarge),
//                 Text('${topic.topicMarksWeight.toStringAsFixed(2)} Marks',
//                     style: MyTextStyle.labelMedium),
//               ],
//             ),
//             Row(
//               children: [
//                 IconButton(
//                     onPressed: () {},
//                     icon: const Icon(
//                       Icons.delete,
//                       color: MyColors.activeRed,
//                       size: 20,
//                     )),
//                 IconButton(
//                     onPressed: () {},
//                     icon: const Icon(
//                       Icons.edit,
//                       color: MyColors.activeBlue,
//                       size: 20,
//                     )),
//               ],
//             ),
//           ],
//         ),
//         ExpansionTile(
//             minTileHeight: 24,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
//               side: BorderSide.none,
//             ),
//             collapsedShape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(0.0),
//               side: BorderSide.none,
//             ),
//             tilePadding: const EdgeInsets.symmetric(vertical: MySizes.xs),
//             initiallyExpanded: true,
//             title: const Text('Sub-topics'),
//             children: topic.subtopics
//                 .map((e) => Row(
//                       children: [
//                         const CircleAvatar(
//                           backgroundColor: MyColors.activeBlue,
//                           radius: 3,
//                         ),
//                         const SizedBox(
//                           width: MySizes.sm,
//                         ),
//                         Text(
//                           e,
//                           style: MyTextStyle.labelSmall.copyWith(fontSize: 13),
//                         ),
//                       ],
//                     ))
//                 .toList()),
//         Align(
//           alignment: Alignment.centerRight,
//           child: TextButton.icon(
//             icon: const Icon(Icons.add, color: MyColors.activeBlue, size: 18),
//             onPressed: () {},
//             label: const Text('Add Subtopic',
//                 style: TextStyle(color: MyColors.activeBlue)),
//           ),
//         )
//       ],
//     );
//   }
//
//   Widget _buildAssessment(AssessmentComponent assessment) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(assessment.type.label, style: MyTextStyle.bodyLarge),
//                 Text('${assessment.marks!.toStringAsFixed(2)} Marks',
//                     style: MyTextStyle.labelMedium),
//               ],
//             ),
//             Row(
//               children: [
//                 IconButton(
//                     onPressed: () {},
//                     icon: const Icon(
//                       Icons.delete,
//                       color: MyColors.activeRed,
//                       size: 20,
//                     )),
//                 IconButton(
//                     onPressed: () {},
//                     icon: const Icon(
//                       Icons.edit,
//                       color: MyColors.activeBlue,
//                       size: 20,
//                     )),
//               ],
//             ),
//           ],
//         ),
//         Align(
//           alignment: Alignment.centerRight,
//           child: TextButton.icon(
//             icon: const Icon(Icons.add, color: MyColors.activeBlue, size: 18),
//             onPressed: () {},
//             label: const Text('Add Assessment',
//                 style: TextStyle(color: MyColors.activeBlue)),
//           ),
//         )
//       ],
//     );
//   }
//
//   List<Widget> _buildTopicsList() {
//     return topics.asMap().entries.map((entry) {
//       int index = entry.key;
//       SyllabusTopic topic = entry.value;
//
//       return MyCard(
//         margin: const EdgeInsets.symmetric(vertical: 8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [_buildTopic(topic)],
//         ),
//       );
//     }).toList();
//   }
//
//   List<Widget> _buildAssessmentComponentsList() {
//     return assessmentComponents.asMap().entries.map((entry) {
//       int index = entry.key;
//       AssessmentComponent component = entry.value;
//
//       return MyCard(
//         margin: const EdgeInsets.symmetric(vertical: 8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [_buildAssessment(component)],
//         ),
//       );
//     }).toList();
//   }
// }
//
// class TopicForm extends StatefulWidget {
//   final SyllabusTopic topic;
//   final Function(SyllabusTopic) onTopicChanged;
//
//   const TopicForm({
//     super.key,
//     required this.topic,
//     required this.onTopicChanged,
//   });
//
//   @override
//   _TopicFormState createState() => _TopicFormState();
// }
//
// class _TopicFormState extends State<TopicForm> {
//   late TextEditingController topicNameController;
//   late TextEditingController topicMarksWeightController;
//   List<String> subtopics = [];
//   final TextEditingController subtopicController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     topicNameController = TextEditingController(text: widget.topic.topicName);
//     topicMarksWeightController =
//         TextEditingController(text: widget.topic.topicMarksWeight.toString());
//     subtopics = List.from(widget.topic.subtopics);
//   }
//
//   @override
//   void didUpdateWidget(covariant TopicForm oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.topic != oldWidget.topic) {
//       topicNameController.text = widget.topic.topicName;
//       topicMarksWeightController.text =
//           widget.topic.topicMarksWeight.toString();
//       subtopics = List.from(widget.topic.subtopics);
//     }
//   }
//
//   @override
//   void dispose() {
//     topicNameController.dispose();
//     topicMarksWeightController.dispose();
//     subtopicController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         MyTextField(
//           controller: topicNameController,
//           labelText: 'Topic Name',
//           onChanged: (value) {
//             SyllabusTopic updatedTopic =
//                 widget.topic.copyWith(topicName: value);
//             widget.onTopicChanged(updatedTopic);
//             setState(() {});
//           },
//         ),
//         MyTextField(
//           controller: topicMarksWeightController,
//           labelText: 'Topic Marks Weight',
//           keyboardType: TextInputType.number,
//           onChanged: (value) {
//             SyllabusTopic updatedTopic = widget.topic
//                 .copyWith(topicMarksWeight: double.tryParse(value) ?? 0.0);
//             widget.onTopicChanged(updatedTopic);
//             setState(() {});
//           },
//         ),
//         const SizedBox(height: 10),
//         const Row(
//           children: [
//             Text('Subtopics', style: TextStyle(fontWeight: FontWeight.bold)),
//             SizedBox(width: MySizes.sm),
//             Expanded(child: Divider(color: Colors.grey)),
//           ],
//         ),
//         ..._buildSubtopicsList(),
//         TextButton.icon(
//           icon: const Icon(Icons.add),
//           onPressed: () {
//             setState(() {
//               subtopics.add('');
//               SyllabusTopic updatedTopic =
//                   widget.topic.copyWith(subtopics: List.from(subtopics));
//               widget.onTopicChanged(updatedTopic);
//             });
//           },
//           label: const Text('Add Subtopic'),
//         ),
//       ],
//     );
//   }
//
//   List<Widget> _buildSubtopicsList() {
//     return subtopics.asMap().entries.map((entry) {
//       int index = entry.key;
//
//       return Row(
//         children: [
//           Expanded(
//             child: MyTextField(
//               controller: subtopicController,
//               labelText: 'Subtopic',
//               onChanged: (value) {
//                 final updatedSubtopics = List<String>.from(subtopics);
//                 updatedSubtopics[index] = value;
//                 SyllabusTopic updatedTopic =
//                     widget.topic.copyWith(subtopics: updatedSubtopics);
//                 widget.onTopicChanged(updatedTopic);
//                 setState(() {});
//               },
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.delete, color: Colors.red, size: 20),
//             onPressed: () {
//               setState(() {
//                 final updatedSubtopics = List<String>.from(subtopics)
//                   ..removeAt(index);
//                 SyllabusTopic updatedTopic =
//                     widget.topic.copyWith(subtopics: updatedSubtopics);
//                 widget.onTopicChanged(updatedTopic);
//               });
//             },
//           ),
//         ],
//       );
//     }).toList();
//   }
// }
//
// class AssessmentComponentForm extends StatefulWidget {
//   final AssessmentComponent component;
//   final Function(AssessmentComponent) onComponentChanged;
//
//   const AssessmentComponentForm({
//     super.key,
//     required this.component,
//     required this.onComponentChanged,
//   });
//
//   @override
//   _AssessmentComponentFormState createState() =>
//       _AssessmentComponentFormState();
// }
//
// class _AssessmentComponentFormState extends State<AssessmentComponentForm> {
//   late RxString selectedType;
//   late TextEditingController marksController;
//
//   @override
//   void initState() {
//     super.initState();
//     selectedType = ''.obs;
//     marksController =
//         TextEditingController(text: widget.component.marks?.toString() ?? '');
//   }
//
//   @override
//   void didUpdateWidget(covariant AssessmentComponentForm oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.component != oldWidget.component) {
//       selectedType.value = widget.component.type.label;
//       marksController.text = widget.component.marks?.toString() ?? '';
//     }
//   }
//
//   @override
//   void dispose() {
//     marksController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         MyBottomSheetDropdown(
//             labelText: 'Component Type',
//             optionsForChips: AssessmentType.values.map((e) => e.label).toList(),
//             selectedValue: widget.component.type.label.obs,
//             onSingleChanged: (value) {
//               AssessmentComponent updatedComponent = widget.component
//                   .copyWith(type: AssessmentType.fromString(value));
//               widget.onComponentChanged(updatedComponent);
//             }),
//         MyTextField(
//           controller: marksController,
//           labelText: 'Marks (Optional)',
//           keyboardType: TextInputType.number,
//           onChanged: (value) {
//             AssessmentComponent updatedComponent =
//                 widget.component.copyWith(marks: double.tryParse(value));
//             widget.onComponentChanged(updatedComponent);
//             setState(() {});
//           },
//         ),
//       ],
//     );
//   }
// }
