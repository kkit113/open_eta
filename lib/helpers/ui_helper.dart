import 'package:flutter/material.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';

class UiHelper {
//  double screenWidth = ScreenUtil.screenWidth;
//  double screenHeight = ScreenUtil.screenHeight;
//  double pixelRatio = ScreenUtil.pixelRatio;

  double scrWidth(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height;
  }

  double scrHeight(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width;
  }

  double srcRatio(BuildContext context) {
    return scrHeight(context) / scrWidth(context);
  }

  TextStyle timeString(int diff, double fontSize) {
    return TextStyle(
        inherit: true,
        fontSize: fontSize,
        color: diff > 180
            ? Colors.black
            : diff > 0 ? Colors.orange[500] : Colors.red);
  }

  TextStyle size(double fontSize) {
    return TextStyle(inherit: true, fontSize: fontSize);
  }

  TextStyle size15 = TextStyle(inherit: true, fontSize: 15);
//  TextStyle size20 = TextStyle(inherit: true, fontSize: 20);
//  TextStyle size26 = TextStyle(inherit: true, fontSize: 26);

  TextStyle size30 = TextStyle(inherit: true, fontSize: 30);

  TextStyle size40 = TextStyle(inherit: true, fontSize: 40);

  double stdFont(BuildContext context) {
    return scrWidth(context) * 0.05;
  }

  double stdPadding(BuildContext context) {
    return scrWidth(context) * 0.01;
  }

  var progressColor = AlwaysStoppedAnimation<Color>(Colors.deepOrange[500]);
}
