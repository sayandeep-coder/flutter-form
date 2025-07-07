import 'package:flutter/material.dart';

class ScoreInput extends StatelessWidget {
  final String activity;
  final List<String> subItems; // e.g., ['T1', 'T2', 'T3', 'T4']
  final Map<String, int> scores;
  final ValueChanged<Map<String, int>> onChanged;
  final String? remarks;
  final ValueChanged<String>? onRemarksChanged;

  const ScoreInput({
    super.key,
    required this.activity,
    required this.subItems,
    required this.scores,
    required this.onChanged,
    this.remarks,
    this.onRemarksChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(activity, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...subItems.map((item) => Row(
                  children: [
                    Text(item),
                    const SizedBox(width: 8),
                    DropdownButton<int>(
                      value: scores[item] ?? 0,
                      items: List.generate(11, (i) => DropdownMenuItem(value: i, child: Text(i.toString()))),
                      onChanged: (val) {
                        if (val != null) {
                          final newScores = Map<String, int>.from(scores);
                          newScores[item] = val;
                          onChanged(newScores);
                        }
                      },
                    ),
                  ],
                )),
            if (onRemarksChanged != null) ...[
              const SizedBox(height: 8),
              TextField(
                decoration: const InputDecoration(labelText: 'Remarks (optional)'),
                onChanged: onRemarksChanged,
                controller: TextEditingController(text: remarks),
              ),
            ],
          ],
        ),
      ),
    );
  }
} 