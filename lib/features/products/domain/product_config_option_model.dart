class ProductConfigOptionModel {
	final String optionId;
	final String productId;
	final String optionGroup;
	final String optionLabel;
	final double priceDelta;
	final bool isDefault;

	const ProductConfigOptionModel({
		required this.optionId,
		required this.productId,
		required this.optionGroup,
		required this.optionLabel,
		required this.priceDelta,
		required this.isDefault,
	});

	factory ProductConfigOptionModel.fromJson(Map<String, dynamic> json) {
		return ProductConfigOptionModel(
			optionId: json['optionId']?.toString() ?? '',
			productId: json['productId']?.toString() ?? '',
			optionGroup: json['optionGroup']?.toString() ?? '',
			optionLabel: json['optionLabel']?.toString() ?? '',
			priceDelta: (json['priceDelta'] as num?)?.toDouble() ?? 0,
			isDefault: json['isDefault'] == true,
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'optionId': optionId,
			'productId': productId,
			'optionGroup': optionGroup,
			'optionLabel': optionLabel,
			'priceDelta': priceDelta,
			'isDefault': isDefault,
		};
	}

	Map<String, dynamic> toDbJson() {
		return {
			'option_id': optionId,
			'product_id': productId,
			'option_group': optionGroup,
			'option_label': optionLabel,
			'price_delta': priceDelta,
			'is_default': isDefault ? 1 : 0,
		};
	}

	factory ProductConfigOptionModel.fromDbJson(Map<String, dynamic> json) {
		return ProductConfigOptionModel(
			optionId: json['option_id']?.toString() ?? '',
			productId: json['product_id']?.toString() ?? '',
			optionGroup: json['option_group']?.toString() ?? '',
			optionLabel: json['option_label']?.toString() ?? '',
			priceDelta: (json['price_delta'] as num?)?.toDouble() ?? 0,
			isDefault: (json['is_default'] == 1 || json['is_default'] == true),
		);
	}
  // Add these methods to ProductConfigOptionModel class

Map<String, dynamic> toMap() {
  return {
    'option_id': optionId,
    'product_id': productId,
    'option_group': optionGroup,
    'option_label': optionLabel,
    'price_delta': priceDelta,
    'is_default': isDefault ? 1 : 0,
  };
}

factory ProductConfigOptionModel.fromMap(Map<String, dynamic> map) {
  return ProductConfigOptionModel(
    optionId: map['option_id'] as String,
    productId: map['product_id'] as String,
    optionGroup: map['option_group'] as String,
    optionLabel: map['option_label'] as String,
    priceDelta: map['price_delta'] as double,
    isDefault: (map['is_default'] as int) == 1,
  );
}
}
