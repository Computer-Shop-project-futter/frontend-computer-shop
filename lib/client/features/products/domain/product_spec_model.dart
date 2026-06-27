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

	Map<String, dynamic> toDbJson() {
		return {
			'spec_id': specId,
			'product_id': productId,
			'spec_key': specKey,
			'spec_value': specValue,
			'unit': unit,
		};
	}

	factory ProductSpecModel.fromDbJson(Map<String, dynamic> json) {
		return ProductSpecModel(
			specId: json['spec_id']?.toString() ?? '',
			productId: json['product_id']?.toString() ?? '',
			specKey: json['spec_key']?.toString() ?? '',
			specValue: json['spec_value']?.toString() ?? '',
			unit: json['unit']?.toString(),
		);
	}
  // Add these methods to ProductSpecModel class

Map<String, dynamic> toMap() {
  return {
    'spec_id': specId,
    'product_id': productId,
    'spec_key': specKey,
    'spec_value': specValue,
    'unit': unit,
  };
}

factory ProductSpecModel.fromMap(Map<String, dynamic> map) {
  return ProductSpecModel(
    specId: map['spec_id'] as String,
    productId: map['product_id'] as String,
    specKey: map['spec_key'] as String,
    specValue: map['spec_value'] as String,
    unit: map['unit'] as String?,
  );
}
}
