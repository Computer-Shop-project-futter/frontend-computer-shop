class PromotionModel {
  final String promotionId;
  final String title;
  final String description;
  final String promoType;
  final String startDate;
  final String endDate;
  final String bannerUrl;
  final bool isActive;

  const PromotionModel({
    required this.promotionId,
    required this.title,
    required this.description,
    required this.promoType,
    required this.startDate,
    required this.endDate,
    required this.bannerUrl,
    required this.isActive,
  });

  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    return PromotionModel(
      promotionId: json['promotionId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      promoType: json['promoType']?.toString() ?? '',
      startDate: json['startDate']?.toString() ?? '',
      endDate: json['endDate']?.toString() ?? '',
      bannerUrl: json['bannerUrl']?.toString() ?? '',
      isActive: json['isActive'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'promotionId': promotionId,
      'title': title,
      'description': description,
      'promoType': promoType,
      'startDate': startDate,
      'endDate': endDate,
      'bannerUrl': bannerUrl,
      'isActive': isActive,
    };
  }
}
