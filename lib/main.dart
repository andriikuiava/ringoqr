import 'package:flutter/material.dart';
import 'package:ringoqr/Security/LoginPage.dart';
import 'package:ringoqr/Themes.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ringoqr/Security/checkTimestamp.dart';
import 'package:ringoqr/AppTabBar/HomeScreen.dart';

final GlobalKey<NavigatorState> navigatorKey = App.materialKey;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RingoQR',
      theme: lightTheme,
      navigatorKey: navigatorKey,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<Widget>(
        future: doWhenLoad(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error loading data');
          } else {
            return snapshot.data ?? const LoginPage();
          }
        },
      ),
    );
  }
}

Future<Widget> doWhenLoad() async {
  final storage = await FlutterSecureStorage();
  String currentTime = DateTime.now().toString();
  String? storedTime = await storage.read(key: 'timestamp');
  print("Stored time: $storedTime");
  if (storedTime != null) {
    await checkTimestamp();
    return AppTabBar();
  } else {
    return LoginPage();
  }
}


class App {
  static final GlobalKey<NavigatorState> materialKey = GlobalKey<NavigatorState>();
}