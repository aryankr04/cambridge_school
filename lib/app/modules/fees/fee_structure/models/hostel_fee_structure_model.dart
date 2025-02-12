

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HostelFeeStructure {
  bool isOptional; // Whether the fee is optional (e.g., not mandatory)
  String category; // Category of the fee (e.g., "One-time", "Recurring")
  String frequency; // Frequency of the fee (e.g., Monthly, Annually)
  List<HostelPlan> hostelPlans; // List of different hostel plans available

  HostelFeeStructure({
    required this.isOptional,
    required this.category,
    required this.frequency,
    required this.hostelPlans,
  });

  // Method to get a description of the hostel fee structure
  String getFeeStructureDescription() {
    return 'Fee Category: $category\nFrequency: $frequency\nAvailable Plans: ${hostelPlans.length}';
  }

  // Method to convert HostelFeeStructure to a map
  Map<String, dynamic> toMap() {
    return {
      'isOptional': isOptional,
      'category': category,
      'frequency': frequency,
      'hostelPlans': hostelPlans.map((plan) => plan.toMap()).toList(),
    };
  }

  // Method to create a HostelFeeStructure from a map
  factory HostelFeeStructure.fromMap(Map<String, dynamic> map) {
    return HostelFeeStructure(
      isOptional: map['isOptional'],
      category: map['category'],
      frequency: map['frequency'],
      hostelPlans: List<HostelPlan>.from(
          map['hostelPlans']?.map((plan) => HostelPlan.fromMap(plan))),
    );
  }
}

class HostelPlan {
  String roomType; // Room type: Single, Double, Triple
  bool isAC; // Whether the room is AC or Non-AC
  bool includesMeals; // Whether meals are included
  int timesOfMealsPerDay; // Number of meals served per day
  bool isVeg; // Whether the meals are vegetarian or non-vegetarian
  List<String>
  availableFacilities; // List of additional facilities available (e.g., Wi-Fi, Laundry)
  double fee; // Total fee for this plan

  HostelPlan({
    required this.roomType,
    required this.isAC,
    required this.includesMeals,
    required this.timesOfMealsPerDay,
    required this.isVeg,
    required this.availableFacilities,
    required this.fee,
  });

  // Method to get the description of the hostel plan
  String getPlanDescription() {
    String acStatus = isAC ? 'AC' : 'Non-AC';
    String mealType = includesMeals ? 'Meals Included' : 'No Meals';
    String mealOption = isVeg ? 'Vegetarian' : 'Non-Vegetarian';
    String facilities = availableFacilities.isNotEmpty
        ? 'Available Facilities: ${availableFacilities.join(', ')}'
        : 'No Additional Facilities';
    return '$roomType Room - $acStatus, $mealType, $mealOption, $timesOfMealsPerDay Meals per Day. $facilities';
  }

  // Method to calculate the fee based on the room type, AC/non-AC, and meals
  double calculateFee() {
    double baseFee;

    // Base fee based on room type
    switch (roomType) {
      case 'Single':
        baseFee = 5000.0;
        break;
      case 'Double':
        baseFee = 3500.0;
        break;
      case 'Triple':
        baseFee = 2500.0;
        break;
      default:
        baseFee = 0.0;
    }

    // Additional fee based on AC or Non-AC
    if (isAC) {
      baseFee += 1000.0; // Add extra for AC
    }

    // Additional fee based on meals
    if (includesMeals) {
      baseFee += 1500.0; // Add for meals
      baseFee += 200.0 * timesOfMealsPerDay; // Extra for meals per day
    }

    // Additional fee for vegetarian meals
    if (isVeg) {
      baseFee += 500.0; // Extra for vegetarian meals
    }

    // Additional facilities cost
    baseFee += availableFacilities.length *
        300.0; // Each additional facility costs 300

    // Set the calculated fee
    fee = baseFee;
    return fee;
  }

  // Method to convert HostelPlan to a map
  Map<String, dynamic> toMap() {
    return {
      'roomType': roomType,
      'isAC': isAC,
      'includesMeals': includesMeals,
      'timesOfMealsPerDay': timesOfMealsPerDay,
      'isVeg': isVeg,
      'availableFacilities': availableFacilities,
      'fee': fee,
    };
  }

  // Method to create a HostelPlan from a map
  factory HostelPlan.fromMap(Map<String, dynamic> map) {
    return HostelPlan(
      roomType: map['roomType'],
      isAC: map['isAC'],
      includesMeals: map['includesMeals'],
      timesOfMealsPerDay: map['timesOfMealsPerDay'],
      isVeg: map['isVeg'],
      availableFacilities: List<String>.from(map['availableFacilities']),
      fee: map['fee'],
    );
  }
}

class HostelPlanInput {
  final TextEditingController planNameController = TextEditingController();
  final TextEditingController feeController = TextEditingController();

  // These reactive variables are independent for each plan.
  RxString roomType = 'Double'.obs;
  RxBool isAC = false.obs;
  RxBool includesMeals = false.obs;
  RxInt timesOfMealsPerDay = 3.obs;
  RxBool isVeg = false.obs;
  RxList<String> availableFacilities = <String>[].obs;

  void dispose() {
    planNameController.dispose();
    feeController.dispose();
  }

  HostelPlan toHostelPlan() {
    return HostelPlan(
      roomType: roomType.value,
      isAC: isAC.value,
      includesMeals: includesMeals.value,
      timesOfMealsPerDay: timesOfMealsPerDay.value,
      isVeg: isVeg.value,
      availableFacilities: List<String>.from(availableFacilities),
      fee: double.tryParse(feeController.text) ?? 0.0,
    );
  }
}