enum RepairStatus { inProgress, pending, completed, waitingParts, ready }

extension RepairStatusLabel on RepairStatus {
  String get label {
    switch (this) {
      case RepairStatus.inProgress:
        return 'In Progress';
      case RepairStatus.pending:
        return 'Pending';
      case RepairStatus.completed:
        return 'Completed';
      case RepairStatus.waitingParts:
        return 'Waiting Parts';
      case RepairStatus.ready:
        return 'Ready';
    }
  }
}

class RecentRepairModel {
  final String id;
  final String title;
  final String customerName;
  final String device;
  final RepairStatus status;
  final DateTime date;

  const RecentRepairModel({
    required this.id,
    required this.title,
    required this.customerName,
    required this.device,
    required this.status,
    required this.date,
  });

  // Static mock list — replace with API data later
  static List<RecentRepairModel> mockList() {
    return [
      RecentRepairModel(
        id: 'RP-1001',
        title: 'GPU Fan Repair',
        customerName: 'Alex Rivers',
        device: 'NexCore Pro X1',
        status: RepairStatus.inProgress,
        date: DateTime(2023, 10, 24),
      ),
      RecentRepairModel(
        id: 'RP-1002',
        title: 'Screen Replacement',
        customerName: 'Sarah Chen',
        device: 'NexCore Tab Z',
        status: RepairStatus.waitingParts,
        date: DateTime(2023, 10, 22),
      ),
      RecentRepairModel(
        id: 'RP-1003',
        title: 'Battery Swap',
        customerName: 'Elena Rossi',
        device: 'NexCore Pro X1',
        status: RepairStatus.ready,
        date: DateTime(2023, 10, 23),
      ),
      RecentRepairModel(
        id: 'RP-1004',
        title: 'Maintenance Service',
        customerName: 'Marcus Vane',
        device: 'NexCore Hub Lite',
        status: RepairStatus.pending,
        date: DateTime(2023, 10, 15),
      ),
    ];
  }
}