class FeeDetail {
  String feeName;                       // Name of the fee (e.g., Tuition, Transport)
  String frequency;                     // Monthly, Annually, Once
  double amount;                        // Fee amount
  bool isOptional;                      // True if fee is optional (e.g., transport)
  Map<String, bool>? monthlyPaymentStatus; // Map of months and their payment status (for monthly fees only)
  bool isPaid;                          // True if the entire fee is paid (used for non-monthly fees)
  String? dueDate;                      // Due date for the fee (if applicable)
  String? additionalInfo;               // Additional information (e.g., distance for transport)

  FeeDetail({
    required this.feeName,
    required this.frequency,
    required this.amount,
    this.isOptional = false,
    this.isPaid = false,
    this.monthlyPaymentStatus,
    this.dueDate,
    this.additionalInfo,
  });

  /// Initialize monthlyPaymentStatus for monthly fees
  void initializeMonthlyPayments() {
    if (frequency.toLowerCase() == "monthly") {
      monthlyPaymentStatus = {
        "January": false,
        "February": false,
        "March": false,
        "April": false,
        "May": false,
        "June": false,
        "July": false,
        "August": false,
        "September": false,
        "October": false,
        "November": false,
        "December": false,
      };
    }
  }

  // Convert FeeDetail to Map
  Map<String, dynamic> toMap() {
    return {
      'feeName': feeName,
      'frequency': frequency,
      'amount': amount,
      'isOptional': isOptional,
      'isPaid': isPaid,
      'monthlyPaymentStatus': monthlyPaymentStatus,
      'dueDate': dueDate,
      'additionalInfo': additionalInfo,
    };
  }

  // Create FeeDetail from Map
  factory FeeDetail.fromMap(Map<String, dynamic> map) {
    return FeeDetail(
      feeName: map['feeName'] ?? '',
      frequency: map['frequency'] ?? '',
      amount: map['amount'] ?? 0.0,
      isOptional: map['isOptional'] ?? false,
      isPaid: map['isPaid'] ?? false,
      monthlyPaymentStatus: map['monthlyPaymentStatus'] != null
          ? Map<String, bool>.from(map['monthlyPaymentStatus'])
          : null,
      dueDate: map['dueDate'],
      additionalInfo: map['additionalInfo'],
    );
  }
}
