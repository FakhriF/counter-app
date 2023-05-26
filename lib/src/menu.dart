import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum _MenuOptions {
  navigationDelegate,
  // listCookies,
  // clearCookies,
  // addCookie,
  // setCookie,
  // removeCookie,
}

class Menu extends StatefulWidget {
  const Menu({required this.controller, super.key});

  final WebViewController controller;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  // final cookieManager = WebViewCookieManager();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_MenuOptions>(
      onSelected: (value) async {
        switch (value) {
          case _MenuOptions.navigationDelegate:
            await widget.controller
                .loadRequest(Uri.parse('https://nekolabs.fakhrif.my.id/'));
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.navigationDelegate,
          child: Text('Navigate to Neko Labs'),
        ),
      ],
    );
  }
}
