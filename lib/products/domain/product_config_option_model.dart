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
}
