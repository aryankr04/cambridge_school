import 'package:cambridge_school/app/modules/class_management/class_model.dart';
import 'package:cambridge_school/app/modules/school_management/school_model.dart';
import 'package:cambridge_school/app/modules/user_management/manage_user/models/roster_model.dart';
import 'package:cambridge_school/core/utils/constants/enums/class_name.dart';
import 'package:cambridge_school/core/utils/constants/enums/schedule_event_type.dart';
import 'package:cambridge_school/core/utils/constants/lists.dart';
import 'package:cambridge_school/core/widgets/full_screen_loading_widget.dart';
import 'package:cambridge_school/core/widgets/snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nanoid/nanoid.dart';

import '../../../core/utils/constants/state_districts.dart';
import '../../../roles_manager.dart';
import '../attendance/mark_attendance/user_attendance_model.dart';
import '../routine/routine_model.dart';
import '../school_management/school_repository.dart';
import '../user_management/create_user/models/user_model.dart';
import '../user_management/manage_user/repositories/user_roster_repository.dart';
import 'class_repository.dart';

class ClassManagementController extends GetxController {
  // **************************************************************************
  // Repository Declarations
  // **************************************************************************
  final ClassRepository _classRepository =
      ClassRepository(schoolId: 'dummy_school_1');
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

  int stuId = 0;

