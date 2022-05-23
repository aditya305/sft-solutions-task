class ProductDataModel {
  final String name;
  final String description;
  final int quantity;

  ProductDataModel({
    required this.name,
    required this.description,
    required this.quantity,
  });

  @override
  String toString() => this.quantity.toString();

  ProductDataModel copyWith(
      {String? name, String? description, int? quantity}) {
    return ProductDataModel(
      name: name ?? this.name,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
    );
  }

  factory ProductDataModel.fromJson(Map<String, dynamic> json) {
    return ProductDataModel(
      name: json['name'],
      description: json['description'],
      quantity: int.parse(json['quantity']),
    );
  }
}
