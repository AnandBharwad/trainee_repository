class ProductdataModel {
  String? id;
  String name;
  num price;
  String description;
  String imageUrl;
  num rating;
  String category;

  ProductdataModel({
    this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) "id": id,
      "name": name,
      "price": price,
      "description": description,
      "imageUrl": imageUrl,
      "rating": rating,
      "category": category,
    };
  }

  factory ProductdataModel.fromJson(Map<String, dynamic> json) {
    return ProductdataModel(
      id: json["id"]?.toString(),
      name: json["name"]?.toString() ?? "unknown",
      price: (json["price"] as num?)?.toDouble() ?? 0.0,
      description: json["description"]?.toString() ?? "Unknown",
      imageUrl: json["imageUrl"]?.toString() ?? "Unknown Url",
      rating: (json["rating"] as num?)?.toDouble() ?? 0.0,
      category: json["category"]?.toString() ?? "Unknown",
    );
  }
}