  Future<void> fetchClass(String className) async {
    isLoadingClass.value = true;
    selectedClassName.value = className;
    try {
      classModels.value = await _classRepository.getClassByClassName(
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
      'Pre-Nursery',
      'Nursery',
      'LKG',
      'UKG',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10',
      '11',
      '12'
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
      final classId = nanoid(16);
      final classEnum = ClassNameExtension.fromString(className);

      final newClass = ClassModel(
        id: classId,
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
    final ClassRepository classRepository =
        ClassRepository(schoolId: schoolId.value);

    for (int i = 0; i < 4; i++) {
      final String classId = nanoid(16);
      List<String> subjects = List.generate(
        5,
        (i) => MyLists.subjectOptions[i % MyLists.subjectOptions.length],
      );
      final ClassModel classModel = ClassModel(
        id: classId,
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

  final faker = Faker();
  final UserRosterRepository userRosterRepository =
      UserRosterRepository(schoolId: 'dummy_school_1');

  Future<void> createAndUploadDummyClassRosters(
      {int numberOfRosters = 5}) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final List<ClassName> classNames = ClassName.values
        .where((className) => className != ClassName.other)
        .toList(); // Exclude 'other' class

    final WriteBatch batch = firestore.batch();

    for (int i = 0; i < numberOfRosters; i++) {
      final className =
          classNames[i % classNames.length]; // Cycle through class names
      for (int sectionIndex = 0; sectionIndex < 3; sectionIndex++) {
        // Create three sections per class
        final sectionName =
            String.fromCharCode('A'.codeUnitAt(0) + sectionIndex);
        final classRoster =
            _generateClassRoster(className.label, sectionName, schoolId.value);

        try {
          final classRosterDocRef =
              firestore.collection('user_rosters').doc(classRoster.id);
          batch.set(classRosterDocRef, classRoster.toMap());
          print(
              'Prepared Class Roster: ${classRoster.className} - Section ${classRoster.sectionName}');
        } catch (e) {
          print('Error preparing class roster: $e');
        }
      }
    }

    // Commit the batch write
    try {
      await batch.commit();
      print('Finished generating and uploading dummy class rosters.');
    } catch (e) {
      print('Error committing batch write: $e');
    }
  }

  UserRoster _generateClassRoster(
      String className, String sectionName, String schoolId) {
    final classId = nanoid(16);
    List<UserModel> students = List.generate(
        10, (index) => _generateStudent(className, sectionName, schoolId));

    // Sort students by roll number, handling both null and type safety
    students.sort((a, b) {
      int rollA =
          int.tryParse(a.studentDetails?.rollNumber?.toString() ?? '') ?? 0;
      int rollB =
          int.tryParse(b.studentDetails?.rollNumber?.toString() ?? '') ?? 0;
      return rollA.compareTo(rollB);
    });

    return UserRoster(
      rosterType: UserRosterType.studentRoster,
      id: classId,
      classId: classId,
      className: className,
      sectionName: sectionName,
      schoolId: schoolId,
      userList: students,
    );
  }

  UserModel _generateStudent(
      String className, String sectionName, String schoolId) {
    final firstName = faker.person.firstName();
    final lastName = faker.person.lastName();
    final rollNumber = faker.randomGenerator.integer(50, min: 1).toString();
    final admissionNo =
        faker.randomGenerator.integer(5000, min: 1000).toString();

    final height = faker.randomGenerator.decimal(scale: 50, min: 120) + 120;
    final genderOptions = ['Male', 'Female', 'Other'];
    final gender = faker.randomGenerator.element(genderOptions);

    final maritalStatusOptions = ['Single', 'Married', 'Divorced', 'Widowed'];
    final maritalStatus = faker.randomGenerator.element(maritalStatusOptions);

    final dob = faker.date
        .dateTimeBetween(DateTime(2005, 1, 1), DateTime(2010, 12, 31));
    stuId++;

    return UserModel(
      userId: 'STU${stuId.toString().padLeft(5, '0')}',
      username: faker.internet.userName(),
      fullName: '$firstName $lastName',
      email: faker.internet.email(),
      schoolId: schoolId,
      accountStatus: 'active',
      profileImageUrl: faker.image.image(),
      password: faker.internet.password(),
      points: faker.randomGenerator.integer(100),
      performanceRating: faker.randomGenerator.decimal(scale: 5),
      isActive: faker.randomGenerator.boolean(),
      dob: dob,
      gender: gender,
      religion: faker.randomGenerator.element(
          ['Christianity', 'Islam', 'Hinduism', 'Buddhism', 'Judaism']),
      category: faker.randomGenerator.element(['General', 'OBC', 'SC', 'ST']),
      nationality: faker.address.country(),
      maritalStatus: maritalStatus,
      phoneNo: faker.phoneNumber.us(), // Ensured valid phone number
      profileDescription: faker.lorem.sentence(),
      languagesSpoken: List.generate(
          faker.randomGenerator.integer(3) + 1, (_) => faker.lorem.word()),
      hobbies: List.generate(
          faker.randomGenerator.integer(3) + 1, (_) => faker.lorem.word()),
      height: height,
      weight: faker.randomGenerator.decimal(scale: 30, min: 40),
      bloodGroup: faker.randomGenerator
          .element(['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-']),
      isPhysicalDisability: faker.randomGenerator.boolean(),
      permanentAddress: HouseAddress(
        houseAddress: faker.address.streetAddress(),
        city: faker.address.city(),
        district: MyDistrictLists.biharDistricts.isNotEmpty
            ? MyDistrictLists.biharDistricts[faker.randomGenerator
                .integer(MyDistrictLists.biharDistricts.length)]
            : 'Unknown',
        state: faker.address.state(),
        pinCode: faker.address.zipCode(),
      ),
      currentAddress: HouseAddress(
        houseAddress: faker.address.streetAddress(),
        city: faker.address.city(),
        district: MyDistrictLists.biharDistricts.isNotEmpty
            ? MyDistrictLists.biharDistricts[faker.randomGenerator
                .integer(MyDistrictLists.biharDistricts.length)]
            : 'Unknown',
        state: faker.address.state(),
        pinCode: faker.address.zipCode(),
      ),
      modeOfTransport:
          faker.randomGenerator.element(['Bus', 'Car', 'Bike', 'Walk']),
      transportDetails: TransportDetails(
        routeNumber: faker.randomGenerator.integer(50).toString(),
        pickupPoint: faker.address.streetName(),
        dropOffPoint: faker.address.streetName(),
        vehicleNumber: faker.vehicle.vin(),
        fare: faker.randomGenerator.decimal(scale: 10),
      ),
      roles: [UserRole.student],
      studentDetails: StudentDetails(
        rollNumber: rollNumber,
        admissionNo: admissionNo,
        className: className,
        section: sectionName,
        admissionDate:
            faker.date.dateTimeBetween(DateTime(2022), DateTime(2023)),
        guardian: faker.person.name(),
      ),
      emergencyContact: EmergencyContact(
        fullName: faker.person.name(),
        relationship: faker.randomGenerator
            .element(['Father', 'Mother', 'Sibling', 'Friend']),
        phoneNumber: faker.phoneNumber.us(),
        emailAddress: faker.internet.email(),
      ),
      fatherDetails: GuardianDetails(
        fullName: faker.person.name(),
        relationshipToStudent: 'Father',
        occupation: faker.job.title(),
        phoneNumber: faker.phoneNumber.us(),
        emailAddress: faker.internet.email(),
      ),
      motherDetails: GuardianDetails(
        fullName: faker.person.name(),
        relationshipToStudent: 'Mother',
        occupation: faker.job.title(),
        phoneNumber: faker.phoneNumber.us(),
        emailAddress: faker.internet.email(),
      ),
      favorites: Favorite(
        dish: faker.food.dish(),
        subject: faker.lorem.word(),
        teacher: faker.person.name(),
        book: faker.lorem.word(),
      ),
      userAttendance: UserAttendance.empty(
        academicPeriodStart: DateTime.now(),
        numberOfDays: 365,
      ),
      createdAt: DateTime.now(),
      qualifications: [
        Qualification(
          degreeName: faker.lorem.word(),
          institutionName: faker.company.name(),
          passingYear: (DateTime.now().year - faker.randomGenerator.integer(5))
              .toString(),
          majorSubject: faker.lorem.word(),
          resultType: 'Percentage',
          result: faker.randomGenerator.decimal(scale: 100).toString(),
        ),
      ],
      joiningDate: DateTime.now(),
      permissions: [],
    );
  }
}
