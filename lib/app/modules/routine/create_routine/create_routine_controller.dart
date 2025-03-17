import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../class_management/class_management_repositories.dart';
import '../../class_management/class_model.dart';
import '../../school_management/school_model.dart';
import '../routine_model.dart';

class CreateRoutineController extends GetxController {
  // Dependencies
  final ClassManagementRepository _classManagementRepository =
      ClassManagementRepository();

  // Observables - General
  final RxString schoolId = RxString('SCH00001');
  final RxString userRole = RxString('Teacher');
  final RxBool isLoadingClassData = RxBool(false);
  final RxBool isLoadingOptions = RxBool(false);

  // Observables - Selection State
  final RxString selectedClassName = RxString('');
  final RxString selectedSectionName = RxString('');
  final RxString selectedDay =
      RxString(DateFormat('EEEE').format(DateTime.now()));

  // Observables - Edit State
  final RxBool isEditMode = RxBool(false);
  final RxBool isUpdateMode = RxBool(false);
  final RxInt selectedEventIndex = RxInt(-1);

  // Observables - Data
  final Rx<ClassModel?> classModel = Rx<ClassModel?>(null);
  final RxList<Event> events = RxList<Event>([]);
  final RxList<SectionModel> sectionList = RxList<SectionModel>([]);
  final RxList<String>? sectionNameOptions = RxList<String>();
  final RxList<String>? classNameOptions = RxList<String>();
  final RxList<SectionData>? sectionsData = RxList<SectionData>();

  // Constants - Day Options
  static const List<String> dayOptions = [
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
    _initializeData();
    _setupReactions();
  }

  //----------------------------Private Method-----------------------------------
  void _initializeData() {
    fetchSchoolSectionsAndPrepareClassAndSectionOptions();
  }

  void _setupReactions() {
    ever(selectedDay, (_) => updateEventListForSelectedDay());
    ever(events, (_) => (isEditMode.value) ? isUpdateMode(true) : null);
  }

  //----------------------------------------------------------------------------
  // Data Fetching Methods
  //----------------------------------------------------------------------------

