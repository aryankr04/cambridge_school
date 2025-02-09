import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/constants/dynamic_colors.dart';
import '../../../../../core/utils/constants/lists.dart';
import '../../../../../core/utils/constants/sizes.dart';
import '../../../../../core/widgets/dropdown_field.dart';
import '../../../../../core/widgets/selection_widget.dart';
import '../../../../../core/widgets/text_field.dart';
import '../../controllers/student/add_student0_controller.dart';
import '../../controllers/student/add_student_step6_controller.dart';

class StudentStep6Form extends StatelessWidget {
  const StudentStep6Form({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentStep6FormController>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(MySizes.defaultSpace),
        child: Form(
          key: controller.step6FormKey,
          child: Column(
            children: <Widget>[
              MyDropdownField(
                  options: MyLists.subjectOptions,
                  labelText: 'Favorite Subject',
                  isValidate: true,
                  onSelected: (value) {
                    controller.selectedFavoriteSubject.value = value!;
                  },
                  selectedValue: controller.selectedFavoriteSubject),
              const SizedBox(height: MySizes.defaultSpace),
              MyDropdownField(
                  options: MyLists.favoriteSportOptions,
                  labelText: 'Favorite Sport',
                  isValidate: true,
                  onSelected: (value) {
                    controller.selectedFavoriteSport.value = value!;
                  },
                  selectedValue: controller.selectedFavoriteSport),
              const SizedBox(height: MySizes.defaultSpace),
              MyDropdownField(
                  options: MyLists.favoriteActivityOptions,
                  labelText: 'Favorite Teacher',
                  isValidate: true,
                  onSelected: (value) {
                    controller.selectedFavoriteTeacher.value = value!;
                  },
                  selectedValue: controller.selectedFavoriteTeacher),
              const SizedBox(height: MySizes.defaultSpace),
              MyTextField(
                labelText: 'Favorite Food',
                keyboardType: TextInputType.text,
                controller: controller.favoriteFoodController,
              ),
              const SizedBox(height: MySizes.defaultSpace),
              MyTextField(
                onTap: controller.showHobbySelectionDialog,
                readOnly: true,
                labelText: "Hobbies",
                hintText: "Select Hobbies",
                keyboardType: TextInputType.name,
                controller: controller.hobbyController,
                //validator: RequiredValidator(errorText: '').call,
              ),
              const SizedBox(height: MySizes.defaultSpace),
              MyTextField(
                labelText: 'Goals',
                keyboardType: TextInputType.text,
                controller: controller.goalController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
