import 'dart:math';

import 'package:flutter/material.dart';

class ColorUtil {
  static var expendColors = [
    0xffFF4500,
    0xffFF8C00,
    0xffF4A460,
    0xffCD5C5C,
    0xffBDB76B,
    0xffFF6A6A,
    0xffEE9A00,
    0xffFF1493,
    0xffFF82AB
  ];

  static var incomeColors = [
    0xffC0FF3E,
    0xffFFF68F,
    0xffFFF68F,
    0xffEEDC82,
    0xffFFC125,
    0xff7FFF00,
    0xffFAFAD2,
    0xffBBFFFF,
    0xffFF82AB
  ];

  static Color randomColor() {
    return Color.fromARGB(255, Random().nextInt(256) + 0,
        Random().nextInt(256) + 0, Random().nextInt(256) + 0);
  }

  static Color getPieChartColor(int billProperty,int index){
    int colorIndex = index % 9;
    if(billProperty > 0){
      return Color(incomeColors[colorIndex]);
    }else{
      return Color(expendColors[colorIndex]);
    }
  }
}
