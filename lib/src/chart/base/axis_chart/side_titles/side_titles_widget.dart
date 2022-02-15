import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/extensions/edge_insets_extension.dart';
import 'package:fl_chart/src/extensions/fl_titles_data_extension.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/material.dart';

import '../axis_chart_helper.dart';
import 'side_titles_flex.dart';

enum TitlesSide { left, top, right, bottom }

class SideTitlesWidget extends StatelessWidget {
  final TitlesSide side;
  final AxisChartData axisChartData;
  final Size parentSize;

  const SideTitlesWidget({
    Key? key,
    required this.side,
    required this.axisChartData,
    required this.parentSize,
  }) : super(key: key);

  bool get isHorizontal => side == TitlesSide.top || side == TitlesSide.bottom;

  bool get isVertical => !isHorizontal;

  double get minX => axisChartData.minX;

  double get maxX => axisChartData.maxX;

  double get baselineX => axisChartData.baselineX;

  double get minY => axisChartData.minY;

  double get maxY => axisChartData.maxY;

  double get baselineY => axisChartData.baselineY;

  double get axisMin => isHorizontal ? minX : minY;

  double get axisMax => isHorizontal ? maxX : maxY;

  double get axisBaseLine => isHorizontal ? baselineX : baselineY;

  FlTitlesData get titlesData => axisChartData.titlesData;

  SideTitles get leftTitles => titlesData.leftTitles;

  SideTitles get topTitles => titlesData.topTitles;

  SideTitles get rightTitles => titlesData.rightTitles;

  SideTitles get bottomTitles => titlesData.bottomTitles;

  bool get isLeftOrTop => side == TitlesSide.left || side == TitlesSide.top;

  bool get isRightOrBottom =>
      side == TitlesSide.right || side == TitlesSide.bottom;

  SideTitles get sideTitles {
    switch (side) {
      case TitlesSide.left:
        return titlesData.leftTitles;
      case TitlesSide.top:
        return titlesData.topTitles;
      case TitlesSide.right:
        return titlesData.rightTitles;
      case TitlesSide.bottom:
        return titlesData.bottomTitles;
      default:
        throw StateError("Side is not valid $side");
    }
  }

  Axis get direction => isHorizontal ? Axis.horizontal : Axis.vertical;

  Axis get counterDirection => isHorizontal ? Axis.vertical : Axis.horizontal;

  Alignment get alignment {
    switch (side) {
      case TitlesSide.left:
        return Alignment.centerLeft;
      case TitlesSide.top:
        return Alignment.topCenter;
      case TitlesSide.right:
        return Alignment.centerRight;
      case TitlesSide.bottom:
        return Alignment.bottomCenter;
      default:
        throw StateError("Side is not valid $side");
    }
  }

  EdgeInsets get thisSidePadding {
    switch (side) {
      case TitlesSide.right:
      case TitlesSide.left:
        return titlesData.allSidesPadding.onlyTopBottom;
      case TitlesSide.top:
      case TitlesSide.bottom:
        return titlesData.allSidesPadding.onlyLeftRight;
      default:
        throw StateError("Side is not valid $side");
    }
  }

  double get thisSidePaddingTotal {
    switch (side) {
      case TitlesSide.right:
      case TitlesSide.left:
        return titlesData.allSidesPadding.vertical;
      case TitlesSide.top:
      case TitlesSide.bottom:
        return titlesData.allSidesPadding.horizontal;
      default:
        throw StateError("Side is not valid $side");
    }
  }

  List<AxisSideTitleWidgetHolder> makeWidgets(double axisViewSize) {
    final axisPositions = AxisChartHelper().getAxisPositions(
      min: axisMin,
      max: axisMax,
      baseLine: axisBaseLine,
      interval: sideTitles.interval ??
          Utils().getEfficientInterval(
            axisViewSize,
            axisMax - axisMin,
          ),
    );
    return axisPositions
        .map(
          (e) => AxisSideTitleWidgetHolder(
            AxisSideTitleMetaData(e),
            Center(
              child: sideTitles.getTitles(e, Utils().formatNumber(e)),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final axisViewSize = isHorizontal ? parentSize.width : parentSize.height;
    return Align(
      alignment: alignment,
      child: Flex(
        direction: counterDirection,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isLeftOrTop && sideTitles.axisName != null)
            _AxisTitleWidget(
              sideTitles: sideTitles,
              side: side,
              axisViewSize: axisViewSize,
            ),
          Container(
            width: isHorizontal ? axisViewSize : sideTitles.reservedSize,
            height: isHorizontal ? sideTitles.reservedSize : axisViewSize,
            margin: thisSidePadding,
            child: SideTitlesFlex(
              direction: direction,
              axisSideMetaData: AxisSideMetaData(
                axisMin,
                axisMax,
                axisViewSize - thisSidePaddingTotal,
              ),
              widgetHolders: makeWidgets(axisViewSize),
            ),
          ),
          if (isRightOrBottom && sideTitles.axisName != null)
            _AxisTitleWidget(
              sideTitles: sideTitles,
              side: side,
              axisViewSize: axisViewSize,
            ),
        ],
      ),
    );
  }
}

class _AxisTitleWidget extends StatelessWidget {
  final SideTitles sideTitles;
  final TitlesSide side;
  final double axisViewSize;

  const _AxisTitleWidget({
    Key? key,
    required this.sideTitles,
    required this.side,
    required this.axisViewSize,
  }) : super(key: key);

  int get axisNameQuarterTurns {
    switch (side) {
      case TitlesSide.right:
        return 1;
      case TitlesSide.left:
        return 3;
      case TitlesSide.top:
        return 0;
      case TitlesSide.bottom:
        return 0;
      default:
        throw StateError("Side is not valid $side");
    }
  }

  bool get isHorizontal => side == TitlesSide.top || side == TitlesSide.bottom;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:
      isHorizontal ? axisViewSize : sideTitles.axisNameReservedSize,
      height:
      isHorizontal ? sideTitles.axisNameReservedSize : axisViewSize,
      child: Center(
        child: RotatedBox(
          quarterTurns: axisNameQuarterTurns,
          child: sideTitles.axisName,
        ),
      ),
    );
  }
}
