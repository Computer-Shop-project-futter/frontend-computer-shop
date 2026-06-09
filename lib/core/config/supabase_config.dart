import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'Computer Shop';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJkb3Rxa2pubHJsa3RseWZ4cWd5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODA4ODk4MDYsImV4cCI6MjA5NjQ2NTgwNn0.VBaxVfS5UDN1mQ6nS6onKnCmSED7GILTYeD9kzNPtOM';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}