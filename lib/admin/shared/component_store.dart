

import 'package:computer_shop/admin/models/models.dart';

class ComponentStore {
  static final List<ComponentItem> items =
      List<ComponentItem>.from(ComponentData.items);

  static void add(ComponentItem item) {
    items.insert(0, item);
  }

  static void update(ComponentItem item) {
    final index = items.indexWhere((e) => e.id == item.id);

    if (index != -1) {
      items[index] = item;
    }
  }

  static void delete(String id) {
    items.removeWhere((e) => e.id == id);
  }
}