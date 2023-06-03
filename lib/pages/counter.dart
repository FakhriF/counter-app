// ignore_for_file: use_build_context_synchronously

import 'package:counter_app/main.dart';
import 'package:counter_app/models/colors.dart';
import 'package:counter_app/pages/menu.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  static ValueNotifier<int> buttonSize = ValueNotifier(60);

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int counter = 0;
  TextEditingController title = TextEditingController();
  final boxDB = Hive.box("counterData"); //Call Box

  // double? buttonSize;

  List dataList = [];
  Color textIconColor = textIconColors[0];
  int colorIndex = 0;

  @override
  void initState() {
    super.initState();
    if (boxDB.get("counterData") != null) {
      dataList = boxDB.get("counterData"); //Read All Data in BoxDB
    } else {
      boxDB.put("counterData", []);
    }
    // print(dataList);
    //Check Button Size
    if (boxDB.get("buttonSize") != null) {
      // buttonSize = boxDB.get("buttonSize");
      CounterPage.buttonSize = ValueNotifier(boxDB.get("buttonSize"));
    } else {
      boxDB.put("buttonSize", 60);
      CounterPage.buttonSize = ValueNotifier(60);
    }
    //Initiate Color Theme
    if (boxDB.get("colorIndex") != null) {
      colorIndex = boxDB.get("colorIndex"); //Change Theme for Provider
      setState(() {
        textIconColor = textIconColors[colorIndex];
      });
    } else {
      boxDB.put("colorIndex", 0);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Menggunakan context.read untuk mendapatkan instance ColorNotifier
      Provider.of<ColorsNotifier>(context, listen: false)
          .changeGeneralColor(colorIndex);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //   //Color from Provider
    final colorNotifier = context.watch<ColorsNotifier>();
    setState(() {
      textIconColor = colorNotifier.textIconColor;
    });
  }

  void _incrementCounter() {
    setState(() {
      counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (counter > 0) {
        counter--;
      } else {
        counter = 0;
      }
    });
  }

  void _resetCounter() {
    setState(() {
      counter = 0;
    });
  }

//Dialog Box Save
  void _dialogBoxSave() {
    Dialog errorDialog = Dialog(
      backgroundColor: MyApp.themeNotifier.value == ThemeMode.dark
          ? backgroundColor
          : Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: SizedBox(
        height: 200.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Fill The Name Counter',
                style: TextStyle(color: textIconColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
              child: TextField(
                cursorColor: textIconColor,
                style: TextStyle(color: textIconColor),
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: textIconColor),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: textIconColor,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: textIconColor,
                      width: 2.0,
                    ),
                  ),
                  hintText: "Example: People in Class Today",
                  hintStyle: TextStyle(
                    fontSize: 10,
                    color: textIconColor.withOpacity(0.4),
                  ),
                ),
                controller: title,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 40.0),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 16, 16),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      title.clear();
                      Navigator.pop(context);
                    },
                    child: Text(
                      "CANCEL",
                      style: TextStyle(color: textIconColor),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      final now = DateTime.now(); //Take the Date Today
                      String formattedDate = DateFormat('dd/MM/yyyy')
                          .format(now); //Format it to DD/MM/YYYY
                      // print(formattedDate); // e.g. 20/03/2023
                      // print(counter);
                      // print(title);
                      List newData = [
                        title.text,
                        counter,
                        formattedDate,
                      ];
                      dataList.insert(0, newData);
                      // print(dataList);
                      await boxDB.put("counterData", dataList);
                      title.clear();
                      setState(() {
                        counter = 0;
                      });
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MenuPage()));
                    },
                    child: Text(
                      "SAVE",
                      style: TextStyle(color: textIconColor),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) => errorDialog,
    );
  }

//UI Home
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: CounterPage.buttonSize,
        builder: (_, buttonSize, __) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MenuPage())),
                          child: Icon(
                            Icons.menu,
                            color: textIconColor,
                            size: 35,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _resetCounter(),
                          child: Icon(
                            Icons.replay_rounded,
                            color: textIconColor,
                            size: 35,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _dialogBoxSave(),
                          child: Icon(
                            Icons.save_outlined,
                            color: textIconColor,
                            size: 35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        counter.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textIconColor,
                          fontSize: 130,
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () => _decrementCounter(),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: textIconColor, width: 4),
                                  borderRadius: BorderRadius.circular(100)),
                              child: Icon(
                                Icons.remove_rounded,
                                color: textIconColor,
                                size: buttonSize.toDouble(),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _incrementCounter(),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: textIconColor, width: 4),
                                  borderRadius: BorderRadius.circular(100)),
                              child: Icon(
                                Icons.add_rounded,
                                color: textIconColor,
                                size: buttonSize.toDouble(),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "COUNTER",
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 8,
                            color: textIconColor,
                          ),
                        ),
                        Text(
                          "APP",
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 8,
                            color: textIconColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
