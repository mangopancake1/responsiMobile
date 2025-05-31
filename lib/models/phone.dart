class Phone {
  final int id;
  final String name;
  final String brand;
  final double price;
  final String imageUrl;
  final String specification;

  Phone({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.imageUrl,
    required this.specification,
  });

  factory Phone.fromJson(Map<String, dynamic> json) {
    return Phone(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      brand: json['brand'] ?? '',
      price: json['price'] is num
          ? (json['price'] as num).toDouble()
          : double.tryParse(json['price'].toString()) ?? 0.0,
      imageUrl: json['img_url'] ?? '',
      specification: json['specification'] ?? '',
    );
  }

  /// Untuk Create/Update (tidak termasuk id dan img_url)
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "brand": brand,
      "price": price,
      "specification": specification,
    };
  }

  /// Untuk menyimpan ke favorite (include semua field)
  Map<String, dynamic> toJsonWithId() {
    return {
      "id": id,
      "name": name,
      "brand": brand,
      "price": price,
      "img_url": imageUrl,
      "specification": specification,
    };
  }
}