class ScoreEntry {
  final String activity;
  final Map<String, int> scores; // e.g., {'T1': 1, 'T2': 0}
  final String? remarks;

  ScoreEntry({
    required this.activity,
    required this.scores,
    this.remarks,
  });

  Map<String, dynamic> toJson() => {
        'activity': activity,
        'scores': scores,
        'remarks': remarks,
      };
} 