class SalaryDetails {
  // Basic salary details
  double basic;
  double allowances;
  double deductions;
  double netSalary;

  // Payment history
  List<PaymentHistory> paymentHistory; // List of past payments

  // Constructor
  SalaryDetails({
    required this.basic,
    required this.allowances,
    required this.deductions,
    required this.netSalary,
    required this.paymentHistory,
  });

  // Method to calculate net salary
  static double calculateNetSalary(double basic, double allowances, double deductions) {
    return basic + allowances - deductions;
  }

  // Convert to a Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'basic': basic,
      'allowances': allowances,
      'deductions': deductions,
      'netSalary': netSalary,
      'paymentHistory': paymentHistory.map((payment) => payment.toMap()).toList(),
    };
  }

  // Create SalaryDetails from Firestore data
  factory SalaryDetails.fromMap(Map<String, dynamic> map) {
    return SalaryDetails(
      basic: map['basic'],
      allowances: map['allowances'],
      deductions: map['deductions'],
      netSalary: map['netSalary'],
      paymentHistory: (map['paymentHistory'] as List)
          .map((history) => PaymentHistory.fromMap(history))
          .toList(),
    );
  }

  // Add a payment history entry
  void addPaymentHistory(PaymentHistory history) {
    paymentHistory.add(history);
  }
}

// PaymentHistory class to store individual payment records
class PaymentHistory {
  double amountPaid; // Amount paid during a transaction
  DateTime paymentDate; // Date of payment
  String paymentMethod; // Method of payment (e.g., cash, bank transfer)
  String remarks; // Additional comments (optional)

  // Constructor
  PaymentHistory({
    required this.amountPaid,
    required this.paymentDate,
    required this.paymentMethod,
    this.remarks = '',
  });

  // Convert to a Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'amountPaid': amountPaid,
      'paymentDate': paymentDate.toIso8601String(),
      'paymentMethod': paymentMethod,
      'remarks': remarks,
    };
  }

  // Create PaymentHistory from Firestore data
  factory PaymentHistory.fromMap(Map<String, dynamic> map) {
    return PaymentHistory(
      amountPaid: map['amountPaid'],
      paymentDate: DateTime.parse(map['paymentDate']),
      paymentMethod: map['paymentMethod'],
      remarks: map['remarks'] ?? '',
    );
  }
}
