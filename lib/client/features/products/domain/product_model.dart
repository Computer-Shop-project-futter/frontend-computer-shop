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
      productId: map['product_id']?.toString() ?? '',
      categoryId: map['category_id']?.toString() ?? '',
      brandId: map['brand_id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      shortDescription: map['short_description']?.toString() ?? '',
      basePrice: (map['base_price'] as num?)?.toDouble() ?? 0,
      dealPrice: (map['deal_price'] as num?)?.toDouble(),
      thumbnailUrl: map['thumbnail_url']?.toString() ?? '',
      isFeatured: _toBool(map['is_featured']),
      isDeal: _toBool(map['is_deal']),
      isActive: _toBool(map['is_active']),
    );
  }

  factory ProductModel.fromDbJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['product_id']?.toString() ?? '',
      categoryId: json['category_id']?.toString() ?? '',
      brandId: json['brand_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      shortDescription: json['short_description']?.toString() ?? '',
      basePrice: (json['base_price'] as num?)?.toDouble() ?? 0,
      dealPrice: (json['deal_price'] as num?)?.toDouble(),
      thumbnailUrl: json['thumbnail_url']?.toString() ?? '',
      isFeatured: _toBool(json['is_featured']),
      isDeal: _toBool(json['is_deal']),
      isActive: _toBool(json['is_active']),
    );
  }
}

// Helper to convert various DB representations to boolean
bool _toBool(dynamic v) {
  if (v == null) return false;
  if (v is bool) return v;
  if (v is num) return v != 0;
  if (v is String) {
    final lower = v.toLowerCase();
    return lower == 'true' || lower == '1' || lower == 't' || lower == 'y' || lower == 'yes';
  }
  return false;
}
