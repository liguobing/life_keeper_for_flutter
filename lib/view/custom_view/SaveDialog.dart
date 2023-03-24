import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifekeeperforflutter/event/DialogEvent.dart';

import 'CustomCircleProgressWidget.dart';
import 'CustomSizeDialog.dart';

class SaveDialog extends StatefulWidget {

  final double outCircleRadius;
  final Color outCircleColor;
  final double innerCircleRadius;
  final Color innerCircleColor;
  final double progressPadding;

  SaveDialog(
      this.outCircleRadius,
      this.outCircleColor,
      this.innerCircleRadius,
      this.innerCircleColor,
      this.progressPadding);

  @override
  State<SaveDialog> createState() {
    return SaveDialogState( outCircleRadius,
        outCircleColor,
        innerCircleRadius,
        innerCircleColor,
        progressPadding);
  }
}

class SaveDialogState extends State<SaveDialog> with TickerProviderStateMixin {
  //外圈实心圆弧半径，和内圈实心圆组合形成进度圆弧
  double outCircleRadius = 55;

  //外圈实心圆弧颜色
  Color outCircleColor = Colors.lightGreenAccent;

  //内圈实心圆半径
  double innerCircleRadius = 50;

  //内圈实心圆颜色
  Color innerCircleColor = Colors.white;

  //外圈圆弧开始角度
  double outCircleStartAngle = 0;

  //外圈圆弧弧度（2Π为整个圆）
  double outCircleSweepAngle = pi * 2 / 5;

  //圆弧角度动画控制器
  AnimationController arcAngleController;

  //圆弧弧度动画控制器
  AnimationController arcSweepController;

  //内圈实心圆半径动画控制器
  AnimationController innerCircleRadiusController;

  //
  bool arcAngleIsFinish = false;

  //
  bool arcSweepIsFinish = false;

  //动画最后绘制的文字
  String drawText = "";

  //用户控制绘制文字的时间，当所有动画执行完毕之后，该值为true
  bool isFinish = false;

  //结果类型，用于控制最后显示的文字以及背景颜色
  //目前这一块是写死的
  //大于0，背景色为绿色，文字为成功
  //小于0，背景色为红色，文字为失败
  int endType = 0;

  //进度条的 padding
  //该值 + 外圈圆弧半径 = dialog 的宽高
  double progressPadding = 0;


  SaveDialogState(
      this.outCircleRadius,
      this.outCircleColor,
      this.innerCircleRadius,
      this.innerCircleColor,
      this.progressPadding);

  @override
  void initState() {
    super.initState();
    _initDialogAnimationParam();
    arcAngleController.forward();
    _listen();
  } //初始化 dialog 动画参数

  _initDialogAnimationParam() {
    arcAngleController = AnimationController(
        lowerBound: 0,
        upperBound: 2 * pi,
        vsync: this,
        duration: Duration(milliseconds: 1000));
    arcAngleController.addListener(() {
      if (arcAngleController.isCompleted) {
        arcAngleController.repeat();
      }
      if (arcAngleIsFinish) {
        arcAngleController.dispose();
        arcSweepController = AnimationController(
            lowerBound: outCircleSweepAngle,
            upperBound: 2 * pi,
            vsync: this,
            duration: Duration(milliseconds: 1000));
        arcSweepController.addListener(() {
          setState(() {});
          if (arcSweepController.isCompleted) {
            arcSweepIsFinish = true;
            innerCircleRadiusController = AnimationController(
                vsync: this, duration: Duration(milliseconds: 1000));

            if (endType > 0) {
              outCircleColor = Colors.lightGreenAccent;
            } else {
              outCircleColor = Colors.red;
            }

            Animation tween = Tween<double>(begin: innerCircleRadius, end: 0)
                .animate(innerCircleRadiusController);
            innerCircleRadiusController.addListener(() {
              innerCircleRadius = tween.value;
              if (innerCircleRadiusController.isCompleted) {
                drawText = drawText;
                isFinish = true;
                Future.delayed(Duration(seconds: 1)).then((value) {
                  Navigator.pop(context);
                }).then((value) {
                  _resetWaitDialogParam();
                });
              }
              setState(() {});
            });
            innerCircleRadiusController.forward();
          }
        });
        arcSweepController.forward();
      }
      setState(() {});
    });
  }

  //重置动画参数，以备再次执行动画
  _resetWaitDialogParam() {
    outCircleRadius = 100;
    outCircleColor = Colors.lightGreenAccent;
    innerCircleRadius = 95;
    innerCircleColor = Colors.white;
    outCircleStartAngle = 0;
    outCircleSweepAngle = pi * 2 / 5;
    arcAngleIsFinish = false;
    arcSweepIsFinish = false;
    drawText = "";
    isFinish = false;
  }

  @override
  Widget build(BuildContext context) {
    return CustomSizeDialog(
      child: Padding(
        padding: EdgeInsets.all(progressPadding),
        child: CustomCircleProgressWidget(
            outCircleRadius,
            outCircleColor,
            innerCircleRadius,
            innerCircleColor,
            arcAngleController.value,
            arcAngleIsFinish ? arcSweepController.value : outCircleSweepAngle,
            isFinish,
            drawText),
      ),
    );
  }

  //监听Bus events
  void _listen() {
    eventBus.on<DialogEvent>().listen((event) {
      arcAngleIsFinish = true;
      endType = event.message;
      if (event.message > 0) {
        drawText = "成功";
      } else {
        drawText = "失败";
      }
    });
  }
}
