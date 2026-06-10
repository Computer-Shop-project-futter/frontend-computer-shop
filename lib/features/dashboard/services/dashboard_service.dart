import '../models/dashboard_summary_model.dart';
import '../models/recent_repair_model.dart';
import '../models/recent_chat_model.dart';
import '../models/recent_build_model.dart';

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
}