import 'dart:ui';

import 'package:flutter/material.dart';

class LineChartData {
  final List<LineChartSpot> spots;
  final Color barColor;
  final double barWidth;
  final Color dotColor;
  final double dotSize;
  final bool showDots;
  final bool isCurved;
  final double curveSmoothness;
  final bool showGridLines;
  final LineChartGridData gridData;
  final bool showTitles;
  final LineChartTitlesData titlesData;

  double minX, maxX;
  double minY, maxY;

  LineChartData({
    @required this.spots,
    this.barColor = Colors.redAccent,
    this.barWidth = 2.0,
    this.dotColor = Colors.blue,
    this.dotSize = 4.0,
    this.showDots = true,
    this.isCurved = false,
    this.curveSmoothness = 0.35,
    this.showGridLines = true,
    this.gridData = const LineChartGridData(),
    this.showTitles = true,
    this.titlesData = const LineChartTitlesData(),
  }) {
    if (spots == null) {
      throw Exception("spots couldn't be null");
    }

    if (spots.length >= 0) {
      minX = maxX = spots[0].x;
      minY = maxY = spots[0].y;
      spots.forEach((spot) {
        if (spot.x > maxX) {
          maxX = spot.x;
        } else if (spot.x < minX) {
          minX = spot.x;
        }

        if (spot.y > maxY) {
          maxY = spot.y;
        } else if (spot.y < minY) {
          minY = spot.y;
        }

        print("minX: $minX, maxX: $maxX, minY: $minY, maxY: $maxY, ");
      });
    }
  }
}

class LineChartSpot {
  final double x;
  final double y;

  LineChartSpot(this.x, this.y);
}


typedef BooleanCheckByValue = bool Function(double value);

bool showAllGrids(double value) {
  return true;
}

// Grid data
class LineChartGridData {
  // Horizontal
  final bool drawHorizontalGrid;
  final double horizontalInterval;
  final Color horizontalGridColor;
  final double horizontalGridLineWidth;
  final BooleanCheckByValue showHorizontalGridWithValue;

  // Vertical
  final bool drawVerticalGrid;
  final double verticalInterval;
  final Color verticalGridColor;
  final double verticalGridLineWidth;
  final BooleanCheckByValue showVerticalGridWithValue;

  const LineChartGridData({
    // Horizontal
    this.drawHorizontalGrid = false,
    this.horizontalInterval = 1.0,
    this.horizontalGridColor = Colors.grey,
    this.horizontalGridLineWidth = 0.5,
    this.showHorizontalGridWithValue = showAllGrids,

    //Vertical
    this.drawVerticalGrid = true,
    this.verticalInterval = 1.0,
    this.verticalGridColor = Colors.grey,
    this.verticalGridLineWidth = 0.5,
    this.showVerticalGridWithValue = showAllGrids,
  });
}

// Titles data
typedef GetTitleFunction = String Function(double value);
String defaultGetTitle(double value) {
  return "${value.toInt()}";
}

enum TitleAlignment {
  LEFT, RIGHT, TOP, BOTTOM,
}

class LineChartTitlesData {
  // Horizontal
  final TitleAlignment horizontalTitlesAlignment;
  final GetTitleFunction getHorizontalTitle;
  final double horizontalTitlesReservedHeight;
  final TextStyle horizontalTitlesTextStyle;
  final double horizontalTitleMargin;

  // Vertical
  final TitleAlignment verticalTitlesAlignment;
  final GetTitleFunction getVerticalTitle;
  final double verticalTitlesReservedWidth;
  final TextStyle verticalTitlesTextStyle;
  final double verticalTitleMargin;

  const LineChartTitlesData({
    // Horizontal
    this.horizontalTitlesAlignment = TitleAlignment.BOTTOM,
    this.getHorizontalTitle = defaultGetTitle,
    this.horizontalTitlesReservedHeight = 10,
    this.horizontalTitlesTextStyle = const TextStyle(color: Colors.black, fontSize: 11,),
    this.horizontalTitleMargin = 6,
    // Vertical
    this.verticalTitlesAlignment = TitleAlignment.LEFT,
    this.getVerticalTitle = defaultGetTitle,
    this.verticalTitlesReservedWidth = 40,
    this.verticalTitlesTextStyle = const TextStyle(color: Colors.black, fontSize: 11,),
    this.verticalTitleMargin = 6,
  });
}