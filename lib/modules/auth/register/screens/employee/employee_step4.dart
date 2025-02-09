// import 'package:flutter/material.dart';
// import 'package:form_field_validator/form_field_validator.dart';
// import 'package:get/get.dart';
// import '../../../../../core/utils/constants/lists.dart';
// import '../../../../../core/utils/constants/sizes.dart';
// import '../../../../../core/widgets/dropdown_field.dart';
// import '../../../../../core/widgets/text_field.dart';
// import '../../controllers/school_staff/add_school_staff_step4_controller.dart';
//
//
// class EmployeeStep4Form extends StatelessWidget {
//   final SchoolStaffStep4FormController controller;
//
//   const EmployeeStep4Form({super.key, required this.controller});
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(SchoolSizes.defaultSpace),
//         child: Form(
//           key: controller.step4FormKey,
//           child: Column(
//             children: <Widget>[
//               SchoolTextFormField(
//                 controller: controller.mobileNoController,
//                 labelText: 'Mobile No.',
//                 keyboardType: TextInputType.phone,
//                 validator: MultiValidator([
//                   RequiredValidator(errorText: 'Please enter mobile number'),
//                   LengthRangeValidator(
//                     min: 10,
//                     max: 10,
//                     errorText: 'Please enter 10-digit mobile no.',
//                   ),
//                 ]).call,
//               ),
//               const SizedBox(height: SchoolSizes.defaultSpace),
//               SchoolTextFormField(
//                 controller: controller.mobileNoController,
//                 labelText: 'Emergency Mobile No.',
//                 keyboardType: TextInputType.phone,
//                 validator: MultiValidator([
//                   RequiredValidator(errorText: 'Please enter mobile number'),
//                   LengthRangeValidator(
//                     min: 10,
//                     max: 10,
//                     errorText: 'Please enter 10-digit mobile no.',
//                   ),
//                 ]).call,
//               ),
//               const SizedBox(height: SchoolSizes.defaultSpace),
//               SchoolTextFormField(
//                 controller: controller.emailAddressController,
//                 labelText: 'Email',
//                 keyboardType: TextInputType.emailAddress,
//                 validator:
//                 EmailValidator(errorText: 'Please enter a valid email').call,
//               ),
//               const SizedBox(height: SchoolSizes.defaultSpace),
//               SchoolTextFormField(
//                 controller: controller.addressController,
//                 labelText: 'Address',
//                 keyboardType: TextInputType.streetAddress,
//                 validator: RequiredValidator(errorText: 'Please enter address').call,
//               ),
//               const SizedBox(height: SchoolSizes.defaultSpace),
//               SchoolTextFormField(
//                 controller: controller.mobileNoController,
//                 labelText: 'Pincode',
//                 keyboardType: TextInputType.phone,
//                 validator: MultiValidator([
//                   RequiredValidator(errorText: 'Please enter pin code number'),
//                   LengthRangeValidator(
//                     min: 6,
//                     max: 6,
//                     errorText: 'Please enter 6 digit valid pincode.',
//                   ),
//                 ]).call,
//               ),
//               const SizedBox(height: SchoolSizes.defaultSpace),
//               SchoolDropdownFormField(
//                 items: SchoolLists.schoolTransportModes,
//                 labelText: "Mode of Transport",
//                 isValidate: true,
//                 onSelected: (value) {
//                   controller.selectedModeOfTransport.value = value!;
//                 },
//               ),
//               const SizedBox(height: SchoolSizes.defaultSpace),
//               Obx(() =>
//               controller.selectedModeOfTransport.value == 'School Transport'
//                   ? SchoolDropdownFormField(
//                 items: SchoolLists.classList,
//                 labelText: "Vehicle No",
//                 isValidate: true,
//                 onSelected: (value) {
//                   controller.selectedVehicleNo.value = value!;
//                 },
//               )
//                   : const SizedBox()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
