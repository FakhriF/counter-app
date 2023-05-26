import 'package:counter_app/color.dart';
import 'package:counter_app/counter.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('counterData');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  static ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final boxDB = Hive.box("counterData");

  //Call Box
  @override
  void initState() {
    super.initState();
    //Check Theme Mode
    if (boxDB.get("themeMode") != null) {
      String myUImode = boxDB.get("themeMode"); //Read All Data in BoxDB
      if (myUImode == "dark") {
        MyApp.themeNotifier = ValueNotifier(ThemeMode.dark);
      } else {
        MyApp.themeNotifier = ValueNotifier(ThemeMode.light);
      }
      // print(myUImode);
    } else {
      boxDB.put("themeMode", "dark");
      MyApp.themeNotifier = ValueNotifier(ThemeMode.dark);
      // print("Here Suc!");
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: MyApp.themeNotifier,
      builder: (_, currentMode, __) {
        return MaterialApp(
          title: 'Counter App',
          darkTheme: ThemeData.dark(),
          themeMode: currentMode,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textSelectionTheme: TextSelectionThemeData(
              selectionColor: textIconColor.withOpacity(0.2),
              selectionHandleColor: textIconColor.withOpacity(0.2),
            ),

            // scaffoldBackgroundColor: backgroundColor,
            appBarTheme: AppBarTheme(
              // backgroundColor: backgroundColor,
              iconTheme: IconThemeData(
                color: textIconColor,
                size: 35,
              ),
            ),
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            useMaterial3: true,
            primarySwatch: Colors.blue,
          ),
          // home: const MyHomePage(title: 'Flutter Demo Home Page'),
          home: const CounterPage(),
        );
      },
    );
  }
}
