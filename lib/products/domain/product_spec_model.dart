class ProductSpecModel {
	final String specId;
	final String productId;
	final String specKey;
	final String specValue;
	final String? unit;

	const ProductSpecModel({
		required this.specId,
		required this.productId,
		required this.specKey,
		required this.specValue,
		required this.unit,
	});

	factory ProductSpecModel.fromJson(Map<String, dynamic> json) {
		return ProductSpecModel(
			specId: json['specId']?.toString() ?? '',
			productId: json['productId']?.toString() ?? '',
			specKey: json['specKey']?.toString() ?? '',
			specValue: json['specValue']?.toString() ?? '',
			unit: json['unit']?.toString(),
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'specId': specId,
			'productId': productId,
			'specKey': specKey,
			'specValue': specValue,
			'unit': unit,
		};
	}
}
