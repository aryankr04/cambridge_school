import 'package:get/get.dart';
import '../models/hostel_fee_structure_model.dart';

class HostelFeeStructureController extends GetxController {
  RxList<HostelPlanInput> hostelPlanInputs = <HostelPlanInput>[].obs;

  // Add a new independent plan
  void addHostelPlanInput() {
    hostelPlanInputs.add(HostelPlanInput());
  }

  // Remove the plan at the specified index
  void removeHostelPlanInput(int index) {
    hostelPlanInputs.removeAt(index);
  }

  // Method to generate and return the HostelFeeStructure object
  HostelFeeStructure generateHostelFeeStructure() {
    List<HostelPlan> hostelPlans = hostelPlanInputs.map((input) {
      return input.toHostelPlan();
    }).toList();

    // For demonstration, we'll hardcode 'category', 'frequency', and 'isOptional'
    return HostelFeeStructure(
      isOptional: false, // Example optional flag
      category: 'Recurring', // Example category
      frequency: 'Monthly', // Example frequency
      hostelPlans: hostelPlans,
    );
  }

  @override
  void onClose() {
    for (var planInput in hostelPlanInputs) {
      planInput.dispose(); // Dispose each plan's controllers
    }
    super.onClose();
  }
}
