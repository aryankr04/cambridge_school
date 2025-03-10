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
  final Rx<ClassModel?> selectedClass =
  Rx<ClassModel?>(null); // Hold selected class details
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

  /// Loads the available class names from the repository.
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

  /// Reorders the class names based on a predefined list.
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

  /// Adds a new class name to the available list.
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

      ClassModel newClass = ClassModel(
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
  // Data Deletion

  /// Deletes a class and its associated data.
  Future<void> deleteClassesAndClassName(
      String schoolId, String className) async {
    Get.dialog(
      AlertDialog(
        title: const Text(
          "Confirm Delete",
          style: MyTextStyle.headlineSmall,
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
  // Class Detail Loading

  /// Loads details for a specific class.
  Future<void> loadClassDetails(String className) async {
    try {
      isLoadingClassDetails.value = true;
      final List<ClassModel> fetchedClasses =
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
  // Class Section Management

  /// Adds or updates a class (section).
  Future<void> addOrUpdateClass(ClassModel schoolClass) async {
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

  /// Deletes a section from a class.
  Future<void> deleteSection(
      ClassModel schoolClass, SectionModel sectionToDelete) async {
    if (selectedClassName.isEmpty) {
      Get.snackbar('Error', 'Please select a class name first.');
      return;
    }

    try {
      List<SectionModel> updatedSections = schoolClass.sections!
          .where((section) => section != sectionToDelete)
          .toList();
      ClassModel updatedClass =
      schoolClass.copyWith(sections: updatedSections);

      await _repository.deleteSection(schoolClass.id!, updatedSections);
      selectedClass.value = updatedClass;
      Get.snackbar('Success', 'Section deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete section: $e');
    }
  }

  //----------------------------------------------------------------------------
  // Class Subject Management

  /// Deletes a subject from a class.
  Future<void> deleteSubject(String? subjectId) async {
    try {
      if (selectedClass.value == null)
        return; // Check selectedClass is not null

      final classModel = selectedClass.value!; // Get the class

      List<String> updatedSubjects = List.from(classModel.subjects ?? []);
      updatedSubjects.removeWhere((element) => element == subjectId);

      ClassModel updatedClass =
      classModel.copyWith(subjects: updatedSubjects);
      await _repository.addOrUpdateClass(updatedClass);

      selectedClass.value = updatedClass; // Update Subject
      Get.snackbar('Success', 'Subject deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete Subject: $e');
    }
  }

  //----------------------------------------------------------------------------
  // Dialog Management

  /// Shows the Add Class Name dialog.
  void showAddClassNameDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Add Class Name',
          style: MyTextStyle.headlineSmall,
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

  /// Shows the Add Subject dialog.
  void showAddSubjectDialog(
      ClassModel selectedClass, String? existingSubject) {
    if (existingSubject != null) {
      subjectNameController.text = existingSubject ?? '';
    } else {
      disposeSubjectDialogControllers();
    }

    Get.dialog(
      AlertDialog(
        title: Text(
          (existingSubject == null) ? 'Add Subject' : 'Edit Subject',
          style: MyTextStyle.headlineSmall,
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
              ClassModel updatedClass =
              selectedClass.copyWith(subjects: updatedSubjects);

              addOrUpdateClass(updatedClass); // Update Class
              loadClassDetails(
                  selectedClass.className!); // Refresh class details to update subjects
              Get.back();
            },
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// Shows the Add Section dialog.
  void showAddSectionDialog(ClassModel selectedClassModel) {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Add Section',
          style: MyTextStyle.headlineSmall,
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

                    SectionModel newSection = SectionModel(
                      sectionName: sectionNameController.text,
                      classTeacherId: teacherIdController.text,
                      classTeacherName: classTeacherNameController.text,
                      capacity: int.tryParse(capacityController.text) ?? 0,
                      roomNumber: roomNumberController.text,
                      description: descriptionController.text,
                    );

                    List<SectionModel> updatedSections =
                    List.from(selectedClassModel.sections ?? []);

                    updatedSections.add(newSection);

                    ClassModel updatedClass =
                    selectedClassModel.copyWith(sections: updatedSections);

                    await _repository.addOrUpdateClass(updatedClass);

                    Get.back();
                    loadClassDetails(
                        selectedClassModel.className!); // Refresh class details to update sections
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

  /// Shows the Add Section dialog for editing an existing section.
  void showAddSectionDialogForEdit(
      ClassModel selectedClass, SectionModel existingSection) {
    sectionNameController.text = existingSection.sectionName ?? '';
    teacherIdController.text = existingSection.classTeacherId ?? '';
    classTeacherNameController.text = existingSection.classTeacherName ?? '';
    capacityController.text = existingSection.capacity?.toString() ?? '';
    roomNumberController.text = existingSection.roomNumber ?? '';
    descriptionController.text = existingSection.description ?? '';

    Get.dialog(
      AlertDialog(
        title: const Text(
          'Edit Section',
          style: MyTextStyle.headlineSmall,
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

                    SectionModel updatedSection = SectionModel(
                      sectionName: sectionNameController.text,
                      classTeacherId: teacherIdController.text,
                      classTeacherName: classTeacherNameController.text,
                      capacity: int.tryParse(capacityController.text) ?? 0,
                      roomNumber: roomNumberController.text,
                      description: descriptionController.text,
                    );

                    List<SectionModel> updatedSections =
                    List.from(selectedClass.sections ?? []);
                    int index = updatedSections
                        .indexWhere((element) => element == existingSection);
                    if (index != -1) {
                      updatedSections[index] = updatedSection;
                    }
                    ClassModel updatedClass =
                    selectedClass.copyWith(sections: updatedSections);

                    await _repository.addOrUpdateClass(updatedClass);

                    Get.back();
                    loadClassDetails(
                        selectedClass.className!); // Refresh class details to update sections
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

  /// Disposes of the section dialog controllers to avoid overlapping.
  void disposeSectionDialogControllers() {
    sectionNameController.clear();
    teacherIdController.clear();
    classTeacherNameController.clear();
    capacityController.clear();
    roomNumberController.clear();
    descriptionController.clear();
  }

  /// Disposes of the subject dialog controllers to avoid overlapping.
  void disposeSubjectDialogControllers() {
    subjectNameController.clear();
    subjectTeacherIdController.clear();
  }
}