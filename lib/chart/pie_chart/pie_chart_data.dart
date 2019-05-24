import 'dart:ui';

import 'package:fl_chart/chart/base/fl_chart/fl_chart_data.dart';
import 'package:flutter/material.dart';

class PieChartData extends FlChartData {
  final List<PieChartSectionData> sections;
  final double centerSpaceRadius;
  final Color centerSpaceColor;
  final double sectionsSpace;
  final double startDegreeOffset;
  double sumValue;

  PieChartData({
    this.sections = const [],
    this.centerSpaceRadius = 80,
    this.centerSpaceColor = Colors.transparent,
    this.sectionsSpace = 2,
    this.startDegreeOffset = 0,
    FlBorderData borderData = const FlBorderData(),
  }) : super(
    borderData: borderData,
  ) {
    sumValue = sections
      .map((data) => data.value)
      .reduce((first, second) => first + second);
  }

}

// PieChartSectionData
class PieChartSectionData {
  final double value;
  final Color color;
  final double widthRadius;
  final bool showTitle;
  final TextStyle textStyle;
  final String title;
  final double titlePositionPercentageOffset;

  PieChartSectionData({
    this.value = 10,
    this.color = Colors.red,
    this.widthRadius = 40,
    this.showTitle = true,
    this.textStyle = const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
    this.title = "1",
    this.titlePositionPercentageOffset = 0.5,
  });

}