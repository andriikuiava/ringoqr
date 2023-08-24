import 'package:ringoqr/AppTabBar/Settings.dart';
import 'package:ringoqr/Security/logout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ringoqr/Themes.dart';
import 'package:ringoqr/main.dart';
import 'package:ringoqr/Themes.dart';
import 'package:ringoqr/AppTabBar/ScannerPage.dart';
import 'package:ringoqr/AppTabBar/ListView.dart';
import 'package:ringoqr/Security/logout.dart';

class AppTabBar extends StatefulWidget {
  const AppTabBar({Key? key}) : super(key: key);

  @override
  State<AppTabBar> createState() => _AppTabBarState();
}

class _AppTabBarState extends State<AppTabBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  GlobalKey<NavigatorState> scannerNavigatorKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> ticketsNavigatorKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> settingsNavigatorKey = GlobalKey<NavigatorState>();


  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        activeColor: currentTheme.primaryColor,
        backgroundColor: currentTheme.scaffoldBackgroundColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.qrcode),
            label: 'Scanner',
            backgroundColor: currentTheme.scaffoldBackgroundColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.list_bullet_below_rectangle),
            label: 'Events',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Settings',
            backgroundColor: Colors.white,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              navigatorKey: scannerNavigatorKey,
              builder: (BuildContext context) => ScannerPage(),
            );
          case 1:
            return CupertinoTabView(
              navigatorKey: ticketsNavigatorKey,
              builder: (BuildContext context) => ListViewPage(),
            );
          case 2:
            return CupertinoTabView(
              navigatorKey: settingsNavigatorKey,
              builder: (BuildContext context) => Settings(),
            );
          default:
            return CupertinoTabView(
              builder: (BuildContext context) => const Text(" "),
            );
        }

      },
    );
  }
}
