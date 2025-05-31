class Phone {
  final String id;
  final String name;
  final String brand;
  final String price;
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
      id: json['id'],
      name: json['name'],
      brand: json['brand'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      specification: json['specification'],
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'price': price,
      'specification': specification,
      'imageUrl': imageUrl,
    };
  }
}
