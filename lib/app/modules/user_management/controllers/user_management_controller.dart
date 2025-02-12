// user_management_controller.dart
import 'package:get/get.dart';

import 'package:cambridge_school/app/modules/user_management/models/user_model.dart';
import 'package:cambridge_school/app/modules/user_management/repositories/roster_repository.dart';
import 'package:cambridge_school/app/modules/user_management/repositories/user_repository.dart';

class UserManagementController extends GetxController {
  // Observables
  final RxInt selectedTabIndex = 0.obs;
  final RxString className = '1'.obs;
  final RxString sectionName = 'A'.obs;
  final RxString searchTerm = "".obs;
  final RxBool isLoading = false.obs;
  final RxBool isAscending = true.obs;

  // Lists of User Models
  final RxList<UserModel> studentList = <UserModel>[].obs;
  final RxList<UserModel> teacherList = <UserModel>[].obs;
  final RxList<UserModel> adminList = <UserModel>[].obs;
  final RxList<UserModel> staffList = <UserModel>[].obs;
  final RxList<UserModel> directorList = <UserModel>[].obs;
  final RxList<UserModel> driverList = <UserModel>[].obs;

  // Constants
  final String schoolId = 'SCH00001';

  // Repositories
  final UserRepository userRepository = UserRepository();
  final FirestoreRosterRepository rosterRepository =
      FirestoreRosterRepository();

  // Data Generators (Removed if not in use)
  //final DummyDataGenerator dummyDataGenerator = DummyDataGenerator();

  // Sorting Options (Move this to a Config file or Constants file)
  final Map<int, List<String>> availableSortingFields = {
    0: [
      'fullName',
      'email',
      'className',
      'sectionName',
      'rollNumber'
    ], // Students (Added rollNumber)
    1: ['fullName', 'email', 'subjectsTaught', 'experience'], // Teachers
    2: ['fullName', 'email', 'yearsInManagement'], // Directors
    3: ['fullName', 'email', 'permissions'], // Admins
    4: ['fullName', 'email', 'responsibilities'], // Staff
    5: ['fullName', 'email', 'licenseNumber', 'routesAssigned'], // Drivers
  };

  // Lifecycle Methods
  @override
  void onInit() {
    super.onInit();
    fetchStudents(); // Load default list on init
  }

  // API Data Fetching Methods
  Future<void> fetchStudents() => _fetchUsers(
      () => rosterRepository.getAllUsersInClassRoster(
          className.value, sectionName.value, schoolId),
      studentList,
      initialSortField: 'rollNumber'); // Sort by rollNumber initially
  Future<void> fetchTeachers() => _fetchUsers(
      () => rosterRepository.getAllUsersInUserRoster('teacher', schoolId),
      teacherList,
      initialSortField: 'fullName'); // Sort by fullName initially
  Future<void> fetchAdmins() => _fetchUsers(
      () => rosterRepository.getAllUsersInUserRoster('admin', schoolId),
      adminList,
      initialSortField: 'fullName'); // Sort by fullName initially
  Future<void> fetchStaff() => _fetchUsers(
      () => rosterRepository.getAllUsersInUserRoster('staff', schoolId),
      staffList,
      initialSortField: 'fullName'); // Sort by fullName initially
  Future<void> fetchDirectors() => _fetchUsers(
      () => rosterRepository.getAllUsersInUserRoster('director', schoolId),
      directorList,
      initialSortField: 'fullName'); // Sort by fullName initially
  Future<void> fetchDrivers() => _fetchUsers(
      () => rosterRepository.getAllUsersInUserRoster('driver', schoolId),
      driverList,
      initialSortField: 'fullName'); // Sort by fullName initially

  // Private Generic Fetching Function
  Future<void> _fetchUsers(Future<List<UserModel>> Function() fetchFunction,
      RxList<UserModel> targetList,
      {String? initialSortField}) async {
    try {
      isLoading.value = true;
      final users = await fetchFunction();
      targetList.value = users;

      if (initialSortField != null) {
        sortListByField(initialSortField); // Sort after data is loaded
      }
    } catch (e) {
      // Log the error (Ideally use a logging service)
      print("Error fetching users: $e");
      // Show an error message to the user (use Get.snackbar for example)
      Get.snackbar("Error",
          "Failed to load users. Please try again. Error: ${e.toString()}"); //Show actual error
    } finally {
      isLoading.value = false;
    }
  }

  // UI Logic Methods
  void changeTab(int index) {
    selectedTabIndex.value = index;
    switch (index) {
      case 0:
        fetchStudents();
        break;
      case 1:
        fetchTeachers();
        break;
      case 2:
        fetchDirectors();
        break;
      case 3:
        fetchAdmins();
        break;
      case 4:
        fetchStaff();
        break;
      case 5:
        fetchDrivers();
        break;
      default:
        // Consider logging or throwing an exception here for invalid index
        print("Invalid tab index: $index");
        break;
    }
  }

