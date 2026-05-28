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
}
