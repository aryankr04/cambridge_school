
import '0_fee_item_model.dart';

class OtherFeeStructure {
  List<FeeItem> fees;

  OtherFeeStructure({
    required this.fees,
  });

  // Convert OtherFeeStructure to a map
  Map<String, dynamic> toMap() {
    return {
      'fees': fees.map((fee) => fee.toMap()).toList(),
    };
  }

  // Create OtherFeeStructure from a map
  factory OtherFeeStructure.fromMap(Map<String, dynamic> map) {
    return OtherFeeStructure(
      fees: List<FeeItem>.from(
          map['fees']?.map((fee) => FeeItem.fromMap(fee)) ?? []),
    );
  }
}
