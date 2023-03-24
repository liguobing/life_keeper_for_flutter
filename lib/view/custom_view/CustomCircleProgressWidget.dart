import 'package:flutter/material.dart';

import 'custom_circle_progress.dart';
import 'dart:math' as math;

class CustomCircleProgressWidget extends StatelessWidget {
  //外圈圆弧半径
  double outCircleRadius;

  //完全圆弧颜色
  Color outCircleColor;

  //内圈实心圆半径
  double innerCircleRadius;

  //内圈实心圆颜色
  Color innerCircleColor;

  //外圈圆弧起始角度
  double outCircleStartAngle;

  //外圈圆弧扫过的弧度
  double outCircleSweepAngle;

  bool isFinish;

  String drawText;

  Paint mPaint;

  CustomCircleProgressWidget(
      double outCircleRadius,
      Color outCircleColor,
      double innerCircleRadius,
      Color innerCircleColor,
      double outCircleStartAngle,
      double outCircleSweepAngle,
      bool isFinish,
      String drawText) {
    this.outCircleRadius = outCircleRadius;
    this.outCircleColor = outCircleColor;
    this.innerCircleRadius = innerCircleRadius;
    this.innerCircleColor = innerCircleColor;
    this.outCircleStartAngle = outCircleStartAngle;
    this.outCircleSweepAngle = outCircleSweepAngle;
    this.isFinish = isFinish;
    this.drawText = drawText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        size: Size(outCircleRadius * 2, outCircleRadius * 2),
        painter: CustomCircleProgress(
            outCircleRadius,
            outCircleColor,
            innerCircleRadius,
            innerCircleColor,
            outCircleStartAngle,
            outCircleSweepAngle,
            isFinish,
            drawText),
      ),
    );
  }
}
