import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../../l10n/app_localizations.dart';

class ScoreLineChart extends StatelessWidget {
  const ScoreLineChart({
    super.key,
    required this.title,
    required this.spots,
    required this.dates,
    required this.color,
    required this.maxY,
    this.locale = 'en',
  });

  final String title;
  final List<FlSpot> spots;
  final List<DateTime> dates;
  final Color color;
  final double maxY;
  final String locale;

  double get _avg =>
      spots.isEmpty ? 0.0 : spots.fold(0.0, (s, sp) => s + sp.y) / spots.length;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: TextStyle(
                        color: cs.onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _avg.toStringAsFixed(1),
                      style: TextStyle(
                        color: color,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.graphAvgScore,
                      style: TextStyle(
                        color: cs.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: spots.isEmpty
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: LineChart(_buildChartData(cs)),
                  ),
          ),
        ],
      ),
    );
  }

  LineChartData _buildChartData(ColorScheme cs) {
    const dayMs = 86400000.0;
    // x values are 0, dayMs, 2*dayMs, ... so ticks align exactly with spots
    final minX = 0.0;
    final maxX = (spots.length - 1) * dayMs;
    // Show at most ~5 labels
    final labelEvery = max(1, (spots.length / 5).ceil());

    return LineChartData(
      minY: 0,
      maxY: maxY,
      minX: minX,
      maxX: maxX,
      clipData: const FlClipData.all(),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: maxY / 5,
        getDrawingHorizontalLine: (_) => FlLine(
          color: cs.outlineVariant,
          strokeWidth: 0.5,
        ),
      ),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: dayMs,
            getTitlesWidget: (value, meta) {
              final index = (value / dayMs).round();
              if (index < 0 || index >= dates.length) return const SizedBox.shrink();
              if (index % labelEvery != 0) return const SizedBox.shrink();
              final dt = dates[index];
              final String label;
              if (locale == 'fa') {
                final j = Jalali.fromDateTime(dt);
                label = '${j.day} ${j.formatter.mN}';
              } else {
                label = DateFormat('MMM d', 'en').format(dt);
              }
              return Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  label,
                  style: TextStyle(
                    color: cs.onSurfaceVariant,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          curveSmoothness: 0.25,
          color: color,
          barWidth: 2.5,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
              radius: 3.5,
              color: Colors.transparent,
              strokeWidth: 2,
              strokeColor: color,
            ),
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                color.withAlpha(90),
                color.withAlpha(0),
              ],
            ),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (spot) => cs.surfaceContainerHigh,
          getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
            final index = (spot.x / dayMs).round().clamp(0, dates.length - 1);
            final dt = dates[index];
            final String dateLabel;
            if (locale == 'fa') {
              final j = Jalali.fromDateTime(dt);
              dateLabel = '${j.day} ${j.formatter.mN}';
            } else {
              dateLabel = DateFormat('MMM d').format(dt);
            }
            return LineTooltipItem(
              '$dateLabel\n${spot.y.toStringAsFixed(1)}',
              TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