  void toggleSortingOrder() {
    isAscending.value = !isAscending.value;
  }

  // Sorting Logic Methods

  // --- Dynamic Sorting Function ---

  void sortListByField(String field) {
    RxList<UserModel> currentList;

    switch (selectedTabIndex.value) {
      case 0:
        currentList = studentList;
        break;
      case 1:
        currentList = teacherList;
        break;
      case 2:
        currentList = directorList;
        break;
      case 3:
        currentList = adminList;
        break;
      case 4:
        currentList = staffList;
        break;
      case 5:
        currentList = driverList;
        break;
      default:
        print('Invalid tab index');
        return;
    }

    // Validate that the field is a valid sorting field for the current tab
    if (!availableSortingFields[selectedTabIndex.value]!.contains(field)) {
      print('Invalid sorting field for this tab');
      return;
    }

    currentList.sort((a, b) {
      int comparisonResult = 0; // Initialize the comparison result

      // Use runtimeType to determine the type, because casting (UserModel) to a doesn't work.
      // The runtimeType is important to determine which type to call
      switch (field) {
        case 'fullName':
          comparisonResult =
              (a.fullName ?? '').compareTo(b.fullName ?? ''); //Null Safety
          break;
        case 'email':
          comparisonResult =
              (a.email ?? '').compareTo(b.email ?? ''); // Null Safety
          break;
        case 'className':
          if (a.studentDetails != null && b.studentDetails != null) {
            comparisonResult = (a.studentDetails?.className ?? '')
                .compareTo(b.studentDetails?.className ?? '');
          }
          break;
        case 'sectionName':
          if (a.studentDetails != null && b.studentDetails != null) {
            comparisonResult = (a.studentDetails?.section ?? '')
                .compareTo(b.studentDetails?.section ?? '');
          }
          break;
        case 'rollNumber':
          comparisonResult = _compareStudentsByRollNumber(a, b);
          break;

        case 'subjectsTaught':
          if (a.teacherDetails != null && b.teacherDetails != null) {
            // Assuming subjectsTaught is a List<String>
            final aSubjects = a.teacherDetails?.subjectsTaught ?? [];
            final bSubjects = b.teacherDetails?.subjectsTaught ?? [];
            comparisonResult =
                aSubjects.join(', ').compareTo(bSubjects.join(', '));
          }
          break;
        case 'experience':
          if (a.teacherDetails != null && b.teacherDetails != null) {
            comparisonResult = (a.teacherDetails?.experience ?? '')
                .compareTo(b.teacherDetails?.experience ?? '');
          }
          break;
        case 'yearsInManagement':
          if (a.directorDetails != null && b.directorDetails != null) {
            comparisonResult = (a.directorDetails?.yearsInManagement ?? 0)
                .compareTo(b.directorDetails?.yearsInManagement ?? 0);
          }
          break;
        case 'permissions':
          if (a.adminDetails != null && b.adminDetails != null) {
            // Assuming permissions is a List<String>
            final aPermissions = a.adminDetails?.permissions ?? [];
            final bPermissions = b.adminDetails?.permissions ?? [];
            comparisonResult =
                aPermissions.join(', ').compareTo(bPermissions.join(', '));
          }
          break;
        case 'responsibilities':
          if (a.maintenanceStaffDetails != null &&
              b.maintenanceStaffDetails != null) {
            // Assuming responsibilities is a List<String>
            final aResponsibilities =
                a.maintenanceStaffDetails?.responsibilities ?? [];
            final bResponsibilities =
                b.maintenanceStaffDetails?.responsibilities ?? [];
            comparisonResult = aResponsibilities
                .join(', ')
                .compareTo(bResponsibilities.join(', '));
          }
          break;

        case 'licenseNumber':
          if (a.driverDetails != null && b.driverDetails != null) {
            comparisonResult = (a.driverDetails?.licenseNumber ?? '')
                .compareTo(b.driverDetails?.licenseNumber ?? '');
          }
          break;
        case 'routesAssigned':
          if (a.driverDetails != null && b.driverDetails != null) {
            // Assuming routesAssigned is a List<String>
            final aRoutes = a.driverDetails?.routesAssigned ?? [];
            final bRoutes = b.driverDetails?.routesAssigned ?? [];
            comparisonResult = aRoutes.join(', ').compareTo(bRoutes.join(', '));
          }
          break;

        default:
          print('Invalid field: $field');
          return 0;
      }

      // Apply sorting order (ascending or descending)
      return isAscending.value
          ? comparisonResult
          : -comparisonResult; // Reverse for descending
    });

    currentList.refresh(); // Trigger UI update
  }

  // --- Roll Number Comparison Function ---
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
}