  /// Fetches class data based on school ID and class name and updates the UI.
  Future<void> fetchClassData() async {
    // isLoadingClassData(true);
    _resetEditStates();

    if (schoolId.value.isEmpty || selectedClassName.value.isEmpty) {
      print("School ID or Class Name is empty. Skipping fetch.");
      return;
    }
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
    }
    // isLoadingClassData(false);
  }

  /// Fetches school sections and prepares class and section options for dropdowns.
  Future<void> fetchSchoolSectionsAndPrepareClassAndSectionOptions() async {
    _resetEditStates();
    isLoadingClassData.value = true;
    isLoadingOptions.value = true;
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
      isLoadingClassData.value = false;
      isLoadingOptions.value = false;
    }
  }

  //----------------------------------------------------------------------------
  // UI Update Methods
  //----------------------------------------------------------------------------

  /// Updates the event list based on the selected day.
  void updateEventListForSelectedDay() {
    events.clear();
    final section = classModel.value?.sections?.firstWhereOrNull(
        (section) => section.sectionName == selectedSectionName.value);

    if (section != null && section.routine != null) {
      final dailyRoutine = section.routine!.dailyRoutines
          .firstWhereOrNull((routine) => routine.day == selectedDay.value);
      if (dailyRoutine != null) {
        List<Event> sortedEvents = List.from(dailyRoutine
            .events); // Create a copy to avoid modifying the original list.
        sortedEvents.sort((a, b) {
          // Compare TimeOfDay objects
          int hourComparison = a.startTime.hour.compareTo(b.startTime.hour);
          if (hourComparison != 0) {
            return hourComparison;
          }
          return a.startTime.minute.compareTo(b.startTime.minute);
        });
        events.addAll(sortedEvents);
      }
    }
  }

  /// Resets the edit mode and update mode states to false.
  void _resetEditStates() {
    isUpdateMode(false);
    isEditMode(false);
  }

  //----------------------------------------------------------------------------
  // CRUD Operations for Events
  //----------------------------------------------------------------------------

  /// Adds a new event to the daily routine and updates the event list.
  void addEvent(Event event) {
    _addEventToDailyRoutine(event);
    updateEventListForSelectedDay();
  }

  /// Updates an existing event in the daily routine and updates the event list.
  void updateEvent(Event updatedEvent, int index) {
    _updateEventInDailyRoutine(updatedEvent, index);
    updateEventListForSelectedDay();
  }

  /// Deletes an event from the daily routine and updates the event list.
  void deleteEvent(int index) {
    _deleteEventInDailyRoutine(index);
    updateEventListForSelectedDay();
  }

  //----------------------------------------------------------------------------
  // Helper Methods to Manage Events within the ClassModel
  //----------------------------------------------------------------------------

  /// Adds a new event to the daily routine.
  Future<void> _addEventToDailyRoutine(Event newEvent) async {
    if (!_validateClassModelAndSection()) return;

    try {
      isLoadingClassData.value = true;
      final sectionIndex = _getSectionIndex();
      if (sectionIndex == -1) return;

      WeeklyRoutine? weeklyRoutine = _getWeeklyRoutine(sectionIndex);
      weeklyRoutine ??= _createNewWeeklyRoutine();

      DailyRoutine? dailyRoutine = _getDailyRoutine(weeklyRoutine);
      dailyRoutine ??= _createNewDailyRoutine();

      dailyRoutine.events.add(newEvent);

      // await _updateClassModelInFirebase();
      Get.snackbar('Success', 'Event added successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add event: $e');
    } finally {
      isLoadingClassData.value = false;
    }
  }

  /// Updates an existing event in the daily routine.
  Future<void> _updateEventInDailyRoutine(
      Event updatedEvent, int eventIndex) async {
    if (!_validateClassModelAndSection()) return;

    try {
      isLoadingClassData.value = true;
      final sectionIndex = _getSectionIndex();
      if (sectionIndex == -1) return;

      WeeklyRoutine? weeklyRoutine = _getWeeklyRoutine(sectionIndex);
      if (weeklyRoutine == null) {
        Get.snackbar('Error', 'Routine does not exist in class model.');
        return;
      }

      DailyRoutine? dailyRoutine = _getDailyRoutine(weeklyRoutine);
      if (dailyRoutine == null) {
        Get.snackbar('Error', 'Daily routine does not exist in class model.');
        return;
      }

      if (!_isValidEventIndex(dailyRoutine, eventIndex)) return;

      dailyRoutine.events[eventIndex] = updatedEvent;

      //await _updateClassModelInFirebase();
      Get.snackbar('Success', 'Event updated successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update event: $e');
    } finally {
      isLoadingClassData.value = false;
    }
  }

  /// Deletes an event from the daily routine.
  Future<void> _deleteEventInDailyRoutine(int eventIndex) async {
    if (!_validateClassModelAndSection()) return;

    try {
      isLoadingClassData.value = true;
      final sectionIndex = _getSectionIndex();
      if (sectionIndex == -1) return;

      WeeklyRoutine? weeklyRoutine = _getWeeklyRoutine(sectionIndex);
      if (weeklyRoutine == null) {
        Get.snackbar('Error', 'Routine does not exist in class model.');
        return;
      }

      DailyRoutine? dailyRoutine = _getDailyRoutine(weeklyRoutine);
      if (dailyRoutine == null) {
        Get.snackbar('Error', 'Daily routine does not exist in class model.');
        return;
      }

      if (!_isValidEventIndex(dailyRoutine, eventIndex)) return;

      dailyRoutine.events.removeAt(eventIndex);
      // await _updateClassModelInFirebase();

      Get.snackbar('Success', 'Event deleted successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete event: $e');
    } finally {
      isLoadingClassData.value = false;
    }
  }

  //----------------------------------------------------------------------------
  // Validation and Index Retrieval Methods
  //----------------------------------------------------------------------------

  /// Validates that the class model and selected section are not empty.
  bool _validateClassModelAndSection() {
    if (classModel.value == null || selectedSectionName.isEmpty) {
      Get.snackbar('Error',
          'Class model or selected section is empty. Cannot update routine.');
      return false;
    }
    return true;
  }

  /// Retrieves the index of the selected section in the class model.
  int _getSectionIndex() {
    final sectionIndex = classModel.value!.sections?.indexWhere(
        (section) => section.sectionName == selectedSectionName.value);
    if (sectionIndex == null || sectionIndex == -1) {
      Get.snackbar('Error', 'Selected section not found in class model.');
      return -1;
    }
    return sectionIndex;
  }

  /// Validates that the event index is within the bounds of the daily routine's event list.
  bool _isValidEventIndex(DailyRoutine dailyRoutine, int eventIndex) {
    if (eventIndex < 0 || eventIndex >= dailyRoutine.events.length) {
      Get.snackbar('Error', 'Invalid event index.');
      return false;
    }
    return true;
  }

  //----------------------------------------------------------------------------
  // Object Creation Methods
  //----------------------------------------------------------------------------

  /// Retrieves the weekly routine for the given section index.
  WeeklyRoutine? _getWeeklyRoutine(int sectionIndex) {
    return classModel.value!.sections![sectionIndex].routine;
  }

  /// Retrieves the daily routine for the given weekly routine and selected day.
  DailyRoutine? _getDailyRoutine(WeeklyRoutine weeklyRoutine) {
    return weeklyRoutine.dailyRoutines
        .firstWhereOrNull((routine) => routine.day == selectedDay.value);
  }

  /// Creates a new weekly routine.
  WeeklyRoutine _createNewWeeklyRoutine() {
    return WeeklyRoutine(
      id: classModel.value!.id!,
      dailyRoutines: [],
    );
  }

  /// Creates a new daily routine.
  DailyRoutine _createNewDailyRoutine() {
    return DailyRoutine(day: selectedDay.value, events: []);
  }

  //----------------------------------------------------------------------------
  // Firebase Update Method
  //----------------------------------------------------------------------------

  /// Updates the class model in Firebase.
  Future<void> updateClassModelInFirebase() async {
    try {
      final classDoc = await FirebaseFirestore.instance
          .collection('classes')
          .where('schoolId', isEqualTo: classModel.value!.schoolId)
          .where('className', isEqualTo: classModel.value!.className)
          .limit(1)
          .get();

      if (classDoc.docs.isNotEmpty) {
        final docId = classDoc.docs.first.id;

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

  /// Updates the class model in Firebase.
  Future<void> updateClassModel() async {
    try {
      final classDoc = await FirebaseFirestore.instance
          .collection('classes')
          .where('schoolId', isEqualTo: classModel.value!.schoolId)
          .where('className', isEqualTo: classModel.value!.className)
          .limit(1)
          .get();

      if (classDoc.docs.isNotEmpty) {
        final docId = classDoc.docs.first.id;

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

  //----------------------------------------------------------------------------
  // Utility Functions
  //----------------------------------------------------------------------------

  /// Calculates the time interval between two TimeOfDay objects and returns a formatted string.
  String calculateTimeInterval(TimeOfDay startTime, TimeOfDay endTime) {
    int startMinutes = startTime.hour * 60 + startTime.minute;
    int endMinutes = endTime.hour * 60 + endTime.minute;

    if (endMinutes < startMinutes) {
      endMinutes += 24 * 60;
    }

    int totalMinutes = endMinutes - startMinutes;

    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;

    if (hours > 0) {
      return '$hours hr${hours > 1 ? 's' : ''} ${minutes > 0 ? '$minutes min' : ''}';
    } else {
      return '$minutes min';
    }
  }

  //----------------------------------------------------------------------------
  // Debugging Methods
  //----------------------------------------------------------------------------

  /// Prints the structure of the ClassModel to the console for debugging purposes.
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
            print("          End Time: ${event.endTime.format(Get.context!)}");
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
          print("        Subtopics:");
          for (var subtopic in topic.subtopics) {
            print("          Subtopic Name: ${subtopic}");
          }
        }
      }
    }
    print("--------------------------------------------------");
  }

  //----------------------------------------------------------------------------
  // Dummy Data Creation - KEEP for Testing Purposes
  //----------------------------------------------------------------------------

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
          startDate: DateTime.now()
              .subtract(const Duration(days: 30))
              .toIso8601String(),
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
          routine:
              WeeklyRoutine(id: 'routine_${i + 1}_${j + 1}', dailyRoutines: [
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
                  subtopics: [ 'Linear Equations'],
                  topicMarks: 20,
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
                  subtopics: [ 'Motion'],
                  topicMarks: 25,
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
