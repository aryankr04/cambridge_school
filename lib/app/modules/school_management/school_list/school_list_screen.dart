import 'package:cambridge_school/app/modules/school_management/edit_school/edit_school_details_screen.dart';
import 'package:cambridge_school/app/modules/school_management/school_list/school_list_controller.dart';
import 'package:cambridge_school/app/modules/school_management/school_model.dart';
import 'package:cambridge_school/core/utils/constants/enums/account_status.dart';
import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/utils/helpers/helper_functions.dart';
import 'package:cambridge_school/core/widgets/label_chip.dart';
import 'package:cambridge_school/router.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/constants/text_styles.dart';
import '../../../../core/widgets/card_widget.dart';
import '../../../../core/widgets/divider.dart';
import '../../../../roles_manager.dart';

import 'package:shimmer/shimmer.dart';

class SchoolListScreen extends StatelessWidget {
  const SchoolListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SchoolListController controller = Get.put(SchoolListController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('School List'),
      ),
      backgroundColor: MyColors.softGrey,
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildShimmerList();
        } else if (controller.errorMessage.value != null) {
          return Center(child: Text('Error: ${controller.errorMessage.value}'));
        } else {
          return RefreshIndicator(
            onRefresh: controller.refreshSchools,
            child: ListView.builder(
              itemCount: controller.schools.length,
              padding: const EdgeInsets.all(MySizes.md),
              itemBuilder: (context, index) {
                final school = controller.schools[index];
                return SchoolTile(
                  key: ValueKey(school.schoolId),
                  school: school,
                  isEdit: true,
                  onEdit: () => controller.editSchool(school),
                  onDelete: () => controller.deleteSchool(school.schoolId),
                );
              },
            ),
          );
        }
      }),
    );
  }

  Widget _buildShimmerList() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5, // Adjust based on your typical list size
        padding: const EdgeInsets.all(MySizes.md),
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: MySizes.md),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(MySizes.cardRadiusSm)),
            child: const SizedBox(
              height: 120, // Adjust based on your card height
              width: double.infinity,
            ),
          );
        },
      ),
    );
  }
}

class SchoolTile extends StatefulWidget {
  const SchoolTile({
    super.key,
    required this.school,
    this.isEdit = false,
    required this.onEdit,
    required this.onDelete,
  });

  final SchoolModel school;
  final bool isEdit;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  State<SchoolTile> createState() => _SchoolTileState();
}

class _SchoolTileState extends State<SchoolTile> {
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    final formattedCreatedTime =
        DateFormat('d MMMM \'at\' h:mm a').format(widget.school.createdAt);

