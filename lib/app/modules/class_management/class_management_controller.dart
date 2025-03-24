import 'package:cambridge_school/app/modules/class_management/class_model.dart';
import 'package:cambridge_school/app/modules/school_management/school_model.dart';
import 'package:cambridge_school/core/utils/constants/enums/class_name.dart';
import 'package:cambridge_school/core/utils/constants/enums/schedule_event_type.dart';
import 'package:cambridge_school/core/utils/constants/lists.dart';
import 'package:cambridge_school/core/widgets/full_screen_loading_widget.dart';
import 'package:cambridge_school/core/widgets/snack_bar.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nanoid/nanoid.dart';

import '../routine/routine_model.dart';
import '../school_management/school_repository.dart';
import 'class_repository.dart';

class ClassManagementController extends GetxController {
  // **************************************************************************
  // Repository Declarations
  // **************************************************************************
  final ClassRepository _classRepository = ClassRepository();
  final SchoolRepository _schoolRepository = SchoolRepository();

  // **************************************************************************
  // Observables - Manage the state of the UI
  // **************************************************************************
  final schoolId = 'dummy_school_1'.obs;
  final availableClassNames = <String>[].obs;
  final classModels = Rx<ClassModel?>(null);
  final isLoading = false.obs;
  final isLoadingClass = false.obs;
  final isEditMode = false.obs;
  final selectedClassName = ''.obs;
  final classData =
      ClassData(classId: '', className: ClassName.other, sectionName: []).obs;

  // **************************************************************************
  // Lifecycle Methods
  // **************************************************************************
  @override
  void onInit() {
    super.onInit();
    fetchClassNames();
  }

  // **************************************************************************
  // Data Fetching Methods - Retrieve data from the repositories
  // **************************************************************************
  Future<void> fetchClassNames() async {
    isLoading.value = true;
    try {
      availableClassNames.value =
          await _schoolRepository.getClassNames(schoolId.value);
      // availableClassNames.value=sortClassList(availableClassNames);
    } catch (e) {
      MySnackBar.showErrorSnackBar('Failed to fetch class options: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchClass(String className) async {
    isLoadingClass.value = true;
    selectedClassName.value = className;
    try {
      classModels.value = await _classRepository.getClassByClassName(
        schoolId.value,
        className,
      );

      // Update RxList correctly by assigning a new list
      // availableClassNames.assignAll(sortClassList(availableClassNames.toList()));
    } catch (e) {
      MySnackBar.showErrorSnackBar('Failed to fetch class details: $e');
    } finally {
      isLoadingClass.value = false;
    }
  }

  /// Sorts a list of class name strings according to class sequence.
  List<String> sortClassList(List<String> classList) {
    List<String> classList1 = [
      'Pre-Nursery', 'Nursery', 'LKG', 'UKG', '1', '2', '3', '4', '5',
      '6', '7', '8', '9', '10', '11', '12'
    ];

    // Sort while handling missing classes
    classList.sort((a, b) {
      int indexA = classList1.indexOf(a);
      int indexB = classList1.indexOf(b);

      // If a class is not found in the predefined list, push it to the end
      indexA = indexA == -1 ? 999 : indexA;
      indexB = indexB == -1 ? 999 : indexB;

      return indexA.compareTo(indexB);
    });

    return classList;
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
    if (classModels.value?.className.label == className) {
      classModels.value = null;
    }
  }

  // **************************************************************************
  // Section Management Methods - Add, Delete, Update Sections
  // **************************************************************************

  void sortSections() {
    classModels.value?.sections.sort((a, b) {
      final nameA = a.sectionName;
      final nameB = b.sectionName;
      return nameA.compareTo(nameB);
    });
    classModels.refresh();
  }

  void updateClassDataSections() {
    if (classModels.value != null) {
      classData.value = classData.value.copyWith(
        classId: classModels.value!.id,
        className: classModels.value!.className,
        sectionName: classModels.value!.sections
            .map((section) => section.sectionName)
            .toList()
          ..sort(),
      );
    }
  }

  // **************************************************************************
  // Firebase Interaction Methods - Communicate with Firestore
  // **************************************************************************
  Future<void> updateClassToFirebase() async {
    if (classModels.value != null) {
      try {
        MyFullScreenLoading.show(loadingText: 'Saving');
        await _classRepository.updateClass(classModels.value!);
        updateClassDataSections();
        _schoolRepository.updateClassInSchool(schoolId.value, classData.value);
        MyFullScreenLoading.hide();
        MySnackBar.showSuccessSnackBar('Class updated successfully!');
      } catch (e) {
        MySnackBar.showErrorSnackBar('Failed to update class: $e');
      }
    } else {
      MySnackBar.showAlertSnackBar('No class selected to update.');
    }
  }

  Future<void> addClassToFirebase(String className) async {
    try {
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

      // Try adding the class to Firestore first
      final newClassId = await _classRepository.addClass(newClass);

      if (newClassId == null) {
        MySnackBar.showErrorSnackBar('Failed to add class');
        return;
      }

      // Only update local state after a successful Firestore operation
      classModels.value = newClass;
      availableClassNames.add(newClass.className.label);
      availableClassNames.refresh();

      classData.value = ClassData(
        classId: classId,
        className: classEnum,
        sectionName: [],
      );
      selectedClassName.value = className;
      selectedClassName.refresh();


      MySnackBar.showSuccessSnackBar('Class added successfully!');
    } catch (e) {
      MySnackBar.showErrorSnackBar('Failed to add class: $e');
    }
  }

  Future<void> deleteClassFromFirebase(ClassModel classModel) async {
    if (classModels.value != null) {
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
  // Dummy Data Generation Methods
  // **************************************************************************

  Future<void> generateAndUploadDummyClasses() async {
    final faker = Faker();
    final ClassRepository classRepository = ClassRepository();

    for (int i = 0; i < 4; i++) {
      final String classId = nanoid(12);
      List<String> subjects = List.generate(
        5,
        (i) => MyLists.subjectOptions[i % MyLists.subjectOptions.length],
      );
      final ClassModel classModel = ClassModel(
        id: classId,
        schoolId: schoolId.value,
        academicYear: '${DateTime.now().year} - ${DateTime.now().year + 1}',
        className: ClassName.values[i % ClassName.values.length],
        sections: _generateDummySections(faker),
        subjects: subjects,
        examSyllabus: _generateDummyExamSyllabi(faker),
      );

      try {
        await classRepository.addClass(classModel);
        print('Uploaded dummy class ${i + 1} with ID: $classId');
      } catch (e) {
        print('Error uploading class ${i + 1}: $e');
      }
    }

    print('Finished generating and uploading dummy class data.');
  }

  List<SectionModel> _generateDummySections(Faker faker) {
    return List.generate(3, (index) {
      return SectionModel(
        sectionName: String.fromCharCode(65 + index),
        classTeacherId: faker.guid.guid(),
        classTeacherName: faker.person.name(),
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
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    });
  }

  List<ExamSubject> _generateDummyExamSubjects(Faker faker) {
    return List.generate(5, (index) {
      return ExamSubject(
        subjectName: MyLists.subjectOptions[index],
        topics: _generateDummyTopics(faker),
        examDate: DateTime.now(),
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
