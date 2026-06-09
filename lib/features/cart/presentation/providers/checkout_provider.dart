// lib/features/checkout/presentation/providers/checkout_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/cart_repository.dart';
import '../../domain/checkout_model.dart';

final checkoutRepositoryProvider = Provider<CheckoutRepository>((ref) {
  return CheckoutRepository();
});

final checkoutProvider = StateNotifierProvider<CheckoutNotifier, CheckoutState>((ref) {
  return CheckoutNotifier(ref.read(checkoutRepositoryProvider));
});

class CheckoutNotifier extends StateNotifier<CheckoutState> {
  final CheckoutRepository _repository;

  CheckoutNotifier(this._repository) : super(_getInitialState());

  static CheckoutState _getInitialState() {
    return CheckoutState(
      items: [
        OrderItem(
          id: '1',
          name: 'Apex Core V1',
          type: 'PRODUCT',
          variant: 'Size 10.5 — Phantom Black',
          quantity: 1,
          price: 240.00,
        ),
      ],
      fullName: 'Alex Rivers',
      email: 'alex.rivers@example.com',
      phone: '+1 (555) 0123',
      selectedShipping: ShippingMethod.standard,
    );
  }

  void updateFullName(String name) {
    state = state.copyWith(fullName: name);
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePhone(String phone) {
    state = state.copyWith(phone: phone);
  }

  void selectShipping(ShippingMethod method) {
    state = state.copyWith(selectedShipping: method);
  }

  void selectPayment(PaymentMethod method) {
    state = state.copyWith(selectedPayment: method);
  }

  Future<void> applyCoupon(String couponCode) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.applyCoupon(couponCode);
      
      // Calculate discount (20% for NEXLAUNCH20)
      double discount = 0;
      if (couponCode.toUpperCase() == 'NEXLAUNCH20') {
        discount = state.subtotal * 0.20;
      }
      
      state = state.copyWith(
        couponCode: couponCode,
        discountAmount: discount,
        isLoading: false,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        error: error.toString(),
      );
    }
  }

  Future<void> processOrder() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.processOrder(state);
      state = state.copyWith(isLoading: false);
      // Order successful - navigate to success page
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        error: error.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void addItem(OrderItem item) {
    state = state.copyWith(items: [...state.items, item]);
  }
}