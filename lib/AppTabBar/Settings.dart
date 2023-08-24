import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ringoqr/Security/logout.dart';
import 'package:ringoqr/Themes.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings>{
  @override
  Widget build(BuildContext context) {
    var currentTheme = Theme.of(context);
    return CupertinoPageScaffold(
      backgroundColor: currentTheme.scaffoldBackgroundColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: currentTheme.scaffoldBackgroundColor,
        middle: Text('Settings',
          style: TextStyle(
            color: currentTheme.primaryColor,
          ),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              Spacer(),
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  color: currentTheme.backgroundColor,
                  child: CupertinoButton(
                    child: Text('Logout',
                      style: TextStyle(
                        color: currentTheme.primaryColor,
                      ),
                    ),
                    onPressed: () {
                      logOut();
                    },
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ],
      )
    );
  }
}