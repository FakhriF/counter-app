import 'package:counter_app/widgets/basic_dialog_box.dart';
import 'package:counter_app/widgets/simple_button.dart';
import 'package:flutter/material.dart';
import 'package:counter_app/pages/counter.dart';
import 'package:hive/hive.dart';
import 'package:counter_app/models/colors.dart';
import 'package:provider/provider.dart';

class ButtonSizeAdjuster extends StatefulWidget {
  const ButtonSizeAdjuster({super.key});

  @override
  State<ButtonSizeAdjuster> createState() => _ButtonSizeAdjusterState();
}

class _ButtonSizeAdjusterState extends State<ButtonSizeAdjuster> {
  int buttonSize = 60;
  final boxDB = Hive.box("counterData"); //Call Box

  @override
  void initState() {
    super.initState();
    //Check Button Size
    if (boxDB.get("buttonSize") != null) {
      buttonSize = boxDB.get("buttonSize");
    } else {
      buttonSize = 60;
    }
  }

  @override
  Widget build(BuildContext context) {
    //Color from Provider
    final colorNotifier = context.watch<ColorsNotifier>();
    final textIconColor = colorNotifier.textIconColor;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Button Size Adjuster",
          style: TextStyle(
            color: textIconColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Slide the Slider below to adjust the button size",
              style:
                  TextStyle(color: textIconColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 50,
            ),
            Slider(
              inactiveColor: textIconColor.withOpacity(0.5),
              activeColor: textIconColor,
              value: buttonSize.toDouble(),
              onChanged: (newButtonSize) {
                setState(() {
                  buttonSize = newButtonSize.toInt();
                });
              },
              divisions: 4,
              label: "$buttonSize",
              max: 100,
              min: 20,
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: textIconColor, width: 4),
                  borderRadius: BorderRadius.circular(100)),
              child: Icon(
                Icons.add_rounded,
                color: textIconColor,
                size: buttonSize.toDouble(),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SimpleButton(
                  buttonName: "Reset",
                  action: () => {
                    setState(
                      () {
                        buttonSize = 60;
                      },
                    )
                  },
                  height: 40,
                  width: 90,
                ),
                SimpleButton(
                  buttonName: "Save",
                  action: () async {
                    CounterPage.buttonSize.value = buttonSize.toInt();
                    await boxDB.put("buttonSize", buttonSize);
                    // ignore: use_build_context_synchronously
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => BasicDialogBox(
                            text:
                                "The Button Size has been set to $buttonSize!"));
                  },
                  height: 40,
                  width: 90,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
