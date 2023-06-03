import 'package:counter_app/models/colors.dart';
import 'package:counter_app/widgets/simple_button.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  int colorIndex = 0;

  @override
  void initState() {
    super.initState();
    colorIndex = boxDB.get("colorIndex");
  }

  final boxDB = Hive.box("counterData"); //Call Box

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Theme",
            style: TextStyle(color: textIconColors[colorIndex])),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Please choose the color below!",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textIconColors[colorIndex],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                runSpacing: 20,
                children: textIconColors.asMap().entries.map((data) {
                  int index = data.key;
                  Color colors = data.value;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        colorIndex = index;
                      });
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          color: colors,
                          borderRadius: BorderRadius.circular(50)),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            SimpleButton(
              buttonName: "Save",
              action: () async {
                Provider.of<ColorsNotifier>(context, listen: false)
                    .changeGeneralColor(colorIndex);
                boxDB.put("colorIndex", colorIndex);
              },
              height: 45,
              width: 200,
            ),
          ],
        ),
      ),
    );
  }
}
