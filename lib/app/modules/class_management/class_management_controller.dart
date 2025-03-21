import 'package:cambridge_school/app/modules/school_management/school_model.dart';
import 'package:cambridge_school/core/utils/constants/enums/class_name.dart';
import 'package:get/get.dart';
import 'package:nanoid/nanoid.dart'; // Import corrected for sync usage

import '../class_management/class_model.dart';
import '../school_management/school_repository.dart';
import 'class_management_repositories.dart';

class ClassManagementController extends GetxController {
  final ClassManagementRepository classManagementRepository =
  ClassManagementRepository();
  final FirestoreSchoolRepository schoolRepository =
  FirestoreSchoolRepository();

  RxString schoolId = 'dummy_school_1'.obs;
  RxList<String> classNames = <String>[].obs;
  Rx<ClassModel?> selectedClass = Rx<ClassModel?>(null);
  RxBool isLoading = false.obs;

  // Selected Class Name
  RxString selectedClassName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchClassOptions();
  }

  Future<void> fetchClassOptions() async {
    isLoading.value = true;
    try {
      final fetchedClasses = await schoolRepository.fetchClassNames(schoolId.value);
      classNames.value = fetchedClasses;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch class options: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch class details
  Future<void> fetchClassDetails(String className) async {
    isLoading.value = true;
    selectedClassName.value = className;
    try {
      final fetchedClass = await classManagementRepository.getClassByClassName(
          schoolId.value, className);
      selectedClass.value = fetchedClass;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch class details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Class Management
  Future<void> addClass(String className) async {
    if (!classNames.contains(className)) {
      classNames.add(className);
    }
    update();
  }

  void deleteClass(String className) {
    classNames.remove(className);
    if (selectedClass.value?.className == className) {
      selectedClass.value = null; // Clear selected class if deleted
    }
    update();
  }

  // Section Management
  void addSection(SectionModel section) {
    selectedClass.value?.sections;
    selectedClass.value!.sections.add(section);
    selectedClass.refresh();
  }

  void updateSection(SectionModel updatedSection) {
    if (selectedClass.value != null) {
      final index = selectedClass.value!.sections.indexWhere(
              (section) => section.sectionName == updatedSection.sectionName);
      if (index != -1) {
        selectedClass.value!.sections[index] = updatedSection;
        selectedClass.refresh();
      }
    }
  }

  void deleteSection(String sectionName) {
    selectedClass.value?.sections.removeWhere(
            (section) => section.sectionName == sectionName);
    selectedClass.refresh();
  }

  // Subject Management
  void addSubject(String subject) {
    selectedClass.value?.subjects;
    selectedClass.value!.subjects.add(subject);
    selectedClass.refresh();
  }

  void deleteSubject(String subject) {
    selectedClass.value?.subjects.remove(subject);
    selectedClass.refresh();
  }

  // Update to Firebase
  Future<void> updateClassToFirebase() async {
    if (selectedClass.value != null) {
      try {
        await classManagementRepository.updateClass(selectedClass.value!);
        Get.snackbar('Success', 'Class updated successfully!');
      } catch (e) {
        Get.snackbar('Error', 'Failed to update class: $e');
      }
    } else {
      Get.snackbar('Warning', 'No class selected to update.');
    }
  }

  // Add ClassModel to Firebase
  Future<void> addClassToFirebase(ClassModel classModel) async {
    try {
      final newClassId = await classManagementRepository.createClass(classModel);
      if (newClassId != null) {
        classNames.add(classModel.className.label); // Add class name to local list
        update();
        Get.snackbar('Success', 'Class added successfully!');
      } else {
        Get.snackbar('Error', 'Failed to add class.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to add class: $e');
    }
  }

  Future<void> onAddClassButtonPressed(String className) async {
    final classId = nanoid(12); // Generate unique class ID

    final classEnum = ClassNameExtension.fromValue(className);


    final newClass = ClassModel(
      id: classId,
      schoolId: schoolId.value,
      className: classEnum,
      academicYear: '2024-2025',
      sections: [],
      subjects: [],
      examSyllabus: [],
    );

    await addClassToFirebase(newClass);

    // Add class reference in school repository
    await schoolRepository.addClassData(
      schoolId.value,
      ClassData(classId: classId, className: className, sectionName: []),
    );

    fetchClassOptions();
  }
}
