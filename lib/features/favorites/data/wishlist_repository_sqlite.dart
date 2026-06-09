// lib/features/wishlist/data/wishlist_repository_sqlite.dart

import 'package:sqflite/sqflite.dart';
import '../../../core/repositories/base_repository.dart';
import '../domain/wishlist_model.dart';

class WishlistRepositorySQLite extends BaseRepository {
  static const String _wishlistTable = 'wishlist_items';

  Future<List<WishlistItem>> getWishlistItems({String? userId}) async {
    final db = await database;
    
    final results = await db.query(
      _wishlistTable,
      where: userId != null ? 'user_id = ?' : null,
      whereArgs: userId != null ? [userId] : null,
      orderBy: 'added_at DESC',
    );
    
    return results.map((row) => WishlistItem.fromDbJson(row)).toList();
  }

  Future<void> addToWishlist(WishlistItem item, {String? userId}) async {
    final db = await database;
    
    await db.insert(
      _wishlistTable,
      {
        ...item.toDbJson(),
        'user_id': userId ?? 'current_user',
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
    // Add to sync queue for offline support
    await addToSyncQueue(
      operation: 'INSERT',
      tableName: _wishlistTable,
      data: item.toDbJson(),
    );
  }

  Future<void> removeFromWishlist(String itemId) async {
    final db = await database;
    
    await db.delete(
      _wishlistTable,
      where: 'item_id = ?',
      whereArgs: [itemId],
    );
    
    await addToSyncQueue(
      operation: 'DELETE',
      tableName: _wishlistTable,
      data: {'item_id': itemId},
    );
  }

  Future<void> clearWishlist() async {
    final db = await database;
    await db.delete(_wishlistTable);
  }

  Future<bool> isInWishlist(String itemId) async {
    final db = await database;
    final result = await db.query(
      _wishlistTable,
      where: 'item_id = ?',
      whereArgs: [itemId],
    );
    return result.isNotEmpty;
  }

  Future<int> getWishlistCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM $_wishlistTable');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}