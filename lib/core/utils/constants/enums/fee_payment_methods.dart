enum FeePaymentMethod { cash, bankTransfer, upi, card, cheque, online }

extension FeePaymentMethodExtension on FeePaymentMethod {
  /// Returns a user-friendly label for the payment method.
  String get label => _labels[this] ?? "Online Payment";

  /// Returns a description explaining the payment method.
  String get description => _descriptions[this] ?? "Fee paid through an online payment gateway.";

  /// Mapping of `FeePaymentMethod` to readable labels.
  static const Map<FeePaymentMethod, String> _labels = {
    FeePaymentMethod.cash: "Cash",
    FeePaymentMethod.bankTransfer: "Bank Transfer",
    FeePaymentMethod.upi: "UPI (Google Pay, PhonePe, Paytm)",
    FeePaymentMethod.card: "Credit/Debit Card",
    FeePaymentMethod.cheque: "Cheque",
    FeePaymentMethod.online: "Online Payment",
  };

  /// Reverse mapping of labels to `FeePaymentMethod` enum.
  static final Map<String, FeePaymentMethod> _labelToEnum = {
    for (var entry in _labels.entries) entry.value.toLowerCase(): entry.key,
  };

  /// Mapping of `FeePaymentMethod` to detailed descriptions.
  static const Map<FeePaymentMethod, String> _descriptions = {
    FeePaymentMethod.cash: "Payment made in cash at the school office.",
    FeePaymentMethod.bankTransfer: "Fee transferred directly to the school's bank account.",
    FeePaymentMethod.upi: "Fee paid via UPI apps like Google Pay, PhonePe, Paytm.",
    FeePaymentMethod.card: "Payment made using a credit or debit card.",
    FeePaymentMethod.cheque: "Fee paid via a bank cheque.",
    FeePaymentMethod.online: "Fee paid through an online payment gateway.",
  };

  /// Converts a string to the corresponding `FeePaymentMethod` enum.
  static FeePaymentMethod fromString(String value) {
    return _labelToEnum[value.toLowerCase()] ?? FeePaymentMethod.online;
  }

  /// Returns a list of all payment method labels.
  static List<String> get labelsList => _labels.values.toList();
}
