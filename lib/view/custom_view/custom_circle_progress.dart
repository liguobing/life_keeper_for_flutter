import 'package:flutter/material.dart';

class CustomCircleProgress extends CustomPainter {
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

  //是否已经完成，如果已经完成，则绘制文字
  bool isFinish = false;

  //绘制的文字
  String drawText;

  Paint mPaint;

  CustomCircleProgress(
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

    //初始化画笔
    initPaint();
  }

  void initPaint() {
    mPaint = Paint();
    //先将画笔颜色设置为外圈带圆心圆弧颜色
//    mPaint.color = outCircleColor;
  }

  TextPainter textPainter = TextPainter(
    textDirection: TextDirection.ltr,
    maxLines: 1,
  );

  // 文字画笔 风格定义
  TextPainter _newVerticalAxisTextPainter(String text) {
    return textPainter
      ..text = TextSpan(
        text: text,
        style: new TextStyle(
          color: Colors.white,
          fontSize: outCircleRadius / 2,
        ),
      );
  }

  @override
  void paint(Canvas canvas, Size size) {
    //先画外部实心圆弧
    mPaint.color = outCircleColor;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    mPaint..style = PaintingStyle.fill;
    canvas.drawArc(
        rect, outCircleStartAngle, outCircleSweepAngle, true, mPaint);

    //再画一个实心圆，半径小于外部实心圆弧，形成一个空心效果
    mPaint.color = innerCircleColor;
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), innerCircleRadius, mPaint);

    if (isFinish) {
      // 绘制文字内容
      var tp = _newVerticalAxisTextPainter(drawText)..layout();
      // Text的绘制起始点 = 可用宽度 - 文字宽度 - 左边距
      tp.paint(canvas, Offset(size.width / 2 - outCircleRadius / 2, size.height / 2 - outCircleRadius / 2));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
