import 'package:counter_app/models/colors.dart';
import 'package:counter_app/pages/counter.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('counterData');
  runApp(const ProviderInitiate());
}

class ProviderInitiate extends StatefulWidget {
  const ProviderInitiate({super.key});

  @override
  State<ProviderInitiate> createState() => _ProviderInitiateState();
}

class _ProviderInitiateState extends State<ProviderInitiate> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ColorsNotifier(),
      child: MyApp(),
    );
  }
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

  Color textIconColor = textIconColors[0];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //   //Color from Provider
    final colorNotifier = context.watch<ColorsNotifier>();
    setState(() {
      textIconColor = colorNotifier.textIconColor;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: MyApp.themeNotifier,
      builder: (_, currentMode, __) {
        return MaterialApp(
          title: 'Counter App',
          darkTheme: ThemeData(
            scaffoldBackgroundColor: backgroundColor,
            appBarTheme: AppBarTheme(
              backgroundColor: backgroundColor,
              iconTheme: IconThemeData(
                color: textIconColor,
                // size: 15,
              ),
            ),
          ),
          themeMode: currentMode,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textSelectionTheme: TextSelectionThemeData(
              selectionColor: textIconColor.withOpacity(0.2),
              selectionHandleColor: textIconColor.withOpacity(0.2),
            ),
            // scaffoldBackgroundColor: backgroundColor,
            appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(
                color: textIconColor,
                // size: 35,
              ),
            ),
            useMaterial3: true,
            // primarySwatch: Colors.blue,
          ),
          // home: const MyHomePage(title: 'Flutter Demo Home Page'),
          home: const CounterPage(),
        );
      },
    );
  }
}
