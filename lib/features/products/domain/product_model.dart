class ProductModel {
	final String productId;
	final String categoryId;
	final String brandId;
	final String name;
	final String shortDescription;
	final double basePrice;
	final double? dealPrice;
	final String thumbnailUrl;
	final bool isFeatured;
	final bool isDeal;
	final bool isActive;

	const ProductModel({
		required this.productId,
		required this.categoryId,
		required this.brandId,
		required this.name,
		required this.shortDescription,
		required this.basePrice,
		required this.dealPrice,
		required this.thumbnailUrl,
		required this.isFeatured,
		required this.isDeal,
		required this.isActive,
	});

	factory ProductModel.fromJson(Map<String, dynamic> json) {
		return ProductModel(
			productId: json['productId']?.toString() ?? '',
			categoryId: json['categoryId']?.toString() ?? '',
			brandId: json['brandId']?.toString() ?? '',
			name: json['name']?.toString() ?? '',
			shortDescription: json['shortDescription']?.toString() ?? '',
			basePrice: (json['basePrice'] as num?)?.toDouble() ?? 0,
			dealPrice: (json['dealPrice'] as num?)?.toDouble(),
			thumbnailUrl: json['thumbnailUrl']?.toString() ?? '',
			isFeatured: json['isFeatured'] == true,
			isDeal: json['isDeal'] == true,
			isActive: json['isActive'] == true,
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'productId': productId,
			'categoryId': categoryId,
			'brandId': brandId,
			'name': name,
			'shortDescription': shortDescription,
			'basePrice': basePrice,
			'dealPrice': dealPrice,
			'thumbnailUrl': thumbnailUrl,
			'isFeatured': isFeatured,
			'isDeal': isDeal,
			'isActive': isActive,
		};
	}
  // Add these methods to ProductModel

Map<String, dynamic> toDbJson() {
  return {
    'product_id': productId,
    'category_id': categoryId,
    'brand_id': brandId,
    'name': name,
    'short_description': shortDescription,
    'base_price': basePrice,
    'deal_price': dealPrice,
    'thumbnail_url': thumbnailUrl,
    'is_featured': isFeatured ? 1 : 0,
    'is_deal': isDeal ? 1 : 0,
    'is_active': isActive ? 1 : 0,
  };
}
// Add these methods to ProductModel class

Map<String, dynamic> toMap() {
  return {
    'product_id': productId,
    'category_id': categoryId,
    'brand_id': brandId,
    'name': name,
    'short_description': shortDescription,
    'base_price': basePrice,
    'deal_price': dealPrice,
    'thumbnail_url': thumbnailUrl,
    'is_featured': isFeatured ? 1 : 0,
    'is_deal': isDeal ? 1 : 0,
    'is_active': isActive ? 1 : 0,
  };
}

factory ProductModel.fromMap(Map<String, dynamic> map) {
  return ProductModel(
    productId: map['product_id'] as String,
    categoryId: map['category_id'] as String,
    brandId: map['brand_id'] as String,
    name: map['name'] as String,
    shortDescription: map['short_description'] as String,
    basePrice: map['base_price'] as double,
    dealPrice: map['deal_price'] as double?,
    thumbnailUrl: map['thumbnail_url'] as String? ?? '',
    isFeatured: (map['is_featured'] as int) == 1,
    isDeal: (map['is_deal'] as int) == 1,
    isActive: (map['is_active'] as int) == 1,
  );
}

factory ProductModel.fromDbJson(Map<String, dynamic> json) {
  return ProductModel(
    productId: json['product_id'] as String,
    categoryId: json['category_id'] as String,
    brandId: json['brand_id'] as String,
    name: json['name'] as String,
    shortDescription: json['short_description'] as String,
    basePrice: json['base_price'] as double,
    dealPrice: json['deal_price'] as double?,
    thumbnailUrl: json['thumbnail_url'] as String? ?? '',
    isFeatured: (json['is_featured'] as int) == 1,
    isDeal: (json['is_deal'] as int) == 1,
    isActive: (json['is_active'] as int) == 1,
  );
}
}

