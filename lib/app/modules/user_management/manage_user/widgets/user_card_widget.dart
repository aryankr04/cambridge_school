import '../../../../../core/utils/constants/enums/account_status.dart';
import '../../create_user/models/user_model.dart';
import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/utils/constants/text_styles.dart';
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
    final String? fullName = userProfile.fullName;
    final String? profileImageUrl = userProfile.profileImageUrl;
    final AccountStatus? accountStatusEnum = userProfile.accountStatus;
    final String userId = userProfile.userId;
    final String? rollNumber =
        userProfile.studentDetails?.rollNumber;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border:
            Border(bottom: BorderSide(color: MyColors.borderColor, width: 0.5)),
      ),
      child: InkWell(
        onTap: () => _showDetailsDialog(context), //Simplified onTap
        child: Padding(
          padding:
              const EdgeInsets.symmetric(vertical: MySizes.xs, horizontal: 16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
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
                           fullName ??
                              "N/A", //Simplified conditional display and default
                      overflow: TextOverflow.ellipsis,
                      style: MyTextStyle.titleLarge.copyWith(fontSize: 14),
                      maxLines: 1,
                    ),
                    Text(

                      '$userId (Roll no: $rollNumber)',
                      style: MyTextStyle.labelMedium.copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
              MyLabelChip(
                constraints: const BoxConstraints(minWidth: 64),
                text: accountStatusEnum!.label,
                color: accountStatusEnum.color,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileText(String name, String username) {
    return Column(
      children: [
        Text(name, style: MyTextStyle.headlineSmall),
        const SizedBox(
          height: MySizes.xs,
        ),
        Text(username, style: MyTextStyle.labelMedium),
      ],
    );
  }

  Widget _buildInfoRow(List<String> values, List<String> labels) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: MySizes.sm, horizontal: MySizes.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(values.length, (index) {
          return _buildTextColumn2(values[index], labels[index]);
        }),
      ),
    );
  }

  Widget _buildTextColumn2(String text1, String text2) {
    return Column(
      children: [
        Text(text1, style: MyTextStyle.bodyLarge),
        const SizedBox(
          height: MySizes.xs,
        ),
        Text(text2,
            style: MyTextStyle.labelSmall
                .copyWith(color: MyColors.subtitleTextColor)),
      ],
    );
  }

  // Function to show the Details Dialog
  void _showDetailsDialog(BuildContext context) {
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
                  if (userProfile.studentDetails !=
                      null) //Conditional check on the details

                    _buildProfileText(
                        userProfile.fullName ?? "N/A", userProfile.userId),
                  const SizedBox(height: MySizes.md),
                  _buildInfoRow([
                    userProfile.studentDetails?.className ?? 'N/A',
                    userProfile.studentDetails?.section ?? 'N/A',
                    userProfile.studentDetails?.rollNumber ?? 'N/A',
                    userProfile.studentDetails?.admissionNo ?? 'N/A'
                  ], [
                    'Class',
                    'Sec',
                    'Roll no.',
                    'Adm No.'
                  ]),
                  const SizedBox(
                    height: MySizes.sm,
                  ),
                  const Divider(
                    thickness: 0.5,
                    color: MyColors.dividerColor,
                    height: 1,
                  ),
                  const SizedBox(
                    height: MySizes.sm,
                  ),
                  _buildInfoRow(['934M', '76', '463B', '237'],
                      ['Followers', 'Following', 'Likes', 'Posts']),

                  const SizedBox(
                    height: MySizes.spaceBtwSections,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: MyColors.activeRed,
                          ),
                          icon: const Icon(
                            Icons.delete,
                            size: 18,
                          ), // Edit Icon
                          label: const Text('Delete',
                              style: TextStyle(color: Colors.white)),
                          onPressed: onDelete,
                        ),
                      ),
                      const SizedBox(width: MySizes.sm),
                      Expanded(
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: MyColors.activeOrange,
                          ),
                          icon: const Icon(
                            Icons.edit,
                            size: 18,
                          ), // Edit Icon
                          label: const Text('Edit',
                              style: TextStyle(color: Colors.white)),
                          onPressed: onEdit,
                        ),
                      ),
                      const SizedBox(width: MySizes.sm),
                      Expanded(
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: MyColors.activeBlue,
                          ),
                          icon: const Icon(
                            Icons.visibility,
                            size: 18,
                          ), // Edit Icon
                          label: const Text('View',
                              style: TextStyle(color: Colors.white)),
                          onPressed: onView,
                        ),
                      ),
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
}
