import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/widgets/selection_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/helpers/date_and_time.dart';
import '../../../../core/widgets/card_widget.dart';
import '../../../../core/widgets/divider.dart';
import '../controllers/create_school_step_7_controller.dart';
import '../models/mixed.dart';

class CreateSchoolStep4AccreditationAndAchievements extends StatelessWidget {
  final CreateSchoolStep7AccreditationAndAchievementsController controller;

  CreateSchoolStep4AccreditationAndAchievements(
      {super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(MySizes.lg),
      child: Form(
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MySelectionWidget(
                    selectedItem: controller.selectedSection.value,
                    items: const ['Accreditation', 'Awards', 'Rankings'],
                    onSelectionChanged: (value) {
                      controller.selectedSection.value = value!;
                    },                      tag: 'section',

                ),
                const SizedBox(height: MySizes.lg),
                controller.selectedSection.value == 'Accreditation'
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Accreditation Details",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // controller.showAccreditationDialog(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: MyColors.activeBlue,
                                    borderRadius: BorderRadius.circular(
                                        MySizes.borderRadiusMd + 16),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  child: Text(
                                    "Add Accreditation",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(color: MyColors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: MySizes.md),
                          Wrap(
                            spacing: 16.0,
                            runSpacing: 12.0,
                            children: accreditations.map((accreditation) {
                              return accreditationCard(
                                  accreditation.accreditingBody,
                                  accreditation.dateOfAccreditation.toString(),
                                  accreditation.validityPeriod,
                                  accreditation.standardsMet,
                                  accreditation.description);
                            }).toList(),
                          ),
                        ],
                      )
                    : const SizedBox(),
                controller.selectedSection.value == 'Awards'
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Awards Details",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: MyColors.activeBlue,
                                    borderRadius: BorderRadius.circular(
                                        MySizes.borderRadiusMd + 16),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  child: Text(
                                    "Add Award",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(color: MyColors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: MySizes.md),
                          Wrap(
                            spacing: 16.0,
                            runSpacing: 12.0,
                            children: awards.map((award) {
                              return awardCard(
                                award.name,
                                award.description,
                                award.issuedBy,
                                award.receivedDate.toString(),
                                award.level,
                              );
                            }).toList(),
                          ),
                        ],
                      )
                    : const SizedBox(),
                controller.selectedSection.value == 'Rankings'
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Rankings Details",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: MyColors.activeBlue,
                                    borderRadius: BorderRadius.circular(
                                        MySizes.borderRadiusMd + 16),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  child: Text(
                                    "Add Ranking",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(color: MyColors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: MySizes.md),
                          Wrap(
                            spacing: 16.0,
                            runSpacing: 12.0,
                            children: rankings.map((ranking) {
                              return rankingCard(
                                  ranking.title,
                                  ranking.rank,
                                  ranking.issuedBy,
                                  ranking.year,
                                  ranking.level);
                            }).toList(),
                          ),
                        ],
                      )
                    : const SizedBox(),
              ],
            )),
      ),
    );
  }

  final List<Accreditation> accreditations = [
    Accreditation(
      accreditingBody: "NAAC",
      description:
          "National Assessment and Accreditation Council certification for higher education quality.",
      dateOfAccreditation: DateTime(2024, 12, 15),
      validityPeriod: "5 Years",
      standardsMet: "Grade A",
    ),
    Accreditation(
      accreditingBody: "ISO",
      description: "ISO 9001 certification for quality management systems.",
      dateOfAccreditation: DateTime(2025, 3, 10),
      validityPeriod: "3 Years",
      standardsMet: "ISO 9001:2015",
    ),
    // Add more accreditations here...
  ];

  Widget accreditationCard(
    String accreditingBody,
    String dateOfAccreditation,
    String validityPeriod,
    String accreditationLevel,
    String description,
  ) {
    return IntrinsicHeight(
      child: MyCard(
        border: Border.all(
          width: 0.5,
          color: MyColors.borderColor.withOpacity(1),
        ),
        hasShadow: false,
        padding: EdgeInsets.zero,
        child: Row(
          children: [
            // Left indicator bar
            Container(
              width: MySizes.sm - 4,
              decoration: const BoxDecoration(
                color: MyColors.activeGreen,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(MySizes.cardRadiusMd),
                  bottomLeft: Radius.circular(MySizes.cardRadiusMd),
                ),
              ),
            ),
            // Main content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Icon and accreditation details
                        Flexible(
                          flex: 3,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Icon inside a card
                              MyCard(
                                border: Border.all(
                                  width: 0.5,
                                  color: MyColors.borderColor,
                                ),
                                borderRadius: BorderRadius.circular(
                                    MySizes.borderRadiusMd),
                                height: Get.width * 0.1,
                                width: Get.width * 0.1,
                                hasShadow: false,
                                padding: EdgeInsets.zero,
                                child: const Icon(
                                  Icons.verified,
                                  size: 24,
                                  color: MyColors.activeGreen,
                                ),
                              ),
                              const SizedBox(width: MySizes.sm),
                              // Accrediting body, date, and validity period
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      accreditingBody,
                                      style: Theme.of(Get.context!)
                                          .textTheme
                                          .bodyLarge,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1, // Limit to a single line
                                    ),
                                    const SizedBox(height: MySizes.xs - 4),
                                    Text(
                                      'Date: ${MyDateAndTimeFunction.formatToReadableDate(dateOfAccreditation)}',
                                      style: Theme.of(Get.context!)
                                          .textTheme
                                          .labelMedium,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1, // Limit to a single line
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Accreditation level chip
                        Flexible(
                          flex: 1,
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Remove',
                                  style: Theme.of(Get.context!)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(color: MyColors.activeRed),
                                ),
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: MySizes.sm,
                    ),
                    const MyDottedLine(
                      dashLength: 4,
                      dashGapLength: 4,
                      lineThickness: 1,
                      dashColor: Colors.grey,
                    ),
                    const SizedBox(
                      height: MySizes.md,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          accreditationLevel,
                          style: Theme.of(Get.context!).textTheme.bodyLarge,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1, // Limit to a single line
                        ),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            'Accreditation Level',
                            style: Theme.of(Get.context!).textTheme.labelSmall,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1, // Limit to a single line
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: MySizes.md,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          validityPeriod,
                          style: Theme.of(Get.context!).textTheme.bodyLarge,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1, // Limit to a single line
                        ),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            'Validity',
                            style: Theme.of(Get.context!).textTheme.labelSmall,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1, // Limit to a single line
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: MySizes.md,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   description,
                        //   style: Theme.of(Get.context!).textTheme.bodyLarge,
                        //   overflow: TextOverflow.ellipsis,
                        //   maxLines: 2, // Limit to a single line
                        // ),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            description,
                            style: Theme.of(Get.context!)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    color: MyColors.subtitleTextColor),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5, // Limit to a single line
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget awardCard(String name, String description, String issuedBy,
      String receivedDate, String level) {
    return IntrinsicHeight(
      child: MyCard(
        border: Border.all(
          width: 0.5,
          color: MyColors.borderColor.withOpacity(1),
        ),
        hasShadow: false,
        padding: EdgeInsets.zero,
        child: Row(
          children: [
            // Left indicator bar
            Container(
              width: MySizes.sm - 4,
              decoration: const BoxDecoration(
                color: MyColors.activeOrange,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(MySizes.cardRadiusMd),
                  bottomLeft: Radius.circular(MySizes.cardRadiusMd),
                ),
              ),
            ),
            // Main content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Icon and accreditation details
                        Flexible(
                          flex: 3,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Icon inside a card
                              MyCard(
                                border: Border.all(
                                  width: 0.5,
                                  color: MyColors.borderColor,
                                ),
                                borderRadius: BorderRadius.circular(
                                    MySizes.borderRadiusMd),
                                height: Get.width * 0.1,
                                width: Get.width * 0.1,
                                hasShadow: false,
                                padding: EdgeInsets.zero,
                                child: const Icon(
                                  Icons.emoji_events,
                                  size: 24,
                                  color: MyColors.activeOrange,
                                ),
                              ),
                              const SizedBox(width: MySizes.sm),
                              // Accrediting body, date, and validity period
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: Theme.of(Get.context!)
                                          .textTheme
                                          .bodyLarge,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1, // Limit to a single line
                                    ),
                                    const SizedBox(height: MySizes.xs - 4),
                                    Text(
                                      'Date: ${MyDateAndTimeFunction.formatToReadableDate(receivedDate)}',
                                      style: Theme.of(Get.context!)
                                          .textTheme
                                          .labelMedium,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1, // Limit to a single line
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Accreditation level chip
                        Flexible(
                          flex: 1,
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Remove',
                                  style: Theme.of(Get.context!)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(color: MyColors.activeRed),
                                ),
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: MySizes.sm,
                    ),
                    const MyDottedLine(
                      dashLength: 4,
                      dashGapLength: 4,
                      lineThickness: 1,
                      dashColor: Colors.grey,
                    ),
                    const SizedBox(
                      height: MySizes.md,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          issuedBy,
                          style: Theme.of(Get.context!).textTheme.bodyLarge,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1, // Limit to a single line
                        ),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            'Issued By',
                            style: Theme.of(Get.context!).textTheme.labelSmall,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1, // Limit to a single line
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: MySizes.md,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          level,
                          style: Theme.of(Get.context!).textTheme.bodyLarge,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1, // Limit to a single line
                        ),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            'Level',
                            style: Theme.of(Get.context!).textTheme.labelSmall,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1, // Limit to a single line
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: MySizes.md,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   description,
                        //   style: Theme.of(Get.context!).textTheme.bodyLarge,
                        //   overflow: TextOverflow.ellipsis,
                        //   maxLines: 2, // Limit to a single line
                        // ),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            description,
                            style: Theme.of(Get.context!)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    color: MyColors.subtitleTextColor),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5, // Limit to a single line
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget rankingCard(
      String title, int rank, String issuedBy, int year, String level) {
    return IntrinsicHeight(
      child: MyCard(
        border: Border.all(
          width: 0.5,
          color: MyColors.borderColor.withOpacity(1),
        ),
        hasShadow: false,
        padding: EdgeInsets.zero,
        child: Row(
          children: [
            // Left indicator bar
            Container(
              width: MySizes.sm - 4,
              decoration: const BoxDecoration(
                color: MyColors.activeBlue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(MySizes.cardRadiusMd),
                  bottomLeft: Radius.circular(MySizes.cardRadiusMd),
                ),
              ),
            ),
            // Main content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Icon and accreditation details
                        Flexible(
                          flex: 3,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Icon inside a card
                              MyCard(
                                border: Border.all(
                                  width: 0.5,
                                  color: MyColors.borderColor,
                                ),
                                borderRadius: BorderRadius.circular(
                                    MySizes.borderRadiusMd),
                                height: Get.width * 0.1,
                                width: Get.width * 0.1,
                                hasShadow: false,
                                padding: EdgeInsets.zero,
                                child: const Icon(
                                  Icons.workspace_premium,
                                  size: 24,
                                  color: MyColors.activeBlue,
                                ),
                              ),
                              const SizedBox(width: MySizes.sm),
                              // Accrediting body, date, and validity period
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: Theme.of(Get.context!)
                                          .textTheme
                                          .bodyLarge,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1, // Limit to a single line
                                    ),
                                    const SizedBox(height: MySizes.xs - 4),
                                    Text(
                                      year.toString(),
                                      style: Theme.of(Get.context!)
                                          .textTheme
                                          .labelMedium,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1, // Limit to a single line
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Accreditation level chip
                        Flexible(
                          flex: 1,
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Remove',
                                  style: Theme.of(Get.context!)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(color: MyColors.activeRed),
                                ),
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: MySizes.sm,
                    ),
                    const MyDottedLine(
                      dashLength: 4,
                      dashGapLength: 4,
                      lineThickness: 1,
                      dashColor: Colors.grey,
                    ),
                    const SizedBox(
                      height: MySizes.md,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          issuedBy,
                          style: Theme.of(Get.context!).textTheme.bodyLarge,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1, // Limit to a single line
                        ),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            'Issued By',
                            style: Theme.of(Get.context!).textTheme.labelSmall,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1, // Limit to a single line
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: MySizes.md,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          level,
                          style: Theme.of(Get.context!).textTheme.bodyLarge,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1, // Limit to a single line
                        ),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            'Level',
                            style: Theme.of(Get.context!).textTheme.labelSmall,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1, // Limit to a single line
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: MySizes.md,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final List<Ranking> rankings = [
    Ranking(
      title: "Top 10 Schools in India",
      rank: 5,
      issuedBy: "National Education Board",
      year: 2023,
      level: "National",
    ),
    Ranking(
      title: "Best School for Sports",
      rank: 1,
      issuedBy: "Sports Education Council",
      year: 2022,
      level: "National",
    ),
    Ranking(
      title: "Best Regional School in Bihar",
      rank: 1,
      issuedBy: "Bihar State Education Authority",
      year: 2023,
      level: "State",
    ),
    Ranking(
      title: "Top 50 Schools in Asia",
      rank: 20,
      issuedBy: "Asian Education Rankings",
      year: 2024,
      level: "International",
    ),
  ];

  final List<Award> awards = [
    Award(
      name: "Best School of the Year",
      description:
          "Awarded for outstanding academic performance and extracurricular activities.",
      issuedBy: "Ministry of Education",
      receivedDate: DateTime(2023, 10, 15),
      level: "National",
    ),
    Award(
      name: "Innovation in Education",
      description:
          "Recognized for implementing innovative teaching methods and technology integration.",
      issuedBy: "Education Technology Association",
      receivedDate: DateTime(2022, 12, 20),
      level: "International",
    ),
    Award(
      name: "Green Campus Award",
      description:
          "Awarded for maintaining an eco-friendly campus and promoting environmental awareness.",
      issuedBy: "Environment Conservation Organization",
      receivedDate: DateTime(2024, 1, 5),
      level: "State",
    ),
    Award(
      name: "Excellence in Sports",
      description:
          "Recognized for exceptional performance in sports competitions at the national level.",
      issuedBy: "Sports Authority of India",
      receivedDate: DateTime(2023, 11, 10),
      level: "National",
    ),
  ];
}
