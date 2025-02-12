import 'dart:ui';
import 'dart:ui';
import 'dart:ui';

import 'package:cambridge_school/app/modules/user_management/models/user_model.dart';
import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/widgets/dialog_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:uuid/uuid.dart';

import '../models/roster_model.dart';
import '../repositories/roster_repository.dart';
import '../widgets/user_card_widget.dart';

class StudentListScreen extends StatelessWidget {
  StudentListScreen({super.key});

  final userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildSearchSection(),
          ),
          Obx(_buildStudentListSection),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.all(MySizes.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: _buildClassDropdown()),
          const SizedBox(width: MySizes.md),
          Expanded(child: _buildSectionDropdown()),
          const SizedBox(width: MySizes.md),
          FilledButton(
            onPressed: () => userController.fetchStudentData(),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  Widget _buildClassDropdown() {
    return MyDialogDropdown(
      isMultipleSelection: true,
      labelText: 'Class',
      options: ['All', ...userController.classList],
      initialSelectedValues: userController.selectedClasses.isNotEmpty
          ? userController.selectedClasses
          : null,
      onMultipleChanged: (value) {
        if (value != null) {
          userController.selectedClasses.clear();
          userController.selectedClasses.addAll(value);
        }
      },
    );
  }

  Widget _buildSectionDropdown() {
    return MyDialogDropdown(
      isMultipleSelection: true,
      labelText: 'Sec',
      options: ['All', ...userController.sectionList],
      initialSelectedValues: userController.selectedSections.isNotEmpty
          ? userController.selectedSections
          : null,
      onMultipleChanged: (value) {
        if (value != null) {
          userController.selectedSections.clear();
          userController.selectedSections.addAll(value);
        }
      },
    );
  }

  Widget _buildStudentListSection() {
    if (userController.isLoading.value) {
      return SliverFillRemaining(
        child: _buildShimmerLoading(),
      );
    }

    final studentList = userController.studentList;

    studentList.sort(_compareStudentsByRollNumber);

    final groupedStudents = _groupStudentsByClassAndSection(studentList);
    final sortedKeys = groupedStudents.keys.toList()..sort();

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final key = sortedKeys[index];
          final studentsInGroup = groupedStudents[key]!;

          return StickyHeader(
            header: _buildHeader(key),
            content: Column(
              children: studentsInGroup
                  .map((userProfile) => UserCardWidget(
                        userProfile: userProfile,
                        onView: () {
                          print('View ${userProfile.fullName}');
                        },
                        onEdit: () {
                          print('Edit ${userProfile.fullName}');
                        },
                        onDelete: () {
                          print('Delete ${userProfile.fullName}');
                        },
                      ))
                  .toList(),
            ),
          );
        },
        childCount: sortedKeys.length,
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 8,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(MySizes.md),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey[300]!,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: double.infinity,
                        color: Colors.grey[300]!,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                      ),
                      Container(
                        height: 12,
                        width: Get.width * 0.4,
                        color: Colors.grey[300]!,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(String key) {
    return Container(
      color: Colors.blueGrey[700],
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      alignment: Alignment.centerLeft,
      child: Text(
        key,
        style: const TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  int _compareStudentsByRollNumber(UserModel a, UserModel b) {
    final rollNumberA = a.studentDetails?.rollNumber ?? '0';
    final rollNumberB = b.studentDetails?.rollNumber ?? '0';

    try {
      int rollA = int.parse(rollNumberA);
      int rollB = int.parse(rollNumberB);
      return rollA.compareTo(rollB);
    } catch (e) {
      print(
          'Invalid roll number format, sorting as string: $rollNumberA, $rollNumberB. Error: $e');
      return rollNumberA.compareTo(rollNumberB);
    }
  }

  Map<String, List<UserModel>> _groupStudentsByClassAndSection(
      List<UserModel> studentList) {
    final groupedStudents = <String, List<UserModel>>{};
    for (var student in studentList) {
      final className = student.studentDetails?.className ?? 'Unknown Class';
      final sectionName = student.studentDetails?.section ?? 'Unknown Section';
      final key = 'Class: $className - $sectionName';

      groupedStudents.putIfAbsent(key, () => []).add(student);
    }
    return groupedStudents;
  }
}

class UserController extends GetxController {
  final studentList = <UserModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final List<String> classList = [
    'Pre-School',
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
    '9 ',
    '10',
    '11 (Science)',
    '11 (Commerce)',
    '11 (Arts)',
    '12 (Science)',
    '12 (Commerce)',
    '12 (Arts)',
  ];
  final sectionList = <String>['A', 'B', 'C'];
  final String schoolId = 'SCH0000000001';

  final RxList<String> selectedClasses = <String>[].obs;
  final RxList<String> selectedSections = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchStudentData() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      List<UserModel> students = await _fetchStudentsByClassesAndSections(
          selectedClasses.contains('All') ? classList : selectedClasses,
          selectedSections.contains('All') ? sectionList : selectedSections);
      studentList.assignAll(students);
    } catch (e) {
      errorMessage.value = "Error fetching students: $e";
      print(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<UserModel>> _fetchStudentsByClassesAndSections(
      List<String> selectedClasses, List<String> selectedSections) async {
    final collection = FirebaseFirestore.instance.collection('class_rosters');
    List<UserModel> allStudents = [];

    try {
      for (var className in selectedClasses) {
        for (var sectionName in selectedSections) {
          QuerySnapshot<Map<String, dynamic>> querySnapshot = await collection
              .where('className', isEqualTo: className.trim())
              .where('sectionName', isEqualTo: sectionName.trim())
              .get();

          if (querySnapshot.docs.isNotEmpty) {
            for (QueryDocumentSnapshot<Map<String, dynamic>> docSnapshot
                in querySnapshot.docs) {
              ClassRoster classRoster =
                  ClassRoster.fromMap(docSnapshot.data())!;
              allStudents.addAll(classRoster.studentList);
            }
          }
        }
      }
    } catch (e) {
      print('Error fetching students: $e');
      errorMessage.value = "Error fetching students: $e";
    }

    return allStudents;
  }
}

class DummyDataGenerator {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirestoreRosterRepository rosterRepository = FirestoreRosterRepository();

  static const String collectionName = 'rosters';
  final List<String> classNames = [
    'Pre-School',
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
    '9 ',
    '10',
    '11 (Science)',
    '11 (Commerce)',
    '11 (Arts)',
    '12 (Science)',
    '12 (Commerce)',
    '12 (Arts)',
  ];
  Future<void> generateAndAddDummyData() async {
    try {
      for (int i = 0; i < 5; i++) {
        // Generate 10 class rosters
        final classRoster = _createDummyClassRoster(i);
        await rosterRepository.addUserRoster(classRoster);

        print('Added dummy class roster ${i + 1}');
      }
      print('Successfully added 10 dummy class rosters.');
    } catch (e) {
      print('Error adding dummy data: $e');
      rethrow;
    }
  }

  UserRoster _createDummyClassRoster(int index) {
    final faker = Faker();
    const uuid = Uuid();

    String className = classNames[index];
    String sectionName =
        ['A', 'B', 'C'][index % 3]; // Cycle through A, B, C sections
    String academicYear = '2023-2024';
    String schoolId = 'SCH00001'; // Replace with a valid school ID

    final studentList = List.generate(
        20, (j) => _createDummyUser(faker, uuid, className, sectionName));

    return UserRoster(
      schoolId: schoolId,
      userList: studentList,
      id: uuid.v4(),
      rosterType: 'teacher',
    );
  }

  UserModel _createDummyUser(
      Faker faker, Uuid uuid, String className, String sectionName) {
    return UserModel(
      schoolId: 'SCH00001',

      userId: uuid.v4(),
      username: faker.internet.userName(),
      email: faker.internet.email(),
      accountStatus: [
        'active',
        'inactive',
        'pending',
        'suspended'
      ][faker.randomGenerator.integer(4)],
      fullName: faker.person.name(),
      profileImageUrl: faker.image.image(),
      dob: faker.date
          .dateTimeBetween(DateTime(2000, 1, 1), DateTime(2010, 12, 31)),
      gender: ['male', 'female', 'other'][faker.randomGenerator.integer(2)],
      religion: faker.lorem.word(),
      category: faker.lorem.word(),
      phoneNo: faker.phoneNumber.toString(),
      profileDescription: faker.lorem.sentence(),
      languagesSpoken: [faker.lorem.word(), faker.lorem.word()],
      hobbies: [faker.lorem.word(), faker.lorem.word()],
      nationality: faker.address.country(),
      height: faker.randomGenerator.decimal(scale: 180, min: 150),
      weight: faker.randomGenerator.decimal(scale: 80, min: 50),
      bloodGroup: ['A+', 'B-', 'O+'][faker.randomGenerator.integer(3)],
      isPhysicalDisability: faker.randomGenerator.boolean(),
      maritalStatus: ['single', 'married'][faker.randomGenerator.integer(2)],
      permanentAddress:
          null, // You can create dummy addresses as well if needed
      currentAddress: null,
      modeOfTransport: faker.lorem.word(),
      transportDetails: null,
      createdAt: DateTime.now(),
      roles: [UserRole.student], // Assign role
      studentDetails: StudentDetails(
        studentId: uuid.v4(),
        rollNumber: faker.randomGenerator.integer(100).toString(),
        className: className,
        section: sectionName,
      ),
      teacherDetails: null,
      directorDetails: null,
      adminDetails: null,
      securityGuardDetails: null,
      maintenanceStaffDetails: null,
      driverDetails: null,
      schoolAdminDetails: null,
      departmentHeadDetails: null,
      emergencyContact: null,
      fatherDetails: null,
      motherDetails: null,
      favorites: null,
      userAttendance: null,
      points: faker.randomGenerator.integer(100),
      performanceRating: faker.randomGenerator.decimal(scale: 5),
    );
  }
}
