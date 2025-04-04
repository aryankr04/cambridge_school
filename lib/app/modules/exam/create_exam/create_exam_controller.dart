//Exam Controller Class
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/constants/enums/class_name.dart';
import '../../../../core/widgets/snack_bar.dart';
import '../../class_management/class_model.dart';
import '../../class_management/class_repository.dart';
import '../../school_management/school_model.dart';
import '../../school_management/school_repository.dart';

class CreateExamController extends GetxController {
  // **************************************************************************
  // Repository Declarations
  // **************************************************************************
  final ClassRepository _classRepository =
      ClassRepository(schoolId: 'dummy_school_1');
  final SchoolRepository schoolRepository = SchoolRepository();

  // **************************************************************************
  // Observables - Manage the state of the UI
  // **************************************************************************
  final schoolId = 'dummy_school_1'.obs;
  final classModel = Rx<ClassModel?>(null);
  final isLoading = false.obs;

  final RxList<String> classNameOptions = RxList<String>();

  final RxString selectedClassName = RxString(ClassName.preNursery.label);

  @override
  void onInit() {
    super.onInit();
    fetchSchoolSectionsAndPrepareClassAndSectionOptions();
  }

  Future<void> fetchClassData() async {
    isLoading(true);

    if (schoolId.value.isEmpty || selectedClassName.value.isEmpty) {
      isLoading(true);
      return;
    }
    try {
      final fetchedClassModel =
          await _classRepository.getClassByClassName(selectedClassName.value);
      classModel.value = fetchedClassModel;


    } catch (e) {
      MySnackBar.showErrorSnackBar('Failed to fetch class data: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchSchoolSectionsAndPrepareClassAndSectionOptions() async {
    isLoading.value = true;
    try {
      classNameOptions.value  = await schoolRepository.getClassNames(schoolId.value);
      fetchClassData();
    } catch (error) {
      MySnackBar.showErrorSnackBar('Error fetching school sections: $error');
    } finally {
      isLoading.value = false;
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
      if (section.className == ClassName.fromString(className)) {
        sectionNames.add(section.sectionName);
      }
    }
    return sectionNames;
  }
}
