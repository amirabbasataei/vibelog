import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ScoreLineChart extends StatelessWidget {
  const ScoreLineChart({
    super.key,
    required this.title,
    required this.spots,
    required this.color,
    required this.maxY,
  });

  final String title;
  final List<FlSpot> spots;
  final Color color;
  final double maxY;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(title));
  }
}
