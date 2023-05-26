import 'package:counter_app/color.dart';
import 'package:counter_app/counter.dart';
import 'package:counter_app/main.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'src/menu.dart'; // ADD

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final boxDB = Hive.box("counterData"); //Call Box
  @override
  Widget build(BuildContext context) {
    Dialog appInfoDialog = Dialog(
      // backgroundColor: backgroundColor,
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
                'Counter App Ver 1.0.1',
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(
            color: textIconColor,
          ),
        ),
        elevation: 0,
      ),
      body: SafeArea(
          child: ListView(
        children: [
          if (MyApp.themeNotifier.value == ThemeMode.light) ...[
            ListTile(
              // onTap: () => {
              //   setState(() {
              //     MyApp.themeNotifier.value = ThemeMode.dark;
              //   })
              // },
              onTap: () async {
                setState(() {
                  MyApp.themeNotifier.value = ThemeMode.dark;
                });
                await boxDB.put("themeMode", "dark");
              },
              leading: Icon(
                Icons.nightlight,
                color: textIconColor,
              ),
              title: Text(
                "Dark Mode",
                style: TextStyle(
                  color: textIconColor,
                ),
              ),
            ),
          ] else ...[
            ListTile(
              // onTap: () => {
              //   setState(() {
              //     MyApp.themeNotifier.value = ThemeMode.light;
              //   })
              // },
              onTap: () async {
                setState(() {
                  MyApp.themeNotifier.value = ThemeMode.light;
                });
                await boxDB.put("themeMode", "light");
              },
              leading: Icon(
                Icons.wb_sunny_rounded,
                color: textIconColor,
              ),
              title: Text(
                "Light Mode",
                style: TextStyle(
                  color: textIconColor,
                ),
              ),
            ),
          ],
          ListTile(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) => const ButtonSizeAdjuster()),
              ),
            ),
            leading: Icon(
              Icons.adjust_rounded,
              color: textIconColor,
            ),
            title: Text(
              "Button Size Adjuster",
              style: TextStyle(
                color: textIconColor,
              ),
            ),
          ),
          ListTile(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) => const HelpPage()),
              ),
            ),
            leading: Icon(
              Icons.help_center_rounded,
              color: textIconColor,
            ),
            title: Text(
              "Help",
              style: TextStyle(
                color: textIconColor,
              ),
            ),
          ),
          ListTile(
            onTap: () => showDialog(
                context: context,
                builder: (BuildContext context) => appInfoDialog),
            leading: Icon(
              Icons.info_rounded,
              color: textIconColor,
            ),
            title: Text(
              "App Info",
              style: TextStyle(
                color: textIconColor,
              ),
            ),
          )
        ],
      )),
    );
  }
}

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
    //Dialog Change Notice!
    Dialog changeNoticeDialog = Dialog(
      // backgroundColor: backgroundColor,
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
                'The Button Size has been set to $buttonSize!',
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
                GestureDetector(
                  onTap: () => {
                    setState(
                      () {
                        buttonSize = 60;
                      },
                    )
                  },
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: textIconColor,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Reset",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    CounterPage.buttonSize.value = buttonSize.toInt();
                    await boxDB.put("buttonSize", buttonSize);
                    // ignore: use_build_context_synchronously
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => changeNoticeDialog);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: textIconColor,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Save",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  late final WebViewController controller;
  var loadingPercentage = 0;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
          });
        },
        onNavigationRequest: (navigation) {
          final host = Uri.parse(navigation.url).host;
          if (host.contains('youtube.com')) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Blocking navigation to $host',
                ),
              ),
            );
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'SnackBar',
        onMessageReceived: (message) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message.message)));
        },
      )
      ..loadRequest(
          Uri.parse('https://nekolabs.fakhrif.my.id/counter-app/help'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Counter App Help Page",
          style: TextStyle(
            color: textIconColor,
          ),
        ),
        actions: [
          Menu(controller: controller),
        ],
      ),
      body: Stack(children: [
        WebViewWidget(
          controller: controller,
        ),
        if (loadingPercentage < 100)
          LinearProgressIndicator(
            color: textIconColor,
            value: loadingPercentage / 100.0,
          ),
      ]),
    );
  }
}
