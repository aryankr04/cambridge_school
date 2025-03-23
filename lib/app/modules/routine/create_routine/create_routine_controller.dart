import 'package:cambridge_school/app/modules/class_management/class_management_controller.dart';
import 'package:cambridge_school/app/modules/school_management/school_repository.dart';
import 'package:cambridge_school/core/utils/constants/enums/class_name.dart';
import 'package:cambridge_school/core/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../class_management/class_repository.dart';
import '../../class_management/class_model.dart';
import '../../school_management/school_model.dart';

class CreateRoutineController extends GetxController {
  // Dependencies
  final ClassRepository _classManagementRepository = ClassRepository();

  final SchoolRepository schoolRepository = SchoolRepository();

  // Observables - General
  final RxString schoolId = RxString('dummy_school_1');
  final RxString userRole = RxString('Teacher');
  final RxBool isLoadingClassData = RxBool(false);
  final RxBool isLoadingOptions = RxBool(false);

  // Observables - Selection State
  final RxString selectedClassName = RxString(ClassName.preNursery.label);
  final RxString selectedSectionName = RxString('');
  final RxString selectedDay =
      RxString(DateFormat('EEEE').format(DateTime.now()));

  // Observables - Edit State
  final RxBool isEditMode = RxBool(false);
  final RxBool isUpdateMode = RxBool(false);
  final RxInt selectedEventIndex = RxInt(-1);

  // Observables - Data
  final Rx<ClassModel?> classModel = Rx<ClassModel?>(null);
  final RxList<String> sectionNameOptions = RxList<String>();
  final RxList<String> classNameOptions = RxList<String>();
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
  }

  // --- Private Methods ---
  void _initializeData() {
    fetchSchoolSectionsAndPrepareClassAndSectionOptions();
  }

  void _resetEditStates() {
    isUpdateMode(false);
    isEditMode(false);
  }

  // --- Public Methods - Data Fetching ---
  Future<void> fetchClassData() async {
    isLoadingClassData(true);
    _resetEditStates();

    if (schoolId.value.isEmpty || selectedClassName.value.isEmpty) {
      isLoadingClassData(false);
      return;
    }
    try {
      final fetchedClassModel = await _classManagementRepository
          .getClassByClassName(schoolId.value, selectedClassName.value);
      classModel.value = fetchedClassModel;
    } catch (e) {
      MySnackBar.showErrorSnackBar('Failed to fetch class data: $e');
    } finally {
      isLoadingClassData(false);
    }
  }

  Future<void> fetchSchoolSectionsAndPrepareClassAndSectionOptions() async {
    _resetEditStates();
    isLoadingClassData.value = true;
    isLoadingOptions.value = true;
    try {
      sectionsData?.value = await schoolRepository.getSections(schoolId.value);

      classNameOptions.value = await extractClassNames(sectionsData);
      if(!classNameOptions.contains(selectedClassName.value)){
        selectedClassName.value = classNameOptions.first;
      }
      sectionNameOptions.value =
          await extractSectionNames(sectionsData, selectedClassName.value);
      fetchClassData();
    } catch (error) {
      MySnackBar.showErrorSnackBar('Error fetching school sections: $error');
    } finally {
      isLoadingClassData.value = false;
      isLoadingOptions.value = false;
    }
  }

  Future<List<String>> extractClassNames(
      List<SectionData>? sectionsData) async {
    if (sectionsData == null) return [];
    Set<String> uniqueClassNames = {};
    for (var section in sectionsData) {
      uniqueClassNames.add(section.className.label);
    }
    return uniqueClassNames.toList();
  }

  Future<List<String>> extractSectionNames(
      List<SectionData>? sectionsData, String className) async {
    if (sectionsData == null) return [];
    List<String> sectionNames = [];
    for (var section in sectionsData) {
      if (section.className == ClassNameExtension.fromString(className)) {
        sectionNames.add(section.sectionName);
      }
    }
    return sectionNames;
  }

  // --- Public Methods - Data Processing ---

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

  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dateTime = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    return DateFormat('h:mm a').format(dateTime);
  }

  // --- Public Methods - Firebase Updates ---
  Future<void> updateClassModelInFirebase() async {
    try {
      if (classModel.value != null) {
        await _classManagementRepository.updateClass(classModel.value!);
        MySnackBar.showSuccessSnackBar('Class model updated in Firebase!');
      } else {
        MySnackBar.showErrorSnackBar('Class document not found in Firebase.');
      }
    } catch (e) {
      MySnackBar.showErrorSnackBar(
          'Failed to update class model in Firebase: $e');
    }
  }
}
