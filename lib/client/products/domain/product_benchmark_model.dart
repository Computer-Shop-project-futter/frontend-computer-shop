class ProductBenchmarkModel {
	final String benchmarkId;
	final String productId;
	final String metricKey;
	final String metricValue;
	final double barPercent;

	const ProductBenchmarkModel({
		required this.benchmarkId,
		required this.productId,
		required this.metricKey,
		required this.metricValue,
		required this.barPercent,
	});

	factory ProductBenchmarkModel.fromJson(Map<String, dynamic> json) {
		return ProductBenchmarkModel(
			benchmarkId: json['benchmarkId']?.toString() ?? '',
			productId: json['productId']?.toString() ?? '',
			metricKey: json['metricKey']?.toString() ?? '',
			metricValue: json['metricValue']?.toString() ?? '',
			barPercent: (json['barPercent'] as num?)?.toDouble() ?? 0,
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'benchmarkId': benchmarkId,
			'productId': productId,
			'metricKey': metricKey,
			'metricValue': metricValue,
			'barPercent': barPercent,
		};
	}
}
