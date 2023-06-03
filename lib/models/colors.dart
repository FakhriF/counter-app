import 'package:flutter/material.dart';

Color backgroundColor = const Color.fromARGB(255, 37, 37, 37);
// Color textIconColor = const Color.fromARGB(255, 158, 191, 204);
// Color buttonColor = const Color.fromARGB(255, 84, 138, 160);

List textIconColors = const [
  Color.fromARGB(255, 158, 191, 204),
  Color.fromARGB(255, 183, 158, 204),
  Color.fromARGB(255, 204, 158, 158),
  Color.fromARGB(255, 163, 204, 158),
  Color.fromARGB(255, 203, 204, 158),
  Color.fromARGB(255, 204, 188, 158),
  Color.fromARGB(255, 161, 158, 204),
];

List buttonColors = const [
  Color.fromARGB(255, 84, 138, 160),
  Color.fromARGB(255, 160, 84, 143),
  Color.fromARGB(255, 160, 84, 84),
  Color.fromARGB(255, 84, 160, 88),
  Color.fromARGB(255, 146, 160, 84),
  Color.fromARGB(255, 160, 127, 84),
  Color.fromARGB(255, 92, 84, 160),
];

class ColorsNotifier extends ChangeNotifier {
  Color _textIconColor = textIconColors[0];
  Color _buttonColor = buttonColors[0];

  Color get textIconColor => _textIconColor;
  Color get buttonColor => _buttonColor;

  void changeGeneralColor(int colorIndex) {
    _textIconColor = textIconColors[colorIndex];
    _buttonColor = buttonColors[colorIndex];
    notifyListeners();
  }
}
