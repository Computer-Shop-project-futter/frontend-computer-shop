// lib/core/services/connectivity_service.dart

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityProvider = StreamProvider<ConnectivityResult>((ref) {
  return ConnectivityService().connectivityStream;
});

final isOnlineProvider = Provider<bool>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  return connectivity.when(
    data: (result) => result != ConnectivityResult.none,
    loading: () => true, // Assume online while loading
    error: (_, __) => true,
  );
});

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  final Connectivity _connectivity = Connectivity();
  final StreamController<ConnectivityResult> _controller = 
      StreamController<ConnectivityResult>.broadcast();

  ConnectivityService._internal() {
    _init();
  }

  factory ConnectivityService() => _instance;

  Future<void> _init() async {
    // Get initial connectivity
    final result = await _connectivity.checkConnectivity();
    _controller.add(result);
    
    // Listen to changes
    _connectivity.onConnectivityChanged.listen((results) {
      _controller.add(results);
    });
  }

  Stream<ConnectivityResult> get connectivityStream => _controller.stream;

  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  void dispose() {
    _controller.close();
  }
}