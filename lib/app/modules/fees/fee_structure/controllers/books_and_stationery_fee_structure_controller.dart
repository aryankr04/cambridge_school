import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/0_fee_input_with_2_controller_model.dart';
import '../models/0_fee_item_model.dart';
import '../models/books_and_stationary_fee_structure_model.dart';

class BooksAndStationeryFeeStructureWidgetController extends GetxController {
  RxList<ClassTextBookInput> classTextBookInputs = <ClassTextBookInput>[].obs;
  RxList<FeeInput2> stationaryItemInputs = <FeeInput2>[].obs;

  // Method to add a new class
  void addClass() {
    classTextBookInputs.add(ClassTextBookInput(textBooks: []));
    update(); // Trigger UI update
  }

  // Method to add a new textbook to a specific class (given by index)
  void addTextBook(int index) {
    classTextBookInputs[index].textBooks.add(FeeInput2(
          feeController: TextEditingController(),
          nameController: TextEditingController(),
        ));
    update(); // Trigger UI update
  }

  // Method to remove a class by index
  void removeClass(int index) {
    classTextBookInputs.removeAt(index);
    update(); // Trigger UI update
  }

  // Method to remove a specific textbook from a class
  void removeTextBook(int classIndex, int bookIndex) {
    classTextBookInputs[classIndex].textBooks.removeAt(bookIndex);
    update(); // Trigger UI update
  }
  void addItem() {
    stationaryItemInputs.add(
      FeeInput2(
        nameController: TextEditingController(),
        feeController: TextEditingController(),
      ),
    );
  }

  void removeItem(int itemIndex) {
    classTextBookInputs.removeAt(itemIndex);
  }
  // Convert the structure to a map for storing in the database
  BooksAndStationeryFeeStructure getStructure() {
    return BooksAndStationeryFeeStructure(
      name: 'Books and Stationery Fee',
      isOptional: false, // Can be changed dynamically if needed
      classTextBookLists: classTextBookInputs.map((input) {
        return ClassTextBookList(
          className: input.className,
          textbooks: input.textBooks.map((textBook) {
            return FeeItem(
              itemName: textBook.nameController.text,
              price: double.tryParse(textBook.feeController.text) ?? 0.0,
            );
          }).toList(),
        );
      }).toList(),
      items: [], // Add general stationery items if necessary
    );
  }
}

