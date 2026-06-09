class Product {
  final String id;
  final String name;
  final double price;
  final String? imageUrl;

  Product({required this.id, required this.name, required this.price, this.imageUrl});

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as String,
        name: json['name'] as String,
        price: (json['price'] as num).toDouble(),
        imageUrl: json['imageUrl'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        if (imageUrl != null) 'imageUrl': imageUrl,
      };
}
