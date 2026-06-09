import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service to manage Supabase client initialization and access
class SupabaseClientService {
  static final SupabaseClientService _instance = SupabaseClientService._internal();

  factory SupabaseClientService() {
    return _instance;
  }

  SupabaseClientService._internal();

  late SupabaseClient _client;

  /// Initialize Supabase client
  Future<void> initialize() async {
    await dotenv.load(fileName: '.env');

    final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? dotenv.env['NEXT_PUBLIC_SUPABASE_URL'] ?? '';
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? dotenv.env['NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY'] ?? '';

    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      throw Exception(
        'SUPABASE_URL / NEXT_PUBLIC_SUPABASE_URL and SUPABASE_ANON_KEY / NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY must be set in .env file',
      );
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
    return _client;
  }

  /// Get the auth client
  GoTrueClient get auth {
    return _client.auth;
  }

  /// Get a database table reference
  PostgrestFilterBuilder from(String tableName) {
    return _client.from(tableName).select();
  }
}
