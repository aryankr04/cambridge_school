import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../class_management/class_management_repositories.dart';
import '../../class_management/class_model.dart';
import '../../manage_school/models/school_model.dart';
import '../routine_model.dart';

class CreateRoutineController extends GetxController {
  // Dependencies
  final ClassManagementRepository _classManagementRepository =
  ClassManagementRepository();

  // Rx Variables
  final schoolId = RxString('SCH00001');
  final selectedClassName = RxString('');
  final selectedSectionName = RxString('');
  final selectedDay = RxString('');
  final isLoading = RxBool(false);
  final selectedEventIndex = RxInt(-1);
  final sectionList = RxList<SectionModel>([]);
  Rx<ClassModel?> classModel = Rx<ClassModel?>(null);
  RxList<Event> events = RxList<Event>([]); // Displayed events for selected day
  RxList<String>? sectionNameOptions = RxList<String>();
  RxList<String>? classNameOptions = RxList<String>();
  RxList<SectionData>? sectionsData = RxList<SectionData>();

  // Constants
    List<String> dayOptions = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

  // Lifecycle
  @override
  void onInit() {
    super.onInit();
    fetchSchoolSectionsAndPrepareClassAndSectionOption();
    ever(selectedClassName, (_) => fetchClassData());
    ever(selectedDay, (_) => updateEventListForSelectedDay());
  }

  // ---------------------------------------------------------------------------
  // Data Fetching Methods
  // ---------------------------------------------------------------------------

