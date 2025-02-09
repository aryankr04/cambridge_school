class FeePayment {
  String feeName;            // Fee type (e.g., Tuition, Transport)
  double amountPaid;         // Amount paid in this transaction
  double remainingAmount;    // Remaining amount after this payment
  String paymentDate;        // Date of payment
  String paymentMethod;      // Method (e.g., Cash, Card, Online)
  String? remarks;           // Optional notes about the payment

  FeePayment({
    required this.feeName,
    required this.amountPaid,
    required this.remainingAmount,
    required this.paymentDate,
    required this.paymentMethod,
    this.remarks,
  });

  // Method to convert FeePayment object to a Map
  Map<String, dynamic> toMap() {
    return {
      'feeName': feeName,
      'amountPaid': amountPaid,
      'remainingAmount': remainingAmount,
      'paymentDate': paymentDate,
      'paymentMethod': paymentMethod,
      'remarks': remarks,
    };
  }

  // Factory method to create a FeePayment object from a Map
  factory FeePayment.fromMap(Map<String, dynamic> map) {
    return FeePayment(
      feeName: map['feeName'],
      amountPaid: map['amountPaid'],
      remainingAmount: map['remainingAmount'],
      paymentDate: map['paymentDate'],
      paymentMethod: map['paymentMethod'],
      remarks: map['remarks'],
    );
  }
}
