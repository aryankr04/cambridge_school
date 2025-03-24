
import 'package:flutter/material.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/sizes.dart';
import '../../../../core/utils/constants/text_styles.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../class_model.dart';

class SectionTile extends StatelessWidget {
  const SectionTile({
    super.key,
    required this.section,
    required this.isEdit,
    required this.onEdit,
    required this.onDelete,
  });

  final SectionModel section;
  final bool isEdit;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.only(bottom: MySizes.md),
      decoration: BoxDecoration(
        color: MyColors.activeBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(MySizes.cardRadiusSm),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: MySizes.sm, horizontal: MySizes.md),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              width: deviceWidth * 0.1,
              height: deviceWidth * 0.1,
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius:
                BorderRadius.all(Radius.circular(MySizes.cardRadiusXs)),
                color: MyColors.white,
              ),
              child: Text(
                section.sectionName,
                style: MyTextStyle.headlineMedium
                    .copyWith(color: MyColors.activeBlue),
              ),
            ),
            const SizedBox(width: MySizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.classTeacherName,
                    style: MyTextStyle.bodyLarge.copyWith(fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    section.classTeacherId,
                    style: MyTextStyle.labelSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: MySizes.sm),
            if (isEdit)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildIconButton(
                    icon: Icons.edit,
                    color: MyColors.activeBlue,
                    onPressed: onEdit,
                  ),
                  _buildIconButton(
                    icon: Icons.delete,
                    color: MyColors.activeRed,
                    onPressed: () {
                      MyConfirmationDialog.show(DialogAction.Delete,
                          onConfirm: onDelete);
                    },
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: color,
        size: 20,
      ),
      color: color,
    );
  }
}
