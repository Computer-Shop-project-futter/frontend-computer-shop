import 'package:flutter/foundation.dart';

/// Represents a customer request initiated from the client side.
enum RequestType { build, repair }

enum RequestStatus { pending, inProgress, completed }

class CustomerRequest {
  final String id;
  final String customerName;
  final RequestType type;
  final String description;
  final RequestStatus status;
  final DateTime createdAt;

  const CustomerRequest({
    required this.id,
    required this.customerName,
    required this.type,
    required this.description,
    this.status = RequestStatus.pending,
    required this.createdAt,
  });

  CustomerRequest copyWith({RequestStatus? status}) {
    return CustomerRequest(
      id: id,
      customerName: customerName,
      type: type,
      description: description,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }
}

/// In-memory shared store for customer requests.
/// Both client and staff pages can read/write to this store.
class CustomerRequestStore extends ChangeNotifier {
  static final CustomerRequestStore _instance = CustomerRequestStore._();
  factory CustomerRequestStore() => _instance;
  CustomerRequestStore._();

  final List<CustomerRequest> _requests = [];

  List<CustomerRequest> get requests => List.unmodifiable(_requests);

  List<CustomerRequest> get pendingRequests =>
      _requests.where((r) => r.status == RequestStatus.pending).toList();

  List<CustomerRequest> get buildRequests =>
      _requests.where((r) => r.type == RequestType.build).toList();

  List<CustomerRequest> get repairRequests =>
      _requests.where((r) => r.type == RequestType.repair).toList();

  void addRequest(CustomerRequest request) {
    _requests.insert(0, request);
    notifyListeners();
  }

  void updateStatus(String id, RequestStatus status) {
    final index = _requests.indexWhere((r) => r.id == id);
    if (index != -1) {
      _requests[index] = _requests[index].copyWith(status: status);
      notifyListeners();
    }
  }

  // Mock data for demo
  void loadMockData() {
    if (_requests.isNotEmpty) return;
    final now = DateTime.now();
    _requests.addAll([
      CustomerRequest(
        id: 'REQ-001',
        customerName: 'Julianne Smith',
        type: RequestType.build,
        description: 'Gaming PC - RTX 4070 + Ryzen 7',
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      CustomerRequest(
        id: 'REQ-002',
        customerName: 'Marcus Wright',
        type: RequestType.repair,
        description: 'Laptop screen replacement - NexCore Pro X1',
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
      CustomerRequest(
        id: 'REQ-003',
        customerName: 'Elena Belova',
        type: RequestType.build,
        description: 'Workstation for video editing',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      CustomerRequest(
        id: 'REQ-004',
        customerName: 'David Kim',
        type: RequestType.repair,
        description: 'Battery swelling issue - NexCore Tab Z',
        createdAt: now.subtract(const Duration(days: 2)),
      ),
    ]);
    notifyListeners();
  }
}