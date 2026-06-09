// lib/features/cart/data/cart_repository_sqlite.dart

import 'package:sqflite/sqlite_api.dart';
import '../../../core/repositories/base_repository.dart';
import '../domain/cart_model.dart';

class CartRepositorySQLite extends BaseRepository {
  static const String _cartTable = 'cart_items';

  Future<List<CartItem>> getCartItems({String? userId}) async {
    final db = await database;
    
    final results = await db.query(
      _cartTable,
      where: userId != null ? 'user_id = ?' : null,
      whereArgs: userId != null ? [userId] : null,
      orderBy: 'added_at DESC',
    );
    
    return results.map((row) => CartItem.fromDbJson(row)).toList();
  }

  Future<void> addToCart(CartItem item, {String? userId}) async {
    final db = await database;
    
    // Check if item already exists
    final existing = await db.query(
      _cartTable,
      where: 'user_id = ? AND product_id = ? AND build_id IS ?',
      whereArgs: [userId ?? 'current_user', item.productId, item.buildId],
    );
    
    if (existing.isNotEmpty) {
      // Update quantity
      final currentQty = existing.first['quantity'] as int;
      await db.update(
        _cartTable,
        {'quantity': currentQty + item.quantity},
        where: 'cart_item_id = ?',
        whereArgs: [existing.first['cart_item_id']],
      );
    } else {
      // Insert new
      await db.insert(
        _cartTable,
        {
          ...item.toDbJson(),
          'user_id': userId ?? 'current_user',
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    
    await addToSyncQueue(
      operation: 'INSERT',
      tableName: _cartTable,
      data: item.toDbJson(),
    );
  }

  Future<void> updateQuantity(String cartItemId, int quantity) async {
    final db = await database;
    
    if (quantity <= 0) {
      await removeFromCart(cartItemId);
    } else {
      await db.update(
        _cartTable,
        {'quantity': quantity},
        where: 'cart_item_id = ?',
        whereArgs: [cartItemId],
      );
    }
  }

  Future<void> removeFromCart(String cartItemId) async {
    final db = await database;
    await db.delete(_cartTable, where: 'cart_item_id = ?', whereArgs: [cartItemId]);
  }

  Future<void> clearCart() async {
    final db = await database;
    await db.delete(_cartTable);
  }

  Future<double> getCartTotal() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(price * quantity) as total FROM $_cartTable',
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<int> getCartItemCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT SUM(quantity) as count FROM $_cartTable');
    return (result.first['count'] as int?) ?? 0;
  }
}
