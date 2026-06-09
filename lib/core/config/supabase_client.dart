// lib/core/supabase/supabase_client.dart

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClientService {
  static final SupabaseClientService _instance = SupabaseClientService._internal();
  late final SupabaseClient _client;

  SupabaseClientService._internal();

  factory SupabaseClientService() {
    return _instance;
  }

  Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
    
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
      debug: true,
    );
    
    _client = Supabase.instance.client;
    print('✅ Supabase initialized');
  }

  SupabaseClient get client => _client;
  
  // Helper getters
  GoTrueClient get auth => _client.auth;
  
  dynamic from(String table) {
    return _client.from(table);
  }
}