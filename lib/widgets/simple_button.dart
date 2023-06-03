import 'package:counter_app/models/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SimpleButton extends StatelessWidget {
  String buttonName;
  double height;
  double width;
  VoidCallback action;

  SimpleButton(
      {required this.buttonName,
      required this.action,
      required this.height,
      required this.width,
      super.key});

  @override
  Widget build(BuildContext context) {
//Color from Provider
    final colorNotifier = context.watch<ColorsNotifier>();
    final buttonColor = colorNotifier.buttonColor;

    return GestureDetector(
      onTap: action,
      child: Container(
        height: height,
        width: width,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(36),
          // border: Border.all(width: 2, color: textIconColor)
          color: buttonColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              buttonName,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
