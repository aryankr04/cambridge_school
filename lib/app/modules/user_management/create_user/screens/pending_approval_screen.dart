import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:cambridge_school/core/widgets/label_chip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/constants/sizes.dart';
import '../models/user_model.dart';

class PendingApprovalScreen extends StatelessWidget {
  final UserModel? userData;

  PendingApprovalScreen({super.key, this.userData});

  final _isExpanded = false.obs; //Using Getx observable for state managemnet

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context,constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.all(MySizes.defaultSpace),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
                crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
                children: [
                  const SizedBox(height: MySizes.lg),
                  _buildPendingIcon(),
                  const SizedBox(height: MySizes.spaceBtwSections),
                  _buildTitle(context),
                  const SizedBox(height: MySizes.md),
                  _buildSubtitle(context),
                  const SizedBox(height: MySizes.spaceBtwSections),
                  if (userData != null) _buildUserInfoCard(context, userData!),
                  const SizedBox(height: MySizes.spaceBtwSections),
                  _buildLoginButton(),
                  const SizedBox(height: MySizes.spaceBtwSections),
                  _buildRegisterButton(),
                  const SizedBox(height: MySizes.spaceBtwSections),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPendingIcon() {
    return Center(
      child: CircleAvatar(
        backgroundColor: MyColors.activeOrange.withOpacity(0.1),
        radius: 80,
        child: const Icon(
          Icons.hourglass_empty_rounded,
          size: 90,
          color: MyColors.activeOrange,
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      'Account Under Approval',
      style: Theme.of(context).textTheme.headlineMedium,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    return Text(
      'Your account is currently under review. We\'ll notify you once it\'s approved.',
      style: Theme.of(context).textTheme.bodyLarge,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildLoginButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () => Get.offAllNamed('/'),
        child: const Text('Login'),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Center(
      child: OutlinedButton(
        onPressed: () => Get.offAllNamed('/register'),
        child: const Text('Register New Account'),
      ),
    );
  }

  Widget _buildUserInfoCard(BuildContext context, UserModel userData) {
    return GestureDetector(
      onTap: () {
        _isExpanded.value = !_isExpanded.value;
      },
      child: Center(
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(MySizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserInfoHeader(context, userData),
                const SizedBox(height: MySizes.md + 4),
                _buildChangeDetailsButton(context),
                Obx(() => _isExpanded.value
                    ? _buildExpandedDetails(context, userData)
                    : const SizedBox()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoHeader(BuildContext context, UserModel userData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildUserAvatarAndDetails(context, userData),
        _buildAccountStatusChip(userData),
      ],
    );
  }

  Widget _buildUserAvatarAndDetails(BuildContext context, UserModel userData) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: MyColors.placeholderColor.withOpacity(0.1),
          child: const Icon(Icons.person, color: MyColors.grey),
        ),
        const SizedBox(width: MySizes.lg),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userData.fullName??'', style: Theme.of(context).textTheme.titleLarge),
            Row(
              children: [
                Text(
                  "Class: ${userData.studentDetails?.className ?? 'N/A'}${userData.studentDetails?.section ?? 'N/A'}",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(width: MySizes.md),
                Text(
                  "Roll no: ${userData.studentDetails?.rollNumber ?? 'N/A'}",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAccountStatusChip(UserModel userData) {
    String statusText;
    Color chipColor;

    switch (userData.accountStatus) {
      case 'pending':
        statusText = "Pending";
        chipColor = MyColors.activeOrange;
        break;
      case 'suspended':
        statusText = "Suspended";
        chipColor = MyColors.activeRed;
        break;
      case 'approved':
        statusText = "Approved";
        chipColor = MyColors.activeGreen;
        break;
      default:
        statusText = "N/A";
        chipColor = MyColors.grey;
    }

    return MyLabelChip(
      text: statusText,
      color: chipColor,
    );
  }

  Widget _buildChangeDetailsButton(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: FilledButton(
        onPressed: () {},
        child: Text(
          'Change Registration Details',
          // style: Theme.of(context)
          //     .textTheme
          //     .bodyLarge
          //     ?.copyWith(color: SchoolColors.activeBlue),
        ),
      ),
    );
  }

  Widget _buildExpandedDetails(BuildContext context, UserModel userData) {
    return Column(
      children: [
        const Divider(color: MyColors.dividerColor),
        const SizedBox(height: MySizes.md),
        Text("Registration Details",
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: MySizes.sm),
        ..._buildUserDataRows(context, userData),
      ],
    );
  }

  List<Widget> _buildUserDataRows(BuildContext context, UserModel userData) {
    return [
      _buildDataRow(context, "Name:", userData.fullName??''),
      _buildDataRow(context, "Email:", userData.email??''),
      _buildDataRow(context, "Mobile No:", userData.phoneNo??''),
      _buildDataRow(context, "Nationality:", userData.nationality??'NA'),
      _buildDataRow(context, "Date of Birth:", userData.dob.toString()),
      _buildDataRow(context, "Religion:", userData.religion??'NA'),
      _buildDataRow(context, "Category:", userData.category??'NA'),
      _buildDataRow(context, "Gender:", userData.gender??'NA'),
      _buildDataRow(context, "Blood Group:", userData.bloodGroup??'NA'),
      // _buildDataRow(context, "Aadhaar No:", userData.aadhaarNo??'NA'),
      // _buildDataRow(context, "Address:", userData.address??'NA'),
      // _buildDataRow(context, "State:", userData.permanentAddress.state),
      // _buildDataRow(context, "District:", userData.district),
      // _buildDataRow(context, "City:", userData.city),
      // _buildDataRow(context, "Pin Code:", userData.pinCode),
      // _buildDataRow(context, "Mode of Transport:", userData.modeOfTransport),
      // _buildDataRow(context, "Vehicle No:", userData.vehicleNo),
      // _buildDataRow(context, "House/Team:", userData.houseOrTeam),
      // _buildDataRow(context, "Fav Subject:", userData.favSubject),
      // _buildDataRow(context, "Fav Teacher:", userData.favTeacher),
      // _buildDataRow(context, "Fav Sports:", userData.favSports),
      // _buildDataRow(context, "Fav Food:", userData.favFood),
      // _buildDataRow(context, "Hobbies:", userData.hobbies.join(', ')),
      // _buildDataRow(context, "Goal:", userData.goal),
      _buildDataRow(context, "Username:", userData.username),
    ];
  }

  Widget _buildDataRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: MySizes.xs + 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child:
            Text('$label ', style: Theme.of(context).textTheme.bodyMedium),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w500, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}