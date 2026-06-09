// lib/features/account/data/account_repository.dart

import '../domain/account_model.dart';

class AccountRepository {
  Future<UserProfile> getUserProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return UserProfile(
      userId: 'user_123',
      fullName: 'Alex Rivers',
      email: 'alex.rivers@example.com',
      phone: '+1 (555) 012-3456',
      avatarUrl: null,
      joinDate: DateTime(2023, 1, 15),
    );
  }

  Future<UserProfile> updateUserProfile({
    required String fullName,
    required String email,
    required String phone,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    return UserProfile(
      userId: 'user_123',
      fullName: fullName,
      email: email,
      phone: phone,
      avatarUrl: null,
      joinDate: DateTime(2023, 1, 15),
    );
  }

  Future<List<Order>> getRecentOrders() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      Order(
        id: '1',
        orderNumber: 'G14-12345',
        date: DateTime(2024, 1, 15),
        total: 2899.00,
        status: OrderStatus.delivered,
        items: const [
          OrderItem(id: '1', name: 'Apex-Ultimate Gaming Rig', quantity: 1, price: 2899.00),
        ],
      ),
      Order(
        id: '2',
        orderNumber: 'G14-12346',
        date: DateTime(2024, 1, 20),
        total: 799.00,
        status: OrderStatus.shipped,
        items: const [
          OrderItem(id: '3', name: 'VisionX 32" Ultra Display', quantity: 1, price: 799.00),
        ],
      ),
      Order(
        id: '3',
        orderNumber: 'G14-12347',
        date: DateTime(2024, 1, 25),
        total: 349.00,
        status: OrderStatus.processing,
        items: const [
          OrderItem(id: '4', name: 'Pulse Mechanical Keyboard', quantity: 2, price: 174.50),
        ],
      ),
    ];
  }

  Future<List<Address>> getAddresses() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      const Address(
        id: 'addr_1',
        fullName: 'Alex Rivers',
        street: '123 Main Street',
        city: 'Los Angeles',
        state: 'CA',
        zipCode: '90001',
        country: 'United States',
        phone: '+1 (555) 012-3456',
        isDefault: true,
      ),
      const Address(
        id: 'addr_2',
        fullName: 'Alex Rivers',
        street: '456 Work Ave',
        city: 'San Francisco',
        state: 'CA',
        zipCode: '94105',
        country: 'United States',
        phone: '+1 (555) 012-3456',
        isDefault: false,
      ),
    ];
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}