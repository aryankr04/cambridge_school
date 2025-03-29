enum FeePaymentMethod {
  cash(
    label: "Cash",
    description: "Payment made in cash at the school office.",
  ),
  bankTransfer(
    label: "Bank Transfer",
    description: "Fee transferred directly to the school's bank account.",
  ),
  upi(
    label: "UPI (Google Pay, PhonePe, Paytm)",
    description: "Fee paid via UPI apps like Google Pay, PhonePe, Paytm.",
  ),
  card(
    label: "Credit/Debit Card",
    description: "Payment made using a credit or debit card.",
  ),
  cheque(
    label: "Cheque",
    description: "Fee paid via a bank cheque.",
  ),
  online(
    label: "Online Payment",
    description: "Fee paid through an online payment gateway.",
  );

  const FeePaymentMethod({
    required this.label,
    required this.description,
  });

  final String label;
  final String description;

  static FeePaymentMethod fromString(String value) {
    return FeePaymentMethod.values.firstWhere(
          (element) => element.label.toLowerCase() == value.toLowerCase(),
      orElse: () => FeePaymentMethod.online,
    );
  }

  static List<String> get labelsList =>
      FeePaymentMethod.values.map((e) => e.label).toList();
}