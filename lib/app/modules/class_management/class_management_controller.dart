import 'package:cambridge_school/app/modules/class_management/class_model.dart';
import 'package:cambridge_school/app/modules/school_management/school_model.dart';
import 'package:cambridge_school/core/utils/constants/enums/class_name.dart';
import 'package:cambridge_school/core/utils/constants/lists.dart';
import 'package:cambridge_school/core/widgets/snack_bar.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nanoid/nanoid.dart';

import '../../../core/utils/constants/enums/schedule_event_type.dart';
import '../routine/routine_model.dart';
import '../school_management/school_repository.dart';
import 'class_repository.dart';

class ClassManagementController extends GetxController {
  // **************************************************************************
  // Repository Declarations
  // **************************************************************************
  final ClassRepository _classRepository =
      ClassRepository();
  final SchoolRepository _schoolRepository =
      SchoolRepository();

  // **************************************************************************
  // Observables - Manage the state of the UI
  // **************************************************************************
  final schoolId = 'dummy_school_1'.obs;
  final availableClassNames = <String>[].obs;
  final selectedClass = Rx<ClassModel?>(null);
  final isLoading = false.obs;
  final isLoadingClass = false.obs;
  final isEditing = false.obs;
  final selectedClassName = ''.obs;
  final classData = ClassData(classId: '', className: ClassName.other, sectionName: []).obs;

  // **************************************************************************
  // Lifecycle Methods
  // **************************************************************************
  @override
  void onInit() {
    super.onInit();
    loadAvailableClassNames();
  }

