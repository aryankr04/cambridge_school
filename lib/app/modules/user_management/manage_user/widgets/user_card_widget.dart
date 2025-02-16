import '../../create_user/models/user_model.dart';
import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/utils/constants/text_styles.dart';
import 'package:cambridge_school/core/widgets/button.dart';
import 'package:cambridge_school/core/widgets/card_widget.dart';
import 'package:cambridge_school/core/widgets/label_chip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserCardWidget extends StatelessWidget {
  final UserModel userProfile;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const UserCardWidget({
    super.key,
    required this.userProfile,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final String fullName = userProfile.fullName;
    final String? profileImageUrl = userProfile.profileImageUrl;
    final String accountStatus = userProfile.accountStatus;
    final String userId = userProfile.userId;
    final AccountStatus accountStatusEnum =
    _getAccountStatusFromString(accountStatus);
    final String rollNumber = userProfile.studentDetails?.rollNumber ?? ''; //Simplified roll number access

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom: BorderSide(color: MyColors.borderColor, width: 0.5)),
      ),
      child: InkWell(
        onTap: () => _showDetailsDialog(context), //Simplified onTap
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: profileImageUrl != null
                    ? NetworkImage(profileImageUrl)
                    : null,
                child: profileImageUrl == null
                    ? const Icon(Icons.person)
                    : null, //Simplified Avatar
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rollNumber.isNotEmpty ? '$rollNumber. $fullName' : fullName, //Simplified conditional display
                      style: MyTextStyles.titleLarge.copyWith(fontSize: 15),
                    ),
                    Text(
                      '$userId',
                      style: MyTextStyles.labelMedium.copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
              MyLabelChip(
                constraints: const BoxConstraints(minWidth: 64),
                text: accountStatusEnum.displayValue,
                color: accountStatusEnum.color,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to show the Details Dialog
  void _showDetailsDialog(BuildContext context) {
    final AccountStatus accountStatusEnum =
    _getAccountStatusFromString(userProfile.accountStatus);
    final String rollNumber = userProfile.studentDetails?.rollNumber ?? ''; //Simplified roll number access
    final String? className = userProfile.studentDetails?.className; // Get class name
    final String? sectionName = userProfile.studentDetails?.section;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: Get.width,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 48,
                    backgroundImage: userProfile.profileImageUrl != null
                        ? NetworkImage(userProfile.profileImageUrl!)
                        : null,
                    child: userProfile.profileImageUrl == null
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  const SizedBox(
                    height: MySizes.md,
                  ),
                  Text(
                    userProfile.fullName,
                    style: MyTextStyles.titleLarge.copyWith(fontSize: 18),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: MySizes.sm,
                  ),
                  Text(
                    'User ID: ${userProfile.userId}',
                    style: MyTextStyles.bodyMedium.copyWith(fontSize: 13),
                  ),
                  const SizedBox(
                    height: MySizes.md,
                  ),
                  if (userProfile.studentDetails != null) //Conditional check on the details
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: MyCard(
                            border: Border.all(
                                width: 1, color: MyColors.borderColor),
                            child: Column(
                              children: [
                                Text(className ?? 'N/A',
                                    style: MyTextStyles.titleLarge),
                                Text(
                                  'Class',
                                  style: MyTextStyles.bodyMedium
                                      .copyWith(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: MyCard(
                            border: Border.all(
                                width: 1, color: MyColors.borderColor),
                            child: Column(
                              children: [
                                Text(sectionName ?? 'N/A',
                                    style: MyTextStyles.titleLarge),
                                Text(
                                  'Section',
                                  style: MyTextStyles.bodyMedium
                                      .copyWith(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: MyCard(
                            border: Border.all(
                                width: 1, color: MyColors.borderColor),
                            child: Column(
                              children: [
                                Text(rollNumber,
                                    style: MyTextStyles.titleLarge),
                                Text(
                                  'Roll No',
                                  style: MyTextStyles.bodyMedium
                                      .copyWith(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: MySizes.md,
                  ),
                  SizedBox(
                    width: Get.width,
                    child: MyLabelChip(
                      padding: const EdgeInsets.symmetric(
                          vertical: MySizes.sm, horizontal: MySizes.md),
                      textSize: 14,
                      text: 'Account is ${accountStatusEnum.displayValue}',
                      color: accountStatusEnum.color,
                      suffixIcon: Icon(
                        accountStatusEnum.icon,
                        color: accountStatusEnum.color,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: MySizes.spaceBtwSections,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: MyButton(
                            text: 'Delete',
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                              onDelete();
                            },
                            backgroundColor: MyColors.activeRed,
                            hasShadow: false,
                            borderRadius: 8,
                          )),
                      const SizedBox(
                        width: MySizes.sm,
                      ),
                      Expanded(
                          child: MyButton(
                              text: 'Edit',
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                                onEdit();
                              },
                              backgroundColor: MyColors.activeOrange,
                              hasShadow: false,
                              borderRadius: 8)),
                      const SizedBox(
                        width: MySizes.sm,
                      ),
                      Expanded(
                          child: MyButton(
                              text: 'View',
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                                onView();
                              },
                              backgroundColor: MyColors.activeBlue,
                              hasShadow: false,
                              borderRadius: 8)),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  AccountStatus _getAccountStatusFromString(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AccountStatus.active;
      case 'inactive':
        return AccountStatus.inactive;
      case 'pending':
        return AccountStatus.pending;
      case 'suspended':
        return AccountStatus.suspended;
      default:
        return AccountStatus.pending; // Default to pending or handle error
    }
  }
}

// Enum for Account Status
enum AccountStatus {
  active,
  inactive,
  pending,
  suspended,
}

extension AccountStatusExtension on AccountStatus {
  String get displayValue {
    switch (this) {
      case AccountStatus.active:
        return 'Active';
      case AccountStatus.inactive:
        return 'Inactive';
      case AccountStatus.pending:
        return 'Pending';
      case AccountStatus.suspended:
        return 'Suspended';
      default:
        return 'Unknown';
    }
  }

  Color get color {
    switch (this) {
      case AccountStatus.active:
        return Colors.green;
      case AccountStatus.inactive:
        return Colors.grey;
      case AccountStatus.pending:
        return Colors.orange;
      case AccountStatus.suspended:
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  IconData get icon {
    switch (this) {
      case AccountStatus.active:
        return Icons.check_circle;
      case AccountStatus.inactive:
        return Icons.pause_circle_filled;
      case AccountStatus.pending:
        return Icons.access_time;
      case AccountStatus.suspended:
        return Icons.cancel;
      default:
        return Icons.error;
    }
  }
}