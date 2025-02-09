import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/constants/sizes.dart';
import '../../../../../core/widgets/image_picker.dart';
import '../../../../../core/widgets/text_field.dart';
import '../../controllers/student/add_student_step7_controller.dart';

class StudentStep7Form extends StatelessWidget {

  const StudentStep7Form({super.key,});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentStep7FormController>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(MySizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MyTextField(
              labelText: 'Aadhaar No.',
              keyboardType: TextInputType.number,
              validator: MultiValidator([
                RequiredValidator(errorText: ''),
                LengthRangeValidator(
                    max: 12, min: 12, errorText: 'Enter valid Aadhaar No.'),
              ]).call,
              controller: controller.aadhaarNoController,
            ),
            const SizedBox(
              height: MySizes.defaultSpace,
            ),
            Obx(() => MyImagePickerField(
              image: controller.profileImage.value,
              onImageSelected: controller.setPassportSizeImage,
              label: 'Profile',
            )),
            const SizedBox(height: MySizes.defaultSpace),
            Obx(() => MyImagePickerField(
              image: controller.birthCertificateImage.value,
              onImageSelected: controller.setBirthCertificateImage,
              label: 'Birth Certificate',
            )),
            const SizedBox(height: MySizes.defaultSpace),
            Obx(() => MyImagePickerField(
              image: controller.transferCertificateImage.value,
              onImageSelected: controller.setTransferCertificateImage,
              label: 'Transfer Certificate',
            )),
            const SizedBox(height: MySizes.defaultSpace),
            Obx(() => MyImagePickerField(
              image: controller.aadhaarCardImage.value,
              onImageSelected: controller.setAadhaarCardImage,
              label: 'Aadhaar Card',
            )),
            const SizedBox(height: MySizes.defaultSpace),

          ],
        ),
      ),
    );
  }
}