  Future<void> fetchClassData() async {
    if (schoolId.value.isEmpty || selectedClassName.value.isEmpty) {
      print("School ID or Class Name is empty. Skipping fetch.");
      return;
    }

    isLoading.value = true;
    try {
      final fetchedClassModel =
      await _classManagementRepository.fetchClassByClassNameAndSchoolId(
          schoolId.value, selectedClassName.value);
      classModel.value = fetchedClassModel;
      sectionList.value = classModel.value?.sections ?? [];
      printClassModelStructure();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch class data: $e');
      print('Error fetching class data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSchoolSectionsAndPrepareClassAndSectionOption() async {
    isLoading.value = true;
    try {
      sectionsData?.value =
      await _classManagementRepository.fetchSchoolSections(schoolId.value);

      classNameOptions?.clear();
      sectionNameOptions?.clear();

      Set<String> uniqueClassNames = {};
      for (var sectionData in sectionsData!) {
        uniqueClassNames.add(sectionData.className);
        if (sectionNameOptions?.contains(sectionData.sectionName) == false) {
          sectionNameOptions?.add(sectionData.sectionName);
        }
      }
      classNameOptions?.addAll(uniqueClassNames.toList());
    } catch (error) {
      print('Error fetching school sections: $error');
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // UI Update Methods
  // ---------------------------------------------------------------------------

  void updateEventListForSelectedDay() {
    events.clear();
    final section = classModel.value?.sections?.firstWhereOrNull(
            (section) => section.sectionName == selectedSectionName.value);

    if (section != null && section.routine != null) {
      final dailyRoutine = section.routine!.dailyRoutines.firstWhereOrNull(
              (routine) => routine.day == selectedDay.value);
      if (dailyRoutine != null) {
        events.addAll(dailyRoutine.events);
      }
    }
  }

  // ---------------------------------------------------------------------------
  // CRUD Operations for Events
  // ---------------------------------------------------------------------------

  void addEvent(Event event) {
    addEventToDailyRoutine(event);
    updateEventListForSelectedDay();
  }

  void updateEvent(Event updatedEvent, int index) {
    updateEventInDailyRoutine(updatedEvent, index);
    updateEventListForSelectedDay();
  }

  void deleteEvent(int index) {
    deleteEventInDailyRoutine(index);
    updateEventListForSelectedDay();
  }

  // ---------------------------------------------------------------------------
  // Helper Methods to Manage Events within the ClassModel
  // ---------------------------------------------------------------------------

  Future<void> addEventToDailyRoutine(Event newEvent) async {
    if (!validateClassModelAndSection()) return;

    try {
      isLoading.value = true;
      final sectionIndex = getSectionIndex();
      if (sectionIndex == -1) return;

      WeeklyRoutine? weeklyRoutine = getWeeklyRoutine(sectionIndex);
      weeklyRoutine ??= createNewWeeklyRoutine();

      DailyRoutine? dailyRoutine = getDailyRoutine(weeklyRoutine);
      dailyRoutine ??= createNewDailyRoutine();

      dailyRoutine.events.add(newEvent);

      // await updateClassModel(sectionIndex, weeklyRoutine);
      Get.snackbar('Success', 'Event added successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add event: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateEventInDailyRoutine(
      Event updatedEvent, int eventIndex) async {
    if (!validateClassModelAndSection()) return;

    try {
      isLoading.value = true;
      final sectionIndex = getSectionIndex();
      if (sectionIndex == -1) return;

      WeeklyRoutine? weeklyRoutine = getWeeklyRoutine(sectionIndex);
      if (weeklyRoutine == null) {
        Get.snackbar('Error', 'Routine does not exist in class model.');
        return;
      }

      DailyRoutine? dailyRoutine = getDailyRoutine(weeklyRoutine);
      if (dailyRoutine == null) {
        Get.snackbar('Error', 'Daily routine does not exist in class model.');
        return;
      }

      if (!isValidEventIndex(dailyRoutine, eventIndex)) return;

      dailyRoutine.events[eventIndex] = updatedEvent;

      // await updateClassModel(sectionIndex, weeklyRoutine);
      Get.snackbar('Success', 'Event updated successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update event: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteEventInDailyRoutine(int eventIndex) async {
    if (!validateClassModelAndSection()) return;

    try {
      isLoading.value = true;
      final sectionIndex = getSectionIndex();
      if (sectionIndex == -1) return;

      WeeklyRoutine? weeklyRoutine = getWeeklyRoutine(sectionIndex);
      if (weeklyRoutine == null) {
        Get.snackbar('Error', 'Routine does not exist in class model.');
        return;
      }

      DailyRoutine? dailyRoutine = getDailyRoutine(weeklyRoutine);
      if (dailyRoutine == null) {
        Get.snackbar('Error', 'Daily routine does not exist in class model.');
        return;
      }

      if (!isValidEventIndex(dailyRoutine, eventIndex)) return;

      dailyRoutine.events.removeAt(eventIndex);

      // await updateClassModel(sectionIndex, weeklyRoutine);
      Get.snackbar('Success', 'Event deleted successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete event: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // Utility/Helper Functions
  // ---------------------------------------------------------------------------

  bool validateClassModelAndSection() {
    if (classModel.value == null || selectedSectionName.isEmpty) {
      Get.snackbar('Error',
          'Class model or selected section is empty. Cannot update routine.');
      return false;
    }
    return true;
  }

  int getSectionIndex() {
    final sectionIndex = classModel.value!.sections?.indexWhere(
            (section) => section.sectionName == selectedSectionName.value);
    if (sectionIndex == null || sectionIndex == -1) {
      Get.snackbar('Error', 'Selected section not found in class model.');
      return -1;
    }
    return sectionIndex;
  }

  WeeklyRoutine? getWeeklyRoutine(int sectionIndex) {
    return classModel.value!.sections![sectionIndex].routine;
  }

  DailyRoutine? getDailyRoutine(WeeklyRoutine weeklyRoutine) {
    return weeklyRoutine.dailyRoutines.firstWhereOrNull(
            (routine) => routine.day == selectedDay.value);
  }

  WeeklyRoutine createNewWeeklyRoutine() {
    return WeeklyRoutine(
      id: classModel.value!.id!,
      dailyRoutines: [],
    );
  }

  DailyRoutine createNewDailyRoutine() {
    return DailyRoutine(day: selectedDay.value, events: []);
  }

  bool isValidEventIndex(DailyRoutine dailyRoutine, int eventIndex) {
    if (eventIndex < 0 || eventIndex >= dailyRoutine.events.length) {
      Get.snackbar('Error', 'Invalid event index.');
      return false;
    }
    return true;
  }

  // ---------------------------------------------------------------------------
  // Firebase Update Method
  // ---------------------------------------------------------------------------
  Future<void> updateClassModel() async {
    try {

      // Find the document ID to update
      final classDoc = await FirebaseFirestore.instance
          .collection('classes')
          .where('schoolId', isEqualTo: classModel.value!.schoolId)
          .where('className', isEqualTo: classModel.value!.className)
          .limit(1)
          .get();

      if (classDoc.docs.isNotEmpty) {
        // Get the document ID
        final docId = classDoc.docs.first.id;

        // Update the document in Firebase
        await FirebaseFirestore.instance
            .collection('classes')
            .doc(docId)
            .update(classModel.value!.toMap());

        Get.snackbar('Success', 'Class model updated in Firebase!');
      } else {
        Get.snackbar('Error', 'Class document not found in Firebase.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update class model in Firebase: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Debugging Methods
  // ---------------------------------------------------------------------------

  void printClassModelStructure() {
    if (classModel.value == null) {
      print("ClassModel is null. No data to print.");
      return;
    }

    final ClassModel classData = classModel.value!;

    print("--------------------------------------------------");
    print("Class Data:");
    print("  ID: ${classData.id}");
    print("  School ID: ${classData.schoolId}");
    print("  Academic Year: ${classData.academicYear}");
    print("  Class Name: ${classData.className}");
    print("  Subjects: ${classData.subjects}");

    print("  Sections:");
    for (var section in classData.sections ?? []) {
      print("    Section Name: ${section.sectionName}");
      print("    Class Teacher ID: ${section.classTeacherId}");
      print("    Class Teacher Name: ${section.classTeacherName}");
      print("    Description: ${section.description}");
      print("    Start Date: ${section.startDate}");
      print("    End Date: ${section.endDate}");
      print("    Capacity: ${section.capacity}");
      print("    Room Number: ${section.roomNumber}");

      print("    Students:");
      for (var student in section.students ?? []) {
        print("      Student ID: ${student.id}");
        print("      Student Name: ${student.name}");
        print("      Student Roll: ${student.roll}");
      }

      print("    Routine:");
      if (section.routine != null) {
        print("      Routine ID: ${section.routine!.id}");
        print("      Daily Routines:");
        for (var dailyRoutine in section.routine!.dailyRoutines) {
          print("        Day: ${dailyRoutine.day}");
          print("        Events:");
          for (var event in dailyRoutine.events) {
            print("          Subject: ${event.subject}");
            print("          Event Type: ${event.eventType}");
            print(
                "          Start Time: ${event.startTime.format(Get.context!)}");
            print(
                "          End Time: ${event.endTime.format(Get.context!)}");
            print("          Teacher: ${event.teacher}");
            print("          Location: ${event.location}");
          }
        }
      } else {
        print("      No Routine Data");
      }
    }

    print("  Exam Syllabus:");
    for (var examSyllabus in classData.examSyllabus) {
      print("    Exam Name: ${examSyllabus.examName}");
      print("    Subjects:");
      for (var examSubject in examSyllabus.subjects) {
        print("      Subject Name: ${examSubject.subjectName}");
        print("      Exam Date: ${examSubject.examDate}");
        print("      Total Marks: ${examSubject.totalMarks}");
        print("      Exam Type: ${examSubject.examType}");
        print("      Topics:");
        for (var topic in examSubject.topics) {
          print("        Topic Name: ${topic.topicName}");
          print("        Topic Marks: ${topic.topicMarks}");
          print("        Difficulty Level: ${topic.difficultyLevel}");
          print("        Is Optional: ${topic.isOptional}");
          print("        Subtopics:");
          for (var subtopic in topic.subtopics) {
            print("          Subtopic Name: ${subtopic.subtopicName}");
          }
        }
      }
    }
    print("--------------------------------------------------");
  }

  // ---------------------------------------------------------------------------
  // Dummy Data Creation - KEEP for Testing Purposes
  // ---------------------------------------------------------------------------

  Future<void> addDummyClassesToFirestore() async {
    final firestore = FirebaseFirestore.instance;
    const schoolId = 'SCH00001'; // Replace with your school ID
    const academicYear = '2024-2025';

    // Define class names
    final classes = ['UKG', '1', '2', '3', '4'];

    // Define section names
    final sectionNames = ['A', 'B', 'C'];

    for (int i = 0; i < classes.length; i++) {
      final className = classes[i];

      // Create dummy sections
      List<SectionModel> sections = [];
      for (int j = 0; j < sectionNames.length; j++) {
        sections.add(SectionModel(
          sectionName: sectionNames[j],
          classTeacherId: 'teacher_${i + 1}_${j + 1}',
          classTeacherName: 'Teacher ${i + 1}-${j + 1}',
          description: 'Section ${sectionNames[j]} description',
          startDate:
          DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
          endDate:
          DateTime.now().add(const Duration(days: 365)).toIso8601String(),
          capacity: 30,
          roomNumber: 'Room ${i + 1}${j + 1}',
          students: [
            Student(
                id: 'student_1_${i + 1}${j + 1}',
                name: 'Student 1-${i + 1}-${j + 1}',
                roll: '10${i + 1}${j + 1}'),
            Student(
                id: 'student_2_${i + 1}${j + 1}',
                name: 'Student 2-${i + 1}-${j + 1}',
                roll: '11${i + 1}${j + 1}'),
          ],
          routine: WeeklyRoutine(id: 'routine_${i + 1}_${j + 1}', dailyRoutines: [
            DailyRoutine(day: 'Monday', events: [
              Event(
                  subject: 'Math',
                  eventType: 'Class',
                  startTime: const TimeOfDay(hour: 9, minute: 0),
                  endTime: const TimeOfDay(hour: 10, minute: 0)),
              Event(
                  subject: 'Break',
                  eventType: 'Break',
                  startTime: const TimeOfDay(hour: 10, minute: 0),
                  endTime: const TimeOfDay(hour: 10, minute: 30)),
              Event(
                  subject: 'Assembly',
                  eventType: 'Assembly',
                  startTime: const TimeOfDay(hour: 10, minute: 30),
                  endTime: const TimeOfDay(hour: 11, minute: 0)),
              Event(
                  subject: 'Departure',
                  eventType: 'Departure',
                  startTime: const TimeOfDay(hour: 11, minute: 0),
                  endTime: const TimeOfDay(hour: 11, minute: 30)),
            ]),
            DailyRoutine(day: 'Tuesday', events: [
              Event(
                  subject: 'English',
                  eventType: 'Class',
                  startTime: const TimeOfDay(hour: 9, minute: 0),
                  endTime: const TimeOfDay(hour: 10, minute: 0)),
              Event(
                  subject: 'History',
                  eventType: 'Break',
                  startTime: const TimeOfDay(hour: 10, minute: 0),
                  endTime: const TimeOfDay(hour: 11, minute: 0)),
            ]),
          ]),
        ));
      }

      // Create dummy exam syllabus
      List<ExamSyllabus> examSyllabusList = [];
      for (int k = 1; k <= 2; k++) {
        examSyllabusList.add(ExamSyllabus(
          examName: 'Exam $k for Class $className',
          subjects: [
            ExamSubject(
              subjectName: 'Math',
              topics: [
                Topic(
                  topicName: 'Algebra',
                  subtopics: [SubTopic(subtopicName: 'Linear Equations')],
                  topicMarks: 20,
                  difficultyLevel: 'Medium',
                  isOptional: false,
                ),
              ],
              examDate: DateTime.now().add(const Duration(days: 60)),
              totalMarks: 100,
              examType: 'Midterm',
            ),
            ExamSubject(
              subjectName: 'Science',
              topics: [
                Topic(
                  topicName: 'Physics',
                  subtopics: [SubTopic(subtopicName: 'Motion')],
                  topicMarks: 25,
                  difficultyLevel: 'Hard',
                  isOptional: true,
                ),
              ],
              examDate: DateTime.now().add(const Duration(days: 90)),
              totalMarks: 100,
              examType: 'Final',
            ),
          ],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ));
      }

      // Create the ClassModel
      final classModel = ClassModel(
        schoolId: schoolId,
        academicYear: academicYear,
        className: className,
        sections: sections,
        subjects: ['Math', 'Science', 'English', 'History'],
        examSyllabus: examSyllabusList,
      );

      // Add to Firestore
      try {
        await firestore.collection('classes').add(classModel.toMap());
        print('Added class: $className');
      } catch (e) {
        print('Error adding class $className: $e');
      }
    }

    print('Finished adding dummy classes.');
  }
}
