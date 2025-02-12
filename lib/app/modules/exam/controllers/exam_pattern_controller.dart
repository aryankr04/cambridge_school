import 'package:get/get.dart';

import '../models/exam_pattern_model.dart';

class AddExamController extends GetxController {
  // The reactive exam pattern object
  final examPattern = ExamPattern(
    examName: '',
    classId: '',
    section: '',
    subjects: [],
  ).obs;

  // Add a new subject to the exam
  void addSubject(Subject subject) {
    examPattern.value.addSubject(subject);
    examPattern.refresh();
  }

  // Remove a subject from the exam
  void removeSubject(int index) {
    examPattern.value.removeSubject(index);
    examPattern.refresh();
  }

  // Update an existing subject
  void updateSubject(int index, Subject updatedSubject) {
    examPattern.value.updateSubject(index, updatedSubject);
    examPattern.refresh();
  }
}
