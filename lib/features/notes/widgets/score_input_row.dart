import 'package:flutter/material.dart';

class ScoreInputRow extends StatelessWidget {
  const ScoreInputRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.color,
    this.maxScore = 10,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  final Color color;
  final int maxScore;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: cs.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '$value',
                style: TextStyle(
                  color: color,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 7,
              activeTrackColor: color,
              inactiveTrackColor: cs.outlineVariant,
              thumbColor: Colors.white,
              overlayColor: color.withAlpha(50),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
            ),
            child: SizedBox(
              height: 32,
              child: Slider(
                min: 0,
                max: maxScore.toDouble(),
                divisions: maxScore,
                value: value.toDouble(),
                onChanged: (v) => onChanged(v.round()),
                semanticFormatterCallback: (v) => v.round().toString(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
