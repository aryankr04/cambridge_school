class FeeItem {
  String itemName; // Name of the item (e.g., "Textbook", "Notebook")
  double price; // Price of the item

  FeeItem({
    required this.itemName,
    required this.price,
  });

  // Method to convert FeeItem to a map
  Map<String, dynamic> toMap() {
    return {
      'itemName': itemName,
      'price': price,
    };
  }

  // Method to create FeeItem from a map
  factory FeeItem.fromMap(Map<String, dynamic> map) {
    return FeeItem(
      itemName: map['itemName'],
      price: map['price'],
    );
  }
}
