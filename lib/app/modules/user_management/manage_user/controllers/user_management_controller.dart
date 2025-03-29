// user_management_controller.dart
import 'package:get/get.dart';

import '../../create_user/models/user_model.dart';
import 'package:cambridge_school/app/modules/user_management/manage_user/repositories/user_roster_repository.dart';
import 'package:cambridge_school/app/modules/user_management/manage_user/models/roster_model.dart';

class UserManagementController extends GetxController {
  // Observables
  final RxInt selectedTabIndex = 0.obs;
  final RxString className = 'Pre-Nursery'.obs;
  final RxString sectionName = 'A'.obs;
  final RxString searchTerm = "".obs;
  final RxBool isLoading = false.obs;
  final RxBool isAscending = true.obs;

  final Rx<UserRoster?> studentUserRoster = Rx<UserRoster?>(null);
  final Rx<UserRoster?> employeeUserRoster = Rx<UserRoster?>(null);

  UserRosterType rosterType = UserRosterType.studentRoster;

  RxString selectedSortBy = 'fullName'.obs;
  RxString selectedOrderBy = 'ascending'.obs;
  // Constants
  String schoolId = 'dummy_school_1';

  @override
  void onInit() {
    super.onInit();
    fetchStudentUserRoster();
    fetchEmployeeUserRoster();
  }

  // Repositories
  final UserRosterRepository userRosterRepository =
  UserRosterRepository(schoolId: 'dummy_school_1');

  Future<void> fetchStudentUserRoster() async {
    try {
      isLoading.value = true;
      studentUserRoster.value = await userRosterRepository.getClassRoster(
          className: className.value,
          sectionName: sectionName.value,
          schoolId: schoolId);
    } catch (e) {
      print('Error fetching student roster: $e');
      // Optionally show an error message to the user using Get.snackbar
      Get.snackbar(
        'Error',
        'Failed to fetch student roster. Please try again later.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchEmployeeUserRoster() async {
    try {
      isLoading.value = true;
      employeeUserRoster.value =
      await userRosterRepository.getEmployeeRoster(schoolId);
    } catch (e) {
      print('Error fetching employee roster: $e');
      // Optionally show an error message to the user using Get.snackbar
      Get.snackbar(
        'Error',
        'Failed to fetch employee roster. Please try again later.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

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
  };

  void toggleSortingOrder() {
    isAscending.value = !isAscending.value;
  }

  // --- Dynamic Sorting Function ---

  void sortListByField(String field) {
    List<UserModel>? currentList;

    switch (selectedTabIndex.value) {
      case 0:
        currentList = studentUserRoster.value?.userList;
        break;
      case 1:
        currentList = employeeUserRoster.value?.userList;
        break;

      default:
        print('Invalid tab index');
        return;
    }

    if (currentList == null) {
      print('User list is null for this tab');
      return;
    }

    // Validate that the field is a valid sorting field for the current tab
    if (!availableSortingFields[selectedTabIndex.value]!.contains(field)) {
      print('Invalid sorting field for this tab');
      return;
    }

    currentList.sort((a, b) {
      int comparisonResult = 0; // Initialize the comparison result

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
          comparisonResult = (a.studentDetails?.className ?? '')
              .compareTo(b.studentDetails?.className ?? '');

          break;
        case 'sectionName':
          comparisonResult = (a.studentDetails?.section ?? '')
              .compareTo(b.studentDetails?.section ?? '');

          break;
        case 'rollNumber':
          comparisonResult = _compareStudentsByRollNumber(a, b);
          break;

        case 'subjectsTaught':
          final aSubjects = a.teacherDetails?.subjectsTaught ?? [];
          final bSubjects = b.teacherDetails?.subjectsTaught ?? [];
          comparisonResult =
              aSubjects.join(', ').compareTo(bSubjects.join(', '));

          break;
        case 'experience':
          comparisonResult = (a.teacherDetails?.experience ?? '')
              .compareTo(b.teacherDetails?.experience ?? '');

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

    // Trigger UI update for the relevant roster
    if (selectedTabIndex.value == 0) {
      studentUserRoster.update((val) {}); // Trigger UI update for student roster
    } else if (selectedTabIndex.value == 1) {
      employeeUserRoster.update((val) {}); // Trigger UI update for employee roster
    }
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