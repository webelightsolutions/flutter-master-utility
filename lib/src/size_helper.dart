// Flutter imports:
import 'package:flutter/widgets.dart';

double _height = 0.0;
double _width = 0.0;
double _fontSize = 0.0;

class SizeHelper {
  static void setMediaQuerySize({required BuildContext context}) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fontSize = _height * _width * 0.01 / 100;
  }
}

extension SizerDouble on num {
  double get h => _height * this;
  double get w => _width * this;
  double get fs => _fontSize * this;
}
