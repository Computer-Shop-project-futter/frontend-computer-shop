class RecentBuildModel {
  final String id;
  final String title;
  final String specs;
  final String gpu;
  final String cpu;
  final double estimatedPrice;
  final DateTime createdAt;

  const RecentBuildModel({
    required this.id,
    required this.title,
    required this.specs,
    required this.gpu,
    required this.cpu,
    required this.estimatedPrice,
    required this.createdAt,
  });

  // Static mock list — replace with API data later
  static List<RecentBuildModel> mockList() {
    return [
      RecentBuildModel(
        id: 'BLD-001',
        title: 'Gaming PC Build',
        specs: 'RTX 4070 + Ryzen 7',
        gpu: 'RTX 4070',
        cpu: 'Ryzen 7 5800X',
        estimatedPrice: 1850.00,
        createdAt: DateTime(2023, 10, 24),
      ),
      RecentBuildModel(
        id: 'BLD-002',
        title: 'Workstation Build',
        specs: 'RTX 4090 + i9-13900K',
        gpu: 'RTX 4090',
        cpu: 'Intel i9-13900K',
        estimatedPrice: 4200.00,
        createdAt: DateTime(2023, 10, 23),
      ),
      RecentBuildModel(
        id: 'BLD-003',
        title: 'Budget Gaming Rig',
        specs: 'RX 6600 + Ryzen 5',
        gpu: 'RX 6600',
        cpu: 'Ryzen 5 5600X',
        estimatedPrice: 950.00,
        createdAt: DateTime(2023, 10, 22),
      ),
    ];
  }
}