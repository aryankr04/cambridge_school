import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExamPattern {
  final RxString examName;
  final RxString classId;
  final RxString section;
  final RxList<Subject> subjects;

  ExamPattern({
    required String examName,
    required String classId,
    required String section,
    required List<Subject> subjects,
  })  : examName = RxString(examName),
        classId = RxString(classId),
        section = RxString(section),
        subjects = RxList<Subject>(subjects);

  // Method to add a subject
  void addSubject(Subject subject) {
    subjects.add(subject);
  }

  // Method to remove a subject
  void removeSubject(int index) {
    subjects.removeAt(index);
  }

  // Method to update a subject
  void updateSubject(int index, Subject updatedSubject) {
    subjects[index] = updatedSubject;
  }
}

class Subject {
  final RxString name;
  final RxString totalMarks;
  final RxList<Category> categories;

  Subject({
    required String name,
    required String totalMarks,
    required List<Category> categories,
  })  : name = RxString(name),
        totalMarks = RxString(totalMarks),
        categories = RxList<Category>(categories);

  // Method to add a category
  void addCategory(Category category) {
    categories.add(category);
  }

  // Method to remove a category
  void removeCategory(int index) {
    categories.removeAt(index);
  }

  // Method to update a category
  void updateCategory(int index, Category updatedCategory) {
    categories[index] = updatedCategory;
  }
}
class Category {
  String name;
  TextEditingController marksController;

  Category({
    required this.name,
    required this.marksController,
  });
}