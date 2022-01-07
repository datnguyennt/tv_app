import 'package:flutter_screenutil/flutter_screenutil.dart';

class GeneralScreenUtils {
  static ScreenUtil _screenUtil = ScreenUtil();

  static double setHeight(double height) => _screenUtil.setHeight(height);

  static double setWidth(double width) => _screenUtil.setWidth(width);

  static double setSp(double size) => _screenUtil.setSp(size);

  static double setRadius(double radius) => _screenUtil.radius(radius);
}
