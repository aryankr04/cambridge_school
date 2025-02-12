class UniformFeeStructure {
  String category; // Category of the fee (e.g., "One-time", "Recurring")
  String frequency; // Frequency of the fee (e.g., "Monthly", "Annually")
  bool isOptional; // Whether the fee is optional or mandatory
  List<UniformItem>
      uniformItems; // List of uniform items (e.g., Shirt, Pants, Tie, etc.)

  UniformFeeStructure({
    required this.category,
    required this.frequency,
    required this.isOptional,
    required this.uniformItems,
  });

  // Method to get a description of the uniform fee structure
  String getFeeDescription() {
    return 'Uniform Fee Structure: $category ($frequency)\n' +
        'Optional: $isOptional\n' +
        'Number of Items: ${uniformItems.length}';
  }

  // Method to convert UniformFeeStructure to a map
  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'frequency': frequency,
      'isOptional': isOptional,
      'uniformItems': uniformItems.map((item) => item.toMap()).toList(),
    };
  }

  // Method to create a UniformFeeStructure from a map
  factory UniformFeeStructure.fromMap(Map<String, dynamic> map) {
    return UniformFeeStructure(
      category: map['category'],
      frequency: map['frequency'],
      isOptional: map['isOptional'],
      uniformItems: List<UniformItem>.from(
          map['uniformItems']?.map((item) => UniformItem.fromMap(item))),
    );
  }
}

class UniformItem {
  String name; // Name of the uniform item (e.g., Shirt, Pants)
  double price; // Price of the uniform item
  String size; // Size of the uniform item (e.g., S, M, L, XL)

  UniformItem({
    required this.name,
    required this.price,
    required this.size,
  });

  // Method to get a description of the uniform item
  String getItemDescription() {
    return '$name (Size: $size) - Price: $price';
  }

  // Method to convert UniformItem to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'size': size,
    };
  }

  // Method to create a UniformItem from a map
  factory UniformItem.fromMap(Map<String, dynamic> map) {
    return UniformItem(
      name: map['name'],
      price: map['price'],
      size: map['size'],
    );
  }
}
