// Filename: management/admin/class_management/class_management_widgets.dart
import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/constants/dynamic_colors.dart';
import 'class_model.dart';

class SubjectCard extends StatelessWidget {
  final String subject; // Use String
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const SubjectCard({
    super.key,
    required this.subject,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(MySizes.sm),
      width: double.infinity,
      decoration: BoxDecoration(
        color: MyDynamicColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                alignment: Alignment.center,
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: MyDynamicColors.primaryColor,
                  borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
                ),
                child: const Icon(
                  Icons.book,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: MySizes.spaceBtwItems),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject, // Access properties correctly
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Text(
                  //   subject.id ?? 'N/A', // Access properties correctly
                  //   style: SchoolTextStyles.labelMedium,
                  //   overflow: TextOverflow.ellipsis,
                  // ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              // if (onEdit != null)
              //   IconButton(
              //     icon: const Icon(Icons.edit, color: Colors.blue),
              //     onPressed: onEdit,
              //   ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_rounded),
                color: MyDynamicColors.activeRed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  final SchoolSectionModel schoolClass;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const SectionCard({
    super.key,
    required this.schoolClass,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(MySizes.sm),
      width: double.infinity,
      decoration: BoxDecoration(
        color: MyDynamicColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                alignment: Alignment.center,
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: MyDynamicColors.primaryColor,
                  borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
                ),
                child: Text(
                  schoolClass.sectionName ?? '',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: MySizes.spaceBtwItems),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    schoolClass.classTeacherName ?? '',
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text(
                    '${schoolClass.students?.length ?? 0} Students',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(color: MyDynamicColors.subtitleTextColor),
                  ),
                ],
              )
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit),
                color: MyDynamicColors.primaryColor,
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_rounded),
                color: MyDynamicColors.activeRed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}