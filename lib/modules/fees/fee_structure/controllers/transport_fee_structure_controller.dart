import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/fee_structure.dart';
import '../models/0_fee_input_model.dart';
import '../models/transport_fee_structure_model.dart'; // Assuming this contains your TransportFeeStructure and DistanceSlab models

class TransportFeeController extends GetxController {
  RxList<FeeInput> distanceSlabs = <FeeInput>[].obs; // List of distance slabs
  TextEditingController baseFee = TextEditingController(); // Controller for base fee

  // Add a new distance slab with default values
  void addDistanceSlab() {
    distanceSlabs.add(FeeInput(feeController: TextEditingController()));
  }

  // Remove a distance slab at the given index
  void removeDistanceSlab(int index) {
    distanceSlabs.removeAt(index);
  }

  // Update the distance for a specific index
  void updateDistance(int index, String value) {
    distanceSlabs[index].name = value; // Accessing the 'distance' field directly
    update(); // Update the UI if necessary
  }

  // Update the fee for a specific index
  void updateFee(int index, String value) {
    distanceSlabs[index].feeController.text = value; // Accessing the 'fee' controller's text property
    update(); // Update the UI if necessary
  }

  // Generate and return the TransportFeeStructure object
  TransportFeeStructure generateTransportFeeStructure() {
    // Parse the base fee
    double baseFeeValue = double.tryParse(baseFee.text) ?? 0.0;

    // Generate the list of distance slabs
    List<DistanceSlab> slabs = distanceSlabs.map((slab) {
      return DistanceSlab(
        distance: double.tryParse(slab.name) ?? 0.0,
        fee: double.tryParse(slab.feeController.text) ?? 0.0,
      );
    }).toList();

    // Create and return the TransportFeeStructure object
    return TransportFeeStructure(
      baseFee: baseFeeValue,
      distanceSlabs: slabs,
      frequency: 'monthly', // Example frequency (can be dynamic as needed)
      isOptional: false, // Example optional flag (can be dynamic)
      category: 'transport', // Example category (can be dynamic)
    );
  }
}
