import 'package:flutter_riverpod/flutter_riverpod.dart';

final compareProvider =
    StateNotifierProvider<CompareNotifier, List<String>>(
  (ref) => CompareNotifier(),
);

class CompareNotifier extends StateNotifier<List<String>> {
  CompareNotifier() : super([]);

  void add(String id) {
    if (!state.contains(id)) {
      state = [...state, id];
    }
  }

  void remove(String id) {
    state = state.where((e) => e != id).toList();
  }

  void clear() {
    state = [];
  }

  void toggle(String id) {
    if (state.contains(id)) {
      remove(id);
    } else {
      add(id);
    }
  }
}