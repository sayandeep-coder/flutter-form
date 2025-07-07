import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/score_entry.dart';

final scoreProvider = StateNotifierProvider<ScoreNotifier, List<ScoreEntry>>((ref) => ScoreNotifier());

class ScoreNotifier extends StateNotifier<List<ScoreEntry>> {
  ScoreNotifier() : super([]);

  void addEntry(ScoreEntry entry) {
    state = [...state, entry];
  }

  void updateEntry(int index, ScoreEntry entry) {
    final newList = [...state];
    newList[index] = entry;
    state = newList;
  }

  void removeEntry(int index) {
    final newList = [...state]..removeAt(index);
    state = newList;
  }

  void clear() {
    state = [];
  }
} 