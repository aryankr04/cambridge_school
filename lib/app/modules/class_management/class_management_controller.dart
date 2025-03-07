// Filename: management/admin/class_management/class_management_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/constants/lists.dart';
import '../../../core/utils/constants/sizes.dart';
import '../../../core/utils/constants/text_styles.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/dropdown_field.dart';
import '../../../core/widgets/text_field.dart';
import 'class_management_repositories.dart';
import 'class_model.dart';

class ClassManagementController extends GetxController {
  //----------------------------------------------------------------------------
  // Constants (Consider making these configurable or injected)
  static const String schoolId = 'SCH0000000001';

  //----------------------------------------------------------------------------
  // Observables (Reactive Variables)
  final RxString selectedClassName = RxString('');
  final RxBool isLoadingClassNames = RxBool(false);
  final RxBool isLoadingClassDetails =
  RxBool(false); // Loading Specific Class Doc.
  final RxList<String> availableClassNames = <String>[].obs;
  final Rx<SchoolClassModel?> selectedClass =
  Rx<SchoolClassModel?>(null); // Hold selected class details
  final Rxn<String> selectedClassValue = Rxn<String>();

  //----------------------------------------------------------------------------
  // Text Editing Controllers
  final TextEditingController classNameController = TextEditingController();
  final TextEditingController sectionNameController = TextEditingController();
  final TextEditingController teacherIdController = TextEditingController();
  final TextEditingController classTeacherNameController =
  TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController roomNumberController = TextEditingController();
  final TextEditingController academicYearController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController subjectNameController = TextEditingController();
  final TextEditingController subjectTeacherIdController =
  TextEditingController();

  //----------------------------------------------------------------------------
  // Repository
  final ClassManagementRepository _repository = ClassManagementRepository();

  //----------------------------------------------------------------------------
  // Lifecycle Methods
  @override
  void onInit() {
    super.onInit();
    loadClassNames();
  }

  @override
  void onClose() {
    classNameController.dispose();
    disposeSectionDialogControllers();
    disposeSubjectDialogControllers();
    // Dispose all Rx variables
    selectedClassName.close();
    isLoadingClassNames.close();
    isLoadingClassDetails.close();
    availableClassNames.close();
    selectedClass.close();
    selectedClassValue.close();
    super.onClose();
  }

  //----------------------------------------------------------------------------
  // Data Loading and Manipulation
  Future<void> loadClassNames() async {
    try {
      isLoadingClassNames.value = true;
      List<String> fetchedClassNames =
      await _repository.fetchClassNames(schoolId);
      availableClassNames.value = _reorderClassNames(fetchedClassNames);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch or reorder class names: $e');
    } finally {
      isLoadingClassNames.value = false;
    }
  }

  List<String> _reorderClassNames(List<String> fetchedClassNames) {
    List<String> reorderedList = [];
    Set<String> addedClassNames = <String>{};

    for (String className in MyLists.classOptions) {
      if (fetchedClassNames.contains(className)) {
        reorderedList.add(className);
        addedClassNames.add(className);
      }
    }

    for (String className in fetchedClassNames) {
      if (!addedClassNames.contains(className)) {
        reorderedList.add(className);
      }
    }
    return reorderedList;
  }

  //Optimized Add ClassName
  Future<void> addClassName() async {
    final String? className = selectedClassValue.value;
    if (className == null || className.isEmpty) {
      Get.snackbar('Warning', 'Class name cannot be empty');
      return;
    }

    if (availableClassNames.contains(className)) {
      Get.snackbar('Warning', 'Class name already exists.');
      return;
    }

    try {
      availableClassNames.add(className); //Optimistic Update
      await _repository.addClassName(schoolId, className);

      SchoolClassModel newClass = SchoolClassModel(
          schoolId: schoolId,
          className: className,
          sections: [],
          subjects: [],
          examSyllabus: []);

      await _repository.addOrUpdateClass(newClass);
      loadClassNames(); // UPDATED: Refresh class names
      loadClassDetails(className); //Optimized Load
      availableClassNames.value = _reorderClassNames(availableClassNames);
      Get.snackbar('Success', 'Class name added successfully');
    } catch (e) {
      availableClassNames.remove(className); //Rollback
      Get.snackbar('Error', 'Failed to add class name: $e');
    } finally {
      selectedClassValue.value = null;
    }
  }

  //----------------------------------------------------------------------------
  // Deletion of Class and ClassName
  Future<void> deleteClassesAndClassName(
      String schoolId, String className) async {
    Get.dialog(
      AlertDialog(
        title: const Text(
          "Confirm Delete",
          style: MyTextStyles.headlineSmall,
        ),
        content: Text("Are you sure you want to delete the class $className?"),
        actions: [
          TextButton(child: const Text("Cancel"), onPressed: () => Get.back()),
          TextButton(
            child: const Text("Delete"),
            onPressed: () async {
              Get.back();
              availableClassNames.remove(className); //Optimistic

              try {
                await _repository.deleteClassName(schoolId, className);
                await _repository.deleteClassesUnderClassName(
                    schoolId, className);

                selectedClassName.value = '';
                selectedClass.value = null; // Clear Selected Class
                loadClassNames();
                Get.snackbar('Success',
                    'Class "$className" and its classes deleted successfully.');
              } catch (e) {
                Get.snackbar('Error', 'Failed to delete class: $e');
              }
            },
          )
        ],
      ),
    );
  }

  //----------------------------------------------------------------------------
  // Load single class detail and store selected class
  Future<void> loadClassDetails(String className) async {
    try {
      isLoadingClassDetails.value = true;
      final List<SchoolClassModel> fetchedClasses =
      await _repository.fetchClasses(schoolId); // Fetch again

      selectedClass.value = fetchedClasses.firstWhereOrNull(
              (element) => element.className == className);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load class details: $e');
    } finally {
      isLoadingClassDetails.value = false;
    }
  }

  //----------------------------------------------------------------------------
  // Add Or Edit Class (Section)
  Future<void> addOrUpdateClass(SchoolClassModel schoolClass) async {
    if (selectedClassName.isEmpty) {
      Get.snackbar('Error', 'Please select a class name first.');
      return;
    }

    try {
      await _repository.addOrUpdateClass(schoolClass);
      selectedClass.value =
          schoolClass; // Optimistic Update the Selected class value.
      Get.snackbar('Success', 'Class updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add/update class: $e');
    } finally {
      disposeSectionDialogControllers();
      disposeSubjectDialogControllers();
    }
  }

  //----------------------------------------------------------------------------
  // Delete Section: Remove an existing section from a class
  Future<void> deleteSection(
      SchoolClassModel schoolClass, SchoolSectionModel sectionToDelete) async {
    if (selectedClassName.isEmpty) {
      Get.snackbar('Error', 'Please select a class name first.');
      return;
    }

    try {
      List<SchoolSectionModel> updatedSections = schoolClass.sections!
          .where((section) => section != sectionToDelete)
          .toList();
      SchoolClassModel updatedClass =
      schoolClass.copyWith(sections: updatedSections);

      await _repository.deleteSection(schoolClass.id!, updatedSections);
      selectedClass.value = updatedClass;
      Get.snackbar('Success', 'Section deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete section: $e');
    }
  }

  //----------------------------------------------------------------------------
  // Delete Subject: Remove an existing subject from a class
  Future<void> deleteSubject(String? subjectId) async {
    try {
      if (selectedClass.value == null)
        return; // Check selectedClass is not null

      final classModel = selectedClass.value!; // Get the class

      List<String> updatedSubjects = List.from(classModel.subjects ?? []);
      updatedSubjects.removeWhere((element) => element == subjectId);

      SchoolClassModel updatedClass =
      classModel.copyWith(subjects: updatedSubjects);
      await _repository.addOrUpdateClass(updatedClass);

      selectedClass.value = updatedClass; // Update Subject
      Get.snackbar('Success', 'Subject deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete Subject: $e');
    }
  }

  //----------------------------------------------------------------------------
  // Dialogs
  void showAddClassNameDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Add Class Name',
          style: MyTextStyles.headlineSmall,
        ),
        content: SizedBox(
          width: Get.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: MySizes.md,
                ),
                MyDropdownField(
                  options: MyLists.classOptions,
                  labelText: 'Class',
                  onSelected: (value) {
                    selectedClassValue.value = value;
                  },
                  selectedValue: selectedClassValue,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Get.back();
                selectedClassValue.value = null;
              }),
          TextButton(
              child: const Text("Save"),
              onPressed: () {
                addClassName();
                Get.back();
              }),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void showAddSubjectDialog(
      SchoolClassModel selectedClass, String? existingSubject) {
    if (existingSubject != null) {
      subjectNameController.text = existingSubject ?? '';
    } else {
      disposeSubjectDialogControllers();
    }

    Get.dialog(
      AlertDialog(
        title: Text(
          (existingSubject == null) ? 'Add Subject' : 'Edit Subject',
          style: MyTextStyles.headlineSmall,
        ),
        content: SizedBox(
          width: Get.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: MySizes.md,
                ),
                MyTextField(
                    controller: subjectNameController,
                    labelText: 'Subject Name'),
                const SizedBox(height: MySizes.md),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Get.back();
              disposeSubjectDialogControllers();
            },
          ),
          TextButton(
            child: const Text("Save"),
            onPressed: () async {
              if (subjectNameController.text.isEmpty) {
                Get.snackbar('Error', 'Subject name cannot be empty');
                return;
              }

              List<String> updatedSubjects =
              List.from(selectedClass.subjects ?? []);

              if (existingSubject == null) {
                updatedSubjects.add(subjectNameController.text);
              } else {
                int index = updatedSubjects.indexOf(existingSubject);
                if (index != -1) {
                  updatedSubjects[index] = subjectNameController.text;
                }
              }
              SchoolClassModel updatedClass =
              selectedClass.copyWith(subjects: updatedSubjects);

              addOrUpdateClass(updatedClass); // Update Class
              loadClassDetails(selectedClass.className!); // Refresh class details to update subjects
              Get.back();
            },
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void showAddSectionDialog(SchoolClassModel selectedClassModel) {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Add Section',
          style: MyTextStyles.headlineSmall,
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            width: Get.width,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(
                  height: MySizes.md,
                ),
                MyTextField(
                    controller: sectionNameController,
                    labelText: 'Section Name'),
                const SizedBox(
                  height: MySizes.md,
                ),
                MyTextField(
                    controller: teacherIdController, labelText: 'Teacher ID'),
                const SizedBox(
                  height: MySizes.md,
                ),
                MyTextField(
                    controller: classTeacherNameController,
                    labelText: 'Teacher Name'),
                const SizedBox(
                  height: MySizes.md,
                ),
                MyTextField(
                    controller: capacityController,
                    labelText: 'Capacity',
                    keyboardType: TextInputType.number),
                const SizedBox(
                  height: MySizes.md,
                ),
                MyTextField(
                    controller: roomNumberController, labelText: 'Room Number'),
                const SizedBox(
                  height: MySizes.md,
                ),
                MyTextField(
                    controller: descriptionController,
                    labelText: 'Description',
                    maxLines: 3),
              ],
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: MyButton(
                  text: 'Cancel',
                  onPressed: () {
                    Get.back();
                    disposeSectionDialogControllers();
                  },
                  isOutlined: true,
                  borderRadius: MySizes.borderRadiusMd,
                  hasShadow: false,
                ),
              ),
              const SizedBox(
                width: MySizes.lg,
              ),
              Expanded(
                child: MyButton(
                  text: 'Save',
                  onPressed: () async {
                    if (sectionNameController.text.isEmpty) {
                      Get.snackbar('Error', 'Section name cannot be empty');
                      return;
                    }

                    SchoolSectionModel newSection = SchoolSectionModel(
                      sectionName: sectionNameController.text,
                      classTeacherId: teacherIdController.text,
                      classTeacherName: classTeacherNameController.text,
                      capacity: int.tryParse(capacityController.text) ?? 0,
                      roomNumber: roomNumberController.text,
                      description: descriptionController.text,
                    );

                    List<SchoolSectionModel> updatedSections =
                    List.from(selectedClassModel.sections ?? []);

                    updatedSections.add(newSection);

                    SchoolClassModel updatedClass =
                    selectedClassModel.copyWith(sections: updatedSections);

                    await _repository.addOrUpdateClass(updatedClass);

                    Get.back();
                    loadClassDetails(selectedClassModel.className!); // Refresh class details to update sections
                  },
                  backgroundColor: Colors.green,
                  borderRadius: MySizes.borderRadiusMd,
                ),
              ),
            ],
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void showAddSectionDialogForEdit(
      SchoolClassModel selectedClass, SchoolSectionModel existingSection) {
    sectionNameController.text = existingSection.sectionName ?? '';
    teacherIdController.text = existingSection.classTeacherId ?? '';
    classTeacherNameController.text = existingSection.classTeacherName ?? '';
    capacityController.text = existingSection.capacity?.toString() ?? '';
    roomNumberController.text = existingSection.roomNumber ?? '';
    descriptionController.text = existingSection.description ?? '';

    Get.dialog(
      AlertDialog(
        title: Text(
          'Edit Section',
          style: MyTextStyles.headlineSmall,
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            width: Get.width,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                MyTextField(
                    controller: sectionNameController,
                    labelText: 'Section Name'),
                const SizedBox(
                  height: MySizes.md,
                ),
                MyTextField(
                    controller: teacherIdController, labelText: 'Teacher ID'),
                const SizedBox(
                  height: MySizes.md,
                ),
                MyTextField(
                    controller: classTeacherNameController,
                    labelText: 'Teacher Name'),
                const SizedBox(
                  height: MySizes.md,
                ),
                MyTextField(
                    controller: capacityController,
                    labelText: 'Capacity',
                    keyboardType: TextInputType.number),
                const SizedBox(
                  height: MySizes.md,
                ),
                MyTextField(
                    controller: roomNumberController, labelText: 'Room Number'),
                const SizedBox(
                  height: MySizes.md,
                ),
                MyTextField(
                    controller: descriptionController,
                    labelText: 'Description',
                    maxLines: 3),
              ],
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: MyButton(
                  text: 'Cancel',
                  onPressed: () {
                    Get.back();
                    disposeSectionDialogControllers();
                  },
                  isOutlined: true,
                  borderRadius: MySizes.borderRadiusMd,
                  hasShadow: false,
                ),
              ),
              const SizedBox(
                width: MySizes.lg,
              ),
              Expanded(
                child: MyButton(
                  text: 'Save',
                  onPressed: () async {
                    if (sectionNameController.text.isEmpty) {
                      Get.snackbar('Error', 'Section name cannot be empty');
                      return;
                    }

                    SchoolSectionModel updatedSection = SchoolSectionModel(
                      sectionName: sectionNameController.text,
                      classTeacherId: teacherIdController.text,
                      classTeacherName: classTeacherNameController.text,
                      capacity: int.tryParse(capacityController.text) ?? 0,
                      roomNumber: roomNumberController.text,
                      description: descriptionController.text,
                    );

                    List<SchoolSectionModel> updatedSections =
                    List.from(selectedClass.sections ?? []);
                    int index = updatedSections
                        .indexWhere((element) => element == existingSection);
                    if (index != -1) {
                      updatedSections[index] = updatedSection;
                    }
                    SchoolClassModel updatedClass =
                    selectedClass.copyWith(sections: updatedSections);

                    await _repository.addOrUpdateClass(updatedClass);

                    Get.back();
                    loadClassDetails(selectedClass.className!); // Refresh class details to update sections
                  },
                  backgroundColor: Colors.green,
                  borderRadius: MySizes.borderRadiusMd,
                ),
              ),
            ],
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  //----------------------------------------------------------------------------
  // Helper Methods (Dialog Controller Management)
  // Helper method to dispose Section Dialog's controller to avoid overlapping
  void disposeSectionDialogControllers() {
    sectionNameController.clear();
    teacherIdController.clear();
    classTeacherNameController.clear();
    capacityController.clear();
    roomNumberController.clear();
    descriptionController.clear();
  }

  // Helper method to dispose Subject Dialog's controller to avoid overlapping
  void disposeSubjectDialogControllers() {
    subjectNameController.clear();
    subjectTeacherIdController.clear();
  }
}