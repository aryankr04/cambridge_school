import 'package:flutter/material.dart';

import '../../models/fee_structure.dart';
import '0_fee_input_with_2_controller_model.dart';
import '0_fee_item_model.dart';

class BooksAndStationeryFeeStructure {
  String name; // Name of the fee structure (e.g., Books & Stationery)
  bool isOptional; // Whether the fee is optional
  List<ClassTextBookList> classTextBookLists; // List of textbooks by class
  List<FeeItem> items; // List of general stationery items

  BooksAndStationeryFeeStructure({
    required this.name,
    this.isOptional = false,
    required this.classTextBookLists,
    required this.items,
  });

  // Method to convert the structure to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isOptional': isOptional,
      'classTextBookLists': classTextBookLists
          .map((classTextBookList) => classTextBookList.toMap())
          .toList(),
      'items': items.map((item) => item.toMap()).toList(),
    };
  }

  // Method to create a structure from a map
  factory BooksAndStationeryFeeStructure.fromMap(Map<String, dynamic> map) {
    return BooksAndStationeryFeeStructure(
      name: map['name'],
      isOptional: map['isOptional'] ?? false,
      classTextBookLists: (map['classTextBookLists'] as List<dynamic>)
          .map((classTextBookList) =>
          ClassTextBookList.fromMap(classTextBookList))
          .toList(),
      items: (map['items'] as List<dynamic>)
          .map((item) => FeeItem.fromMap(item))
          .toList(),
    );
  }
}


// Class representing the input for textbooks of a specific class
class ClassTextBookInput {
  String className; // Name of the class
  List<FeeInput2> textBooks; // List of FeeInput objects for textbooks

  ClassTextBookInput({
    this.className = '',
    required this.textBooks,
  });

  // Method to add a new textbook to the class
  void addTextBook() {
    textBooks.add(
      FeeInput2(
        feeController: TextEditingController(),
        nameController: TextEditingController(),
      ),
    );
  }

  // Method to remove a textbook from the class at a given index
  void removeTextBook(int index) {
    textBooks.removeAt(index);
  }
}

// Class representing a collection of textbooks and stationery for a class
class ClassTextBookList {
  String className; // Name of the class (e.g., "Class 1")
  List<FeeItem> textbooks; // List of textbooks for this class

  ClassTextBookList({
    required this.className,
    required this.textbooks,
  });

  // Method to convert ClassTextBookList to a map
  Map<String, dynamic> toMap() {
    return {
      'className': className,
      'textbooks': textbooks.map((item) => item.toMap()).toList(),
    };
  }

  // Method to create a ClassTextBookList from a map
  factory ClassTextBookList.fromMap(Map<String, dynamic> map) {
    return ClassTextBookList(
      className: map['className'],
      textbooks: (map['textbooks'] as List<dynamic>)
          .map((item) => FeeItem.fromMap(item))
          .toList(),
    );
  }
}