  // **************************************************************************
  // Data Fetching Methods - Retrieve data from the repositories
  // **************************************************************************
  Future<void> loadAvailableClassNames() async {
    // Changed to public method for easier testing and use outside the class
    isLoading.value = true;
    try {
      availableClassNames.value =
          await _schoolRepository.getAllClassNames(schoolId.value);
    } catch (e) {
      MySnackBar.showErrorSnackBar('Failed to fetch class options: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchClassDetails(String className) async {
    isLoadingClass.value = true;
    selectedClassName.value = className;
    try {
      selectedClass.value = await _classRepository.getClassByClassName(
        schoolId.value,
        className,
      );
    } catch (e) {
      MySnackBar.showErrorSnackBar('Failed to fetch class details: $e');
    } finally {
      isLoadingClass.value = false;
    }
  }

  // **************************************************************************
  // Class Management Methods - Add, Delete, Update Classes
  // **************************************************************************
  void addClassName(String className) {
    if (!availableClassNames.contains(className)) {
      availableClassNames.add(className);
    }
  }

  void deleteClassName(String className) {
    availableClassNames.remove(className);
    if (selectedClass.value?.className.label == className) {
      selectedClass.value = null;
    }
  }

  Future<void> onAddClassButtonPressed(String className) async {
    final classId = nanoid(12);
    final classEnum = ClassNameExtension.fromString(className);

    final newClass = ClassModel(
      id: classId,
      schoolId: schoolId.value,
      className: classEnum,
      academicYear: '${DateTime.now().year} - ${DateTime.now().year + 1}',
      sections: [],
      subjects: [],
      examSyllabus: [],
    );

    await addClassToFirebase(newClass); //Removed underscore
    await _schoolRepository.addOrUpdateClassData(
      schoolId.value,
      ClassData(classId: classId, className: ClassNameExtension.fromString(className), sectionName: []),
    );
    classData.value =
        ClassData(classId: classId, className: ClassNameExtension.fromString(className), sectionName: []);

    loadAvailableClassNames(); // Removed underscore
  }

  // **************************************************************************
  // Section Management Methods - Add, Delete, Update Sections
  // **************************************************************************
  void addSection(SectionModel section) {
    selectedClass.update((val) {
      val?.sections.add(section);
      sortSections();
    });
  }

  void updateSectionAtIndex(int index, SectionModel updatedSection) {
    selectedClass.update((val) {
      if (val != null && index >= 0 && index < val.sections.length) {
        val.sections[index] = updatedSection;
        sortSections();
      } else {
        MySnackBar.showAlertSnackBar('Invalid section index.');
      }
    });
  }

  void sortSections() {
    selectedClass.value?.sections.sort((a, b) {
      final nameA = a.sectionName;
      final nameB = b.sectionName;
      return nameA.compareTo(nameB);
    });
    selectedClass.refresh(); // Ensure UI update after sort
  }

  void deleteSection(String sectionName) {
    selectedClass.update((val) {
      val?.sections
          .removeWhere((section) => section.sectionName == sectionName);
      sortSections();
    });
  }

  // This method is crucial for keeping classData.value.sectionName in sync
  void updateClassDataSections() {
    if (selectedClass.value != null) {
      classData.value = classData.value.copyWith(
        classId: selectedClass.value!.id,
        className: selectedClass.value!.className,
        sectionName: selectedClass.value!.sections
            .map((section) => section.sectionName)
            .toList()
          ..sort(),
      );
    }
  }

  // **************************************************************************
  // Subject Management Methods - Add, Delete Subjects
  // **************************************************************************
  void addSubject(String subject) {
    selectedClass.update((val) {
      val?.subjects.add(subject);
    });
  }

  void deleteSubject(String subject) {
    selectedClass.update((val) {
      val?.subjects.remove(subject);
    });
  }

  // **************************************************************************
  // Firebase Interaction Methods - Communicate with Firestore
  // **************************************************************************
  Future<void> updateClassToFirebase() async {
    if (selectedClass.value != null) {
      try {
        await _classRepository.updateClass(selectedClass.value!);
        updateClassDataSections();
        _schoolRepository.addOrUpdateClassData(schoolId.value, classData.value);
        MySnackBar.showSuccessSnackBar('Class updated successfully!');
      } catch (e) {
        MySnackBar.showErrorSnackBar('Failed to update class: $e');
      }
    } else {
      MySnackBar.showAlertSnackBar('No class selected to update.');
    }
  }

  Future<void> addClassToFirebase(ClassModel classModel) async {
    //Removed underscore
    try {
      final newClassId = await _classRepository.addClass(classModel);
      if (newClassId != null) {
        availableClassNames.add(classModel.className.label);
        MySnackBar.showSuccessSnackBar('Class added successfully!');
      } else {
        MySnackBar.showErrorSnackBar('Failed to add class');
      }
    } catch (e) {
      MySnackBar.showErrorSnackBar('Failed to add class: $e');
    }
  }

  Future<void> deleteClassFromFirebase(ClassModel classModel) async {
    if (selectedClass.value != null) {
      try {
        await _classRepository.deleteClass(classModel.id);
        _schoolRepository.addOrUpdateClassData(schoolId.value, classData.value);
        deleteClassName(selectedClassName.value);
        MySnackBar.showSuccessSnackBar('Class deleted successfully!');
      } catch (e) {
        MySnackBar.showErrorSnackBar('Failed to delete class: $e');
      }
    } else {
      MySnackBar.showAlertSnackBar('No class selected to delete.');
    }
  }

  // **************************************************************************
  // Update Methods - Update specific properties and trigger UI refresh
  // **************************************************************************
  void updateSubject(String oldSubject, String newSubject) {
    selectedClass.update((val) {
      if (val == null) return;
      final index = val.subjects.indexOf(oldSubject);
      if (index != -1) {
        val.subjects[index] = newSubject;
      }
    });
  }

  void updateClassName(String newClassName) async {
    final oldClassName = selectedClassName.value;
    selectedClassName.value = newClassName;

    selectedClass.update((val) {
      if (val == null) return;
      selectedClass.value = selectedClass.value!
          .copyWith(className: ClassNameExtension.fromString(newClassName));
    });

    classData.value = classData.value.copyWith(className: ClassNameExtension.fromString(newClassName));

    try {
      await updateClassToFirebase();
      // Update the availableClassNames list
      availableClassNames.remove(oldClassName);
      availableClassNames.add(newClassName);
    } catch (e) {
      // Revert back the changes if update fails
      selectedClassName.value = oldClassName;
      selectedClass.update((val) {
        if (val == null) return;
        selectedClass.value = selectedClass.value!
            .copyWith(className: ClassNameExtension.fromString(oldClassName));
      });
      classData.value = classData.value.copyWith(className: ClassNameExtension.fromString(oldClassName));
      MySnackBar.showErrorSnackBar('Failed to update class name: $e');
    }
    selectedClass.refresh();
  }

  Future<void> generateAndUploadDummyClasses() async {
    final faker = Faker();
    final ClassRepository classRepository =
        ClassRepository();

    for (int i = 0; i < 4; i++) {
      // Generate ClassModel ID.  Consider using a consistent method if you need predictable IDs.
      final String classId = faker.guid.guid();
      // final String schoolId = faker.guid.guid();
      List<String> subjects = List.generate(
        5,
        (i) => MyLists.subjectOptions[i % MyLists.subjectOptions.length],
      );
      final ClassModel classModel = ClassModel(
        id: classId,
        schoolId: schoolId.value,
        academicYear: faker.date.dateTime().year.toString(),
        className: ClassName
            .values[i % ClassName.values.length], // Cycle through class names
        sections: _generateDummySections(faker),
        subjects: subjects,
        examSyllabus: _generateDummyExamSyllabi(faker),
      );
      print('classmodel ${classModel.toString()}');
      try {
        await classRepository.addClass(classModel);
        print('Uploaded dummy class ${i + 1} with ID: $classId');
      } catch (e) {
        print('Error uploading class ${i + 1}: $e');
      }
    }

    print('Finished generating and uploading dummy class data.');
  }

// Helper functions to generate dummy data for nested models
  List<SectionModel> _generateDummySections(Faker faker) {
    return List.generate(3, (index) {
      return SectionModel(
        sectionName: String.fromCharCode(65 + index), // A, B, C
        classTeacherId: faker.guid.guid(),
        classTeacherName: faker.person.name(),
        capacity: faker.randomGenerator.integer(30, min: 20),
        roomNumber: faker.randomGenerator.integer(20).toString(),
        students: _generateDummyStudents(faker),
        routine: _generateDummyRoutines(faker),
      );
    });
  }

  List<Student> _generateDummyStudents(Faker faker) {
    return List.generate(10, (index) {
      return Student(
        id: faker.guid.guid(),
        name: faker.person.name(),
        roll: (index + 1).toString(),
      );
    });
  }

  List<DailyRoutine> _generateDummyRoutines(Faker faker) {
    const daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ];
    return List.generate(6, (index) {
      return DailyRoutine(
        day: daysOfWeek[index % daysOfWeek.length],
        events: _generateDummyEvents(faker),
      );
    });
  }

  List<Event> _generateDummyEvents(Faker faker) {
    return List.generate(5, (index) {
      return Event(
        subject: MyLists.eventTypeOptions[index],
        eventType: ScheduleEventType.values[index],
        startTime: TimeOfDay(
            hour: faker.randomGenerator.integer(12, min: 8), minute: 0),
        endTime: TimeOfDay(
            hour: faker.randomGenerator.integer(13, min: 1), minute: 30),
        teacherName: faker.person.name(),
        teacherId: faker.guid.guid(),
        location: faker.address.streetName(),
      );
    });
  }

  List<ExamSyllabus> _generateDummyExamSyllabi(Faker faker) {
    return List.generate(6, (index) {
      return ExamSyllabus(
        examName: MyLists.examOptions[index],
        subjects: _generateDummyExamSubjects(faker),
        createdAt: faker.date.dateTime(),
        updatedAt: faker.date.dateTime(),
      );
    });
  }

  List<ExamSubject> _generateDummyExamSubjects(Faker faker) {
    return List.generate(5, (index) {
      return ExamSubject(
        subjectName: MyLists.subjectOptions[index],
        topics: _generateDummyTopics(faker),
        examDate: faker.date.dateTime(),
        totalMarks: faker.randomGenerator.decimal(scale: 100),
        examType: faker.lorem.word(),
      );
    });
  }

  List<Topic> _generateDummyTopics(Faker faker) {
    return List.generate(10, (_) {
      return Topic(
        topicName: faker.lorem.word(),
        subtopics: List.generate(3, (_) => faker.lorem.word()),
        topicMarks: faker.randomGenerator.decimal(scale: 20),
      );
    });
  }
}
