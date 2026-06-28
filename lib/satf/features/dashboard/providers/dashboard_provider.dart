import 'package:flutter/foundation.dart';
import '../models/dashboard_summary_model.dart';
import '../models/recent_repair_model.dart';
import '../models/recent_chat_model.dart';
import '../models/recent_build_model.dart';

import '../models/customer_request_model.dart';
import '../services/dashboard_service.dart';
import 'package:computer_shop/admin/models/models.dart';


enum DashboardLoadState { idle, loading, loaded, error }

class DashboardProvider extends ChangeNotifier {
  final DashboardService _service;

  final CustomerRequestStore _requestStore = CustomerRequestStore();

  DashboardProvider({DashboardService? service})
      : _service = service ?? DashboardService() {
    _requestStore.addListener(_onRequestsChanged);
  }


  DashboardLoadState _state = DashboardLoadState.idle;
  String? _errorMessage;

  DashboardSummaryModel? _summary;
  List<RecentRepairModel> _repairs = [];
  List<RecentChatModel> _chats = [];
  List<RecentBuildModel> _builds = [];

  List<FeedbackItem> _feedbacks = [];
  List<PromotionItem> _promotions = [];
  List<CouponModel> _coupons = [];


  // ── Getters ──────────────────────────────────────────────
  DashboardLoadState get state => _state;
  String? get errorMessage => _errorMessage;
  DashboardSummaryModel? get summary => _summary;
  List<RecentRepairModel> get repairs => _repairs;
  List<RecentChatModel> get chats => _chats;
  List<RecentBuildModel> get builds => _builds;

  List<FeedbackItem> get feedbacks => _feedbacks;
  List<PromotionItem> get promotions => _promotions;
  List<CouponModel> get coupons => _coupons;
  bool get isLoading => _state == DashboardLoadState.loading;

  /// Number of customer requests that are still pending
  int get pendingRequestCount =>
      _requestStore.pendingRequests.length;

  /// Combined notification count (chats + customer requests)
  int get totalNotificationCount =>
      _chats.where((c) => !c.isRead).length +
      _requestStore.pendingRequests.length;

  void _onRequestsChanged() {
    notifyListeners();
  }


  // ── Actions ───────────────────────────────────────────────
  Future<void> loadDashboard() async {
    _state = DashboardLoadState.loading;
    _errorMessage = null;

    // Load mock customer requests so staff can see them
    _requestStore.loadMockData();

    notifyListeners();

    try {
      final results = await Future.wait([
        _service.fetchSummary(),
        _service.fetchRecentRepairs(),
        _service.fetchRecentChats(),
        _service.fetchRecentBuilds(),

        _service.fetchRecentFeedbacks(),
        _service.fetchActivePromotions(),
        _service.fetchActiveCoupons(),

      ]);

      _summary = results[0] as DashboardSummaryModel;
      _repairs = results[1] as List<RecentRepairModel>;
      _chats = results[2] as List<RecentChatModel>;
      _builds = results[3] as List<RecentBuildModel>;

      _feedbacks = results[4] as List<FeedbackItem>;
      _promotions = results[5] as List<PromotionItem>;
      _coupons = results[6] as List<CouponModel>;

      _state = DashboardLoadState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _state = DashboardLoadState.error;
    }

    notifyListeners();
  }

  void markChatAsRead(String chatId) {
    _chats = _chats.map((c) {
      if (c.id == chatId) {
        return RecentChatModel(
          id: c.id,
          customerName: c.customerName,
          lastMessage: c.lastMessage,
          timestamp: c.timestamp,
          isRead: true,
          unreadCount: 0,
          avatarInitials: c.avatarInitials,
        );
      }
      return c;
    }).toList();
    notifyListeners();
  }

  void refresh() => loadDashboard();
}