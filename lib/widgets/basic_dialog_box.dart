import 'package:counter_app/main.dart';
import 'package:counter_app/models/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class BasicDialogBox extends StatelessWidget {
  String text;

  BasicDialogBox({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    //Color from Provider
    final colorNotifier = context.watch<ColorsNotifier>();
    final textIconColor = colorNotifier.textIconColor;

    return Dialog(
      backgroundColor: MyApp.themeNotifier.value == ThemeMode.dark
          ? backgroundColor
          : Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: SizedBox(
        height: 150.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                text,
                style: TextStyle(color: textIconColor),
              ),
            ),
            // Padding(padding: EdgeInsets.only(top: 50.0)),
            Row(
              // crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Close!',
                      style: TextStyle(color: textIconColor, fontSize: 18.0),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