    return MyCard(
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.only(bottom: MySizes.md),
      borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
      onTap: () {
        MyHelperFunctions.navigateToScreen(
            context, EditSchoolDetailsScreen(schoolId: widget.school.schoolId));
      },
      child: Column(
        children: [
          _buildTitle(
            deviceWidth,
            widget.school.schoolName,
            widget.school.schoolId,
            widget.school.schoolLogoUrl,
          ),
          const MyDottedLine(
            dashColor: MyColors.grey,
          ),
          Padding(
            padding: const EdgeInsets.all(MySizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                  Icons.calendar_month,
                  'Created At',
                  formattedCreatedTime,
                ),
                const SizedBox(height: MySizes.md),
                _buildInfoRow(
                  Icons.person,
                  'Created By',
                  '${widget.school.createdByName} (${widget.school.createdById})',
                ),
                const SizedBox(height: MySizes.md),
                ExpansionTile(
                  minTileHeight: 24,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
                    side: BorderSide.none,
                  ),
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                    side: BorderSide.none,
                  ),
                  tilePadding: EdgeInsets.zero,
                  title: const Text(
                    'Admins',
                    style: MyTextStyle.bodyLarge,
                  ),
                  children: [
                    ...widget.school.employees
                        .where((employee) =>
                            employee.roles.contains(UserRole.schoolAdmin))
                        .map((admin) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: MySizes.sm),
                              child: _buildAdminInfoRow(
                                  admin.userName, admin.userId),
                            )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(
      double deviceWidth, String title, String subtitle, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: MySizes.sm, horizontal: MySizes.sm),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: deviceWidth * 0.1,
            height: deviceWidth * 0.1,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: MySizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: MyTextStyle.bodyLarge.copyWith(
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: MyTextStyle.labelSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          MyLabelChip(
              text: widget.school.status.label,
              color: widget.school.status.color),
          const SizedBox(
            width: MySizes.sm,
          )
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          color: MyColors.iconColor,
          size: 18,
        ),
        const SizedBox(width: MySizes.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: MyColors.subtitleTextColor.withOpacity(0.75),
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  color: MyColors.subtitleTextColor,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdminInfoRow(String name, String id) {
    return Row(
      children: [
        const Icon(
          Icons.person,
          color: MyColors.iconColor,
          size: 18,
        ),
        const SizedBox(width: MySizes.md),
        Expanded(
          child: Text(
            '$name ($id)',
            style: const TextStyle(
              fontSize: 12,
              color: MyColors.subtitleTextColor,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}



// class SchoolTile extends StatefulWidget {
//   const SchoolTile({
//     super.key,
//     required this.school,
//     this.isEdit = false,
//     required this.onEdit,
//     required this.onDelete,
//   });
//
//   final SchoolModel school;
//   final bool isEdit;
//   final VoidCallback onEdit;
//   final VoidCallback onDelete;
//
//   @override
//   State<SchoolTile> createState() => _SchoolTileState();
// }
//
// class _SchoolTileState extends State<SchoolTile> {
//   final RxBool _isExpanded = false.obs;
//
//   @override
//   Widget build(BuildContext context) {
//     final deviceWidth = MediaQuery.of(context).size.width;
//
//     final formattedCreatedTime = DateFormat('d MMMM \'at\' h:mm a')
//         .format(widget.school.createdAt ?? DateTime.now());
//
//     return MyCard(
//       padding: EdgeInsets.zero,
//       borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
//       child: ExpansionTile(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
//           side: BorderSide.none,
//         ),
//         collapsedShape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(0.0),
//           side: BorderSide.none,
//         ),
//         childrenPadding: EdgeInsets.zero,
//         tilePadding: const EdgeInsets.symmetric(horizontal: MySizes.md),
//         title: _buildTitle(
//           deviceWidth,
//           widget.school.schoolName ?? 'NA',
//           widget.school.schoolId ?? '',
//           'assets/logos/csd.png',
//         ),
//         onExpansionChanged: (bool expanded) {
//           _isExpanded.value = expanded;
//         },
//         children: [
//           const MyDottedLine(dashColor: MyColors.grey),
//           Padding(
//             padding: const EdgeInsets.all(MySizes.md),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildInfoRow(
//                   Icons.calendar_month,
//                   'Created At',
//                   formattedCreatedTime,
//                 ),
//                 const SizedBox(height: MySizes.md),
//                 _buildInfoRow(
//                   Icons.person,
//                   'Created By',
//                   '${widget.school.createdByName} (${widget.school.createdById})',
//                 ),
//                 if (widget.isEdit) _buildEditActions(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTitle(double deviceWidth, String title, String subtitle, String imagePath) {
//     return Row(
//       children: [
//         Container(
//           alignment: Alignment.center,
//           width: deviceWidth * 0.1,
//           height: deviceWidth * 0.1,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             image: DecorationImage(
//               image: AssetImage(imagePath),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         const SizedBox(width: MySizes.md),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: MyTextStyle.bodyLarge.copyWith(
//                   letterSpacing: 0,
//                   height: 1.25,
//                   fontSize: 13,
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               Text(
//                 subtitle,
//                 style: MyTextStyle.labelSmall,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildInfoRow(IconData icon, String label, String value) {
//     return Row(
//       children: [
//         Icon(
//           icon,
//           color: MyColors.subtitleTextColor.withOpacity(0.75),
//           size: 18,
//         ),
//         const SizedBox(width: MySizes.md),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 11,
//                   color: MyColors.subtitleTextColor.withOpacity(0.75),
//                   fontWeight: FontWeight.w400,
//                 ),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontSize: 12,
//                   color: MyColors.subtitleTextColor,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildEditActions() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         FilledButton.icon(
//           onPressed: widget.onEdit,
//           icon: const Icon(Icons.edit, color: Colors.white, size: 18),
//           label: const Text('Edit', style: TextStyle(color: Colors.white)),
//           style: ButtonStyle(
//             backgroundColor: WidgetStateProperty.all<Color>(MyColors.activeBlue),
//           ),
//         ),
//         const SizedBox(width: MySizes.md),
//         FilledButton.icon(
//           onPressed: () => MyConfirmationDialog.show(DialogAction.Delete, onConfirm: widget.onDelete),
//           icon: const Icon(Icons.delete, color: Colors.white, size: 18),
//           label: const Text('Delete', style: TextStyle(color: Colors.white)),
//           style: ButtonStyle(
//             backgroundColor: WidgetStateProperty.all<Color>(MyColors.activeRed),
//           ),
//         ),
//       ],
//     );
//   }
// }
