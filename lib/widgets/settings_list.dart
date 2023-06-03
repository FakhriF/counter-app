import 'package:counter_app/models/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SettingListTile extends StatelessWidget {
  IconData icons;
  String title;
  VoidCallback tapAction;
  SettingListTile(
      {required this.icons,
      required this.title,
      required this.tapAction,
      super.key});

  @override
  Widget build(BuildContext context) {
    final colorNotifier = context.watch<ColorsNotifier>();
    final textIconColor = colorNotifier.textIconColor;
    // final Color colorTheme = context.read<ColorsNotifier>().generalColor;

    return ListTile(
      onTap: tapAction,
      leading: Icon(
        icons,
        color: textIconColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textIconColor,
        ),
      ),
    );
  }
}
