import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service to manage Supabase client initialization and access
class SupabaseClientService {
  static final SupabaseClientService _instance = SupabaseClientService._internal();

  factory SupabaseClientService() {
    return _instance;
  }

  SupabaseClientService._internal();

  SupabaseClient? _client;

  /// Initialize Supabase client
  Future<void> initialize() async {
    await dotenv.load(fileName: 'assets/.env');

    final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? dotenv.env['NEXT_PUBLIC_SUPABASE_URL'] ?? '';
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? dotenv.env['NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY'] ?? '';

    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      throw Exception(
        'SUPABASE_URL / NEXT_PUBLIC_SUPABASE_URL and SUPABASE_ANON_KEY / NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY must be set in .env file',
      );
    }

    // Debug: show masked env values to help diagnose missing/incorrect keys
    try {
      final maskedKey = supabaseAnonKey.length > 8
          ? '${supabaseAnonKey.substring(0, 8)}...${supabaseAnonKey.substring(supabaseAnonKey.length - 4)}'
          : supabaseAnonKey;
      print('Supabase URL: $supabaseUrl');
      print('Supabase Key (masked): $maskedKey');
    } catch (e) {
      print('Error masking Supabase key: $e');
    }

    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: supabaseAnonKey,
      debug: true,
    );

    _client = Supabase.instance.client;
  }

  /// Get the Supabase client
  SupabaseClient get client {
    return _client ?? Supabase.instance.client;
  }

  /// Get the auth client
  GoTrueClient get auth {
    return client.auth;
  }

  /// Get a database table reference
  PostgrestFilterBuilder from(String tableName) {
    return client.from(tableName).select();
  }
}
