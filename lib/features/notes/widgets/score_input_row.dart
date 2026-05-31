import 'package:flutter/material.dart';

class ScoreInputRow extends StatelessWidget {
  const ScoreInputRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.maxScore = 10,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  final int maxScore;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label),
        Expanded(
          child: Slider(
            min: 0,
            max: maxScore.toDouble(),
            divisions: maxScore,
            value: value.toDouble(),
            onChanged: (v) => onChanged(v.round()),
          ),
        ),
        Text('$value'),
      ],
    );
  }
}
