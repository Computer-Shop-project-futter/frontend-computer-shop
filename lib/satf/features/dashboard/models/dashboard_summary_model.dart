class DashboardSummaryModel {
  final int totalRepairs;
  final int pendingRepairs;
  final int activeChats;
  final int totalBuilds;
  final int totalCustomers;

  const DashboardSummaryModel({
    required this.totalRepairs,
    required this.pendingRepairs,
    required this.activeChats,
    required this.totalBuilds,
    required this.totalCustomers,
  });

  // Static mock data — swap with API call later
  factory DashboardSummaryModel.mock() {
    return const DashboardSummaryModel(
      totalRepairs: 24,
      pendingRepairs: 8,
      activeChats: 5,
      totalBuilds: 3,
      totalCustomers: 142,
    );
  }

  DashboardSummaryModel copyWith({
    int? totalRepairs,
    int? pendingRepairs,
    int? activeChats,
    int? totalBuilds,
    int? totalCustomers,
  }) {
    return DashboardSummaryModel(
      totalRepairs: totalRepairs ?? this.totalRepairs,
      pendingRepairs: pendingRepairs ?? this.pendingRepairs,
      activeChats: activeChats ?? this.activeChats,
      totalBuilds: totalBuilds ?? this.totalBuilds,
      totalCustomers: totalCustomers ?? this.totalCustomers,
    );
  }
}