import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

LineChartData buildDifferentialPaymentChart(
    {required List<double> differentiatedPayments}) {
  final List<String> months = List.generate(
    differentiatedPayments.length,
    (index) => '${index + 1}',
  );

  final double maxPayment = differentiatedPayments.isNotEmpty
      ? differentiatedPayments.reduce(max)
      : 0.0;

  return LineChartData(
    gridData: const FlGridData(
      show: true,
    ),
    titlesData: FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          interval: differentiatedPayments.isNotEmpty
              ? differentiatedPayments.reduce(max) / 5
              : 1000,
          showTitles: true,
          reservedSize: 50,
          getTitlesWidget: (value, meta) => Text('${value.toInt()}'),
        ),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(
            getTitlesWidget: (value, meta) => Container(
                  color: Colors.transparent,
                ),
            showTitles: true),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(
            getTitlesWidget: (value, meta) => Container(
                  color: Colors.transparent,
                ),
            showTitles: true),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTitlesWidget: (value, meta) {
            final int index = value.toInt();
            if (index >= 0 && index < months.length) {
              return Text(months[index]);
            }
            return Container();
          },
        ),
      ),
    ),
    lineTouchData: LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        tooltipBgColor: Colors.blue.withOpacity(0.9),
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((LineBarSpot spot) {
            return LineTooltipItem(
              '\$${spot.y.toInt()}',
              const TextStyle(color: Colors.white),
            );
          }).toList();
        },
      ),
    ),
    borderData: FlBorderData(show: false),
    minX: 0,
    maxX: differentiatedPayments.length.toDouble() - 1,
    minY: 0,
    maxY: maxPayment * 1.2,
    lineBarsData: [
      LineChartBarData(
        spots: differentiatedPayments.asMap().entries.map((entry) {
          return FlSpot(entry.key.toDouble(), entry.value);
        }).toList(),
        isCurved: true,
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(show: true),
        color: Colors.blue,
      ),
    ],
  );
}
