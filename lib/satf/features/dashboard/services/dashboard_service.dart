import '../models/dashboard_summary_model.dart';
import '../models/recent_repair_model.dart';
import '../models/recent_chat_model.dart';
import '../models/recent_build_model.dart';
<<<<<<< HEAD
=======
import 'package:computer_shop/admin/models/models.dart';
>>>>>>> 4bf4199 (update code in client and admin)

/// DashboardService — currently returns static mock data.
/// Replace each method body with real API calls when backend is ready.
class DashboardService {
  // Simulate network latency for realistic UX testing
  static const _fakeDelay = Duration(milliseconds: 600);

  Future<DashboardSummaryModel> fetchSummary() async {
    await Future.delayed(_fakeDelay);
    // TODO: Replace with: final res = await http.get(Uri.parse('$baseUrl/dashboard/summary'));
    return DashboardSummaryModel.mock();
  }

  Future<List<RecentRepairModel>> fetchRecentRepairs({int limit = 4}) async {
    await Future.delayed(_fakeDelay);
    // TODO: Replace with: final res = await http.get(Uri.parse('$baseUrl/repairs?limit=$limit'));
    return RecentRepairModel.mockList().take(limit).toList();
  }

  Future<List<RecentChatModel>> fetchRecentChats({int limit = 5}) async {
    await Future.delayed(_fakeDelay);
    // TODO: Replace with: final res = await http.get(Uri.parse('$baseUrl/chats?limit=$limit'));
    return RecentChatModel.mockList().take(limit).toList();
  }

  Future<List<RecentBuildModel>> fetchRecentBuilds({int limit = 3}) async {
    await Future.delayed(_fakeDelay);
    // TODO: Replace with: final res = await http.get(Uri.parse('$baseUrl/builds?limit=$limit'));
    return RecentBuildModel.mockList().take(limit).toList();
  }
<<<<<<< HEAD
=======

  Future<List<FeedbackItem>> fetchRecentFeedbacks({int limit = 4}) async {
    await Future.delayed(_fakeDelay);
    return FeedbackData.seed.take(limit).toList();
  }

  Future<List<PromotionItem>> fetchActivePromotions({int limit = 3}) async {
    await Future.delayed(_fakeDelay);
    return PromotionData.seed.where((p) => p.isActive).take(limit).toList();
  }

  Future<List<CouponModel>> fetchActiveCoupons({int limit = 3}) async {
    await Future.delayed(_fakeDelay);
    final now = DateTime.now();
    return List.generate(limit, (i) {
      final active = i % 2 == 0;
      return CouponModel(
        id: 'cpn-$i',
        code: 'STAFF${2025 + i}',
        description: 'Staff promo coupon #${i + 1}',
        discountType: i % 2 == 0 ? DiscountType.percentage : DiscountType.fixed,
        discountValue: i % 2 == 0 ? 15 : 10,
        startDate: now.subtract(Duration(days: i * 3)),
        endDate: now.add(Duration(days: 20 - i * 2)),
        isActive: active,
      );
    });
  }
>>>>>>> 4bf4199 (update code in client and admin)
}