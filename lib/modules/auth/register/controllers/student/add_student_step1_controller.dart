
import 'package:cambridge_school/core/utils/constants/lists.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/constants/dynamic_colors.dart';
import '../../../../../core/utils/constants/sizes.dart';
import '../../../../../core/widgets/selection_widget.dart';

class StudentStep1FormController extends GetxController {
  final GlobalKey<FormState> step1FormKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  TextEditingController dateOfBirthController = TextEditingController();

  Rx<DateTime> selectedDateOfBirth = DateTime.now().obs;


  Rx<String> selectedGender = Rx<String>('');
  Rx<String> selectedNationality = Rx<String>('');
  Rx<String> selectedReligion = Rx<String>('');
  Rx<String> selectedCategory = Rx<String>('');

  RxList<String> selectedLanguages = <String>[].obs;
  TextEditingController languagesController = TextEditingController();

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    languagesController.dispose();
    super.onClose();
  }

  Future<void> showLanguagesSelectionDialog() async {
    await showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          backgroundColor: Colors.white,
          title: const Text('Select Languages'),
          content: Container(
            width: Get.width,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MySelectionWidget(
                    items: MyLists.languageOptions,
                    isMultiSelect: true,
                    selectedItem: selectedLanguages.isNotEmpty
                        ? selectedLanguages.first
                        : null,
                    onMultiSelectChanged: (List<String> selectedItems) {
                      selectedLanguages.assignAll(selectedItems);
                    },

                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  // Make the button take up the available width
                  child: InkWell(
                    onTap: () {
                      languagesController.text = selectedLanguages.join(', ');
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: MySizes.md),
                      decoration: BoxDecoration(
                        color: MyDynamicColors.activeBlue,
                        borderRadius:
                        BorderRadius.circular(MySizes.cardRadiusXs),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'OK',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  bool isFormValid() {
    return step1FormKey.currentState?.validate() ?? false;
  }
}
