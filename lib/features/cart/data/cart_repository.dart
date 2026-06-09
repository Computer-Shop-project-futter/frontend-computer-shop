// lib/features/checkout/data/checkout_repository.dart

import '../domain/checkout_model.dart';

class CheckoutRepository {
  Future<void> applyCoupon(String couponCode) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mock coupon validation
    if (couponCode.toUpperCase() == 'NEXLAUNCH20') {
      // Valid coupon
      return;
    } else {
      throw Exception('Invalid coupon code');
    }
  }

  Future<void> processOrder(CheckoutState checkout) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    
    // Mock order processing
    // In real app, this would send to backend
    
    if (checkout.fullName.isEmpty || checkout.email.isEmpty || checkout.phone.isEmpty) {
      throw Exception('Please fill in all required fields');
    }
    
    if (checkout.selectedPayment == null) {
      throw Exception('Please select a payment method');
    }
    
    // Success - order processed
    return;
  }
}