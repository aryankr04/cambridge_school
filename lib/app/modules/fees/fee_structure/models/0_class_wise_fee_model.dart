class ClassWiseFee {
  String className; // Name of the class (e.g., "Grade 1", "Grade 2")
  double fee; // Amount of fee for the class

  ClassWiseFee({
    required this.className,
    required this.fee,
  });

  // Factory constructor to create a ClassWiseFee from a map
  factory ClassWiseFee.fromMap(Map<String, dynamic> map) {
    return ClassWiseFee(
      className: map['className'] ?? '',
      fee: map['feeAmount'] ?? 0.0,
    );
  }

  // Convert ClassWiseFee to a map
  Map<String, dynamic> toMap() {
    return {
      'className': className,
      'feeAmount': fee,
    };
  }
}
