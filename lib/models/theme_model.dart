import 'package:flutter/material.dart';

class ThemeModel extends ChangeNotifier {

  int colorIndex = 0;
  List<Color> colors = [Colors.blue, Colors.purple, Colors.orange];
  Color get primaryColor => colors[colorIndex];

  void setColorIndex(int index) {
    colorIndex = index;
  }

  void switchPrimaryColor() {
    colorIndex = colorIndex == 0 ? 1 : (colorIndex == 1 ? 2 : 0);
    notifyListeners();
  }

}
