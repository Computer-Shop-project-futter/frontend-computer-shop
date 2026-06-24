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

	Map<String, dynamic> toDbJson() {
		return {
			'benchmark_id': benchmarkId,
			'product_id': productId,
			'metric_key': metricKey,
			'metric_value': metricValue,
			'bar_percent': barPercent,
		};
	}

	factory ProductBenchmarkModel.fromDbJson(Map<String, dynamic> json) {
		return ProductBenchmarkModel(
			benchmarkId: json['benchmark_id']?.toString() ?? '',
			productId: json['product_id']?.toString() ?? '',
			metricKey: json['metric_key']?.toString() ?? '',
			metricValue: json['metric_value']?.toString() ?? '',
			barPercent: (json['bar_percent'] as num?)?.toDouble() ?? 0,
		);
	}
  // Add these methods to ProductBenchmarkModel class

Map<String, dynamic> toMap() {
  return {
    'benchmark_id': benchmarkId,
    'product_id': productId,
    'metric_key': metricKey,
    'metric_value': metricValue,
    'bar_percent': barPercent,
  };
}

factory ProductBenchmarkModel.fromMap(Map<String, dynamic> map) {
  return ProductBenchmarkModel(
    benchmarkId: map['benchmark_id'] as String,
    productId: map['product_id'] as String,
    metricKey: map['metric_key'] as String,
    metricValue: map['metric_value'] as String,
    barPercent: map['bar_percent'] as double,
  );
}
}
