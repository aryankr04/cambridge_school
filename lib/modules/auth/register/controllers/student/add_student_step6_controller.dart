import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/constants/dynamic_colors.dart';
import '../../../../../core/utils/constants/lists.dart';
import '../../../../../core/utils/constants/sizes.dart';
import '../../../../../core/widgets/selection_widget.dart';

class StudentStep6FormController extends GetxController {
  final GlobalKey<FormState> step6FormKey = GlobalKey<FormState>();

   RxString selectedFavoriteSubject = RxString('');
   RxString selectedFavoriteSport = RxString('');
   RxString selectedFavoriteTeacher = RxString('');

  final TextEditingController goalController = TextEditingController();
  final TextEditingController favoriteFoodController = TextEditingController();

   RxList<String> selectedHobbies = <String>[].obs;
  final TextEditingController hobbyController = TextEditingController();


  void clearForm(){
    selectedFavoriteSubject.value = '';
    selectedFavoriteSport.value = '';
    selectedFavoriteTeacher.value = '';
    goalController.clear();
    favoriteFoodController.clear();
    selectedHobbies.clear();
    hobbyController.clear();
  }

  @override
  void onClose() {
    goalController.dispose();
    favoriteFoodController.dispose();
    hobbyController.dispose();
    super.onClose();
  }

  bool isFormValid() {
    return step6FormKey.currentState?.validate() ?? false;
  }

  Future<void> showHobbySelectionDialog() async {
    await showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          backgroundColor: Colors.white,
          title: const Text('Select Hobbies'),
          content: Container(
            width: Get.width,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MySelectionWidget(
                    items: MyLists.languageOptions,
                    isMultiSelect: true,
                    selectedItem: selectedHobbies.isNotEmpty
                        ? selectedHobbies.first
                        : null,
                    onMultiSelectChanged: (List<String> selectedItems) {
                      selectedHobbies.assignAll(selectedItems);
                    },
                    displayTextBuilder: (item) =>
                    item,
                    selectedColor: Colors.green,
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
                      hobbyController.text = selectedHobbies.join(', ');
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: MySizes.md),
                      decoration: BoxDecoration(
                        color: MyDynamicColors.activeBlue,
                        borderRadius:
                        BorderRadius.circular(MySizes.cardRadiusXs),
                      ),
                      alignment:
                      Alignment.center,
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
}