import 'dart:convert';
import 'dart:io';

import 'package:counter_app/models/colors.dart';

import 'package:counter_app/main.dart';
import 'package:counter_app/pages/settings/button_size_adjuster_pages.dart';
import 'package:counter_app/pages/settings/help_page.dart';
import 'package:counter_app/pages/settings/theme_page.dart';
import 'package:counter_app/widgets/basic_dialog_box.dart';
import 'package:counter_app/widgets/settings_list.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final boxDB = Hive.box("counterData"); //Call Box
  @override
  Widget build(BuildContext context) {
    //Color from Provider
    final colorNotifier = context.watch<ColorsNotifier>();
    final textIconColor = colorNotifier.textIconColor;

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
              SettingListTile(
                icons: Icons.nightlight,
                title: "Dark Mode",
                tapAction: () async {
                  setState(() {
                    MyApp.themeNotifier.value = ThemeMode.dark;
                  });
                  await boxDB.put("themeMode", "dark");
                },
              ),
            ] else ...[
              SettingListTile(
                icons: Icons.wb_sunny_rounded,
                title: "Light Mode",
                tapAction: () async {
                  setState(() {
                    MyApp.themeNotifier.value = ThemeMode.light;
                  });
                  await boxDB.put("themeMode", "light");
                },
              ),
            ],
            SettingListTile(
              icons: Icons.color_lens_rounded,
              title: "Theme",
              tapAction: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => const ThemePage()),
                ),
              ),
            ),
            SettingListTile(
              icons: Icons.adjust_rounded,
              title: "Button Size Adjuster",
              tapAction: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => const ButtonSizeAdjuster()),
                ),
              ),
            ),
            SettingListTile(
              icons: Icons.download_rounded,
              title: "Export Data",
              tapAction: () async {
                final dir = await getExternalStorageDirectory();
                final path = dir!.path;

                List dataList = [];

                if (boxDB.get("counterData") != null) {
                  dataList = boxDB.get("counterData"); //Read All Data in BoxDB
                } else {
                  boxDB.put("counterData", []);
                }

                // convert dataLIst to Json with map name with name, counter with counter, dateCreated with date
                dataList = dataList.map((e) {
                  return {
                    "name": e[0],
                    "counter": e[1],
                    "dateCreated": e[2],
                  };
                }).toList();

                final jsonFile = File("$path/counterData.json");
                jsonFile.writeAsString(dataList.join(","));

                final txtFile = File("$path/counterData.txt");
                txtFile.writeAsString(dataList.join("\n"));

                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        BasicDialogBox(text: "Data Exported to $path"));
              },
            ),
            // SettingListTile(
            //   icons: Icons.help_center_rounded,
            //   title: "Help",
            //   tapAction: () => Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: ((context) => const HelpPage()),
            //     ),
            //   ),
            // ),
            SettingListTile(
              icons: Icons.info_rounded,
              title: "App Info",
              tapAction: () => showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      BasicDialogBox(text: "Counter App Ver 1.1")),
            ),
          ],
        ),
      ),
    );
  }
}
