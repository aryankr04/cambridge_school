import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/constants/colors.dart';
import '../../../../../core/utils/constants/sizes.dart';
import '../../../../../core/widgets/detail_card_widget.dart';
import '../../../../../core/widgets/divider.dart';
import '../../../../../core/widgets/text_field.dart';
import '../controllers/books_and_stationery_fee_structure_controller.dart';
import '../models/0_fee_input_with_2_controller_model.dart';
import '../models/books_and_stationary_fee_structure_model.dart';

class BooksAndStationeryFeeStructureWidget extends StatelessWidget {
  final BooksAndStationeryFeeStructureWidgetController controller =
      Get.put(BooksAndStationeryFeeStructureWidgetController());

  BooksAndStationeryFeeStructureWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            MyDetailCard(
              title: 'Class Text Books',
              titleStyle: Theme.of(context).textTheme.titleLarge,
              icon: Icons.app_registration,
              color: MyColors.activeOrange,
              hasSameBorderColor: true,
              widget: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...controller.classTextBookInputs.asMap().entries.map(
                        (entry) {
                          final classIndex = entry.key;
                          final classData = entry.value;
                          return _buildClassInput(
                              context, classIndex, classData);
                        },
                      ),
                      const SizedBox(height: MySizes.md),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text("Add Class"),
                          onPressed: controller.addClass,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            MyDetailCard(
              title: 'Stationary',
              titleStyle: Theme.of(context).textTheme.titleLarge,
              icon: Icons.app_registration,
              color: MyColors.activeOrange,
              hasSameBorderColor: true,
              widget: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...controller.stationaryItemInputs.asMap().entries.map(
                        (entry) {
                          final itemIndex = entry.key;
                          final itemData = entry.value;
                          return _buildStationaryItemInput(itemIndex, itemData);
                        },
                      ),
                      const SizedBox(height: MySizes.md),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text("Add Item"),
                          onPressed: controller.addItem,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassInput(
    BuildContext context,
    int classIndex,
    ClassTextBookInput classData,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Class ${classIndex + 1}',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: 15),
            ),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: MyDottedLine(
                  dashLength: 4,
                  dashGapLength: 4,
                  lineThickness: 1,
                  dashColor: Colors.grey,
                ),
              ),
            ),
            IconButton(
              onPressed: () => controller.removeClass(classIndex),
              icon: const Icon(
                Icons.delete_outline,
                color: MyColors.iconColor,
              ),
            ),
          ],
        ),
        ...classData.textBooks.asMap().entries.map(
          (bookEntry) {
            final bookIndex = bookEntry.key;
            final bookData = bookEntry.value;
            return _buildTextBookInput(classIndex, bookIndex, bookData);
          },
        ),
        const SizedBox(height: MySizes.md),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            icon: const Icon(Icons.add),
            label: const Text("Add Book"),
            onPressed: () => controller.addTextBook(classIndex),
          ),
        ),
        const SizedBox(height: MySizes.md),
      ],
    );
  }

  Widget _buildTextBookInput(
      int classIndex, int bookIndex, FeeInput2 bookData) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: MySizes.sm),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: MyTextField(
              height: 42,
              hintText: 'Book Name',
              controller: bookData.nameController,
              keyboardType: TextInputType.name,
            ),
          ),
          const SizedBox(width: MySizes.md),
          Expanded(
            flex: 1,
            child: MyTextField(
              height: 42,
              hintText: 'Fee',
              textAlign: TextAlign.center,
              controller: bookData.feeController,
              keyboardType: TextInputType.number,
            ),
          ),
          IconButton(
            onPressed: () => controller.removeTextBook(classIndex, bookIndex),
            icon: const Icon(
              Icons.delete_outline,
              color: MyColors.iconColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStationaryItemInput(int itemIndex, FeeInput2 itemData) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: MySizes.sm),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: MyTextField(
              height: 42,
              hintText: 'Item Name',
              controller: itemData.nameController,
              keyboardType: TextInputType.name,
            ),
          ),
          const SizedBox(width: MySizes.md),
          Expanded(
            flex: 1,
            child: MyTextField(
              height: 42,
              hintText: 'Fee',
              textAlign: TextAlign.center,
              controller: itemData.feeController,
              keyboardType: TextInputType.number,
            ),
          ),
          IconButton(
            onPressed: () => controller.removeItem(itemIndex),
            icon: const Icon(
              Icons.delete_outline,
              color: MyColors.iconColor,
            ),
          ),
        ],
      ),
    );
  }
}
