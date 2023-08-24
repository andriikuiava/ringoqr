import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ringoqr/main.dart';
import 'package:ringoqr/Security/LoginPage.dart';

void logOut() {
  const storage = FlutterSecureStorage();
  storage.deleteAll();

  Navigator.of(navigatorKey.currentContext!, rootNavigator: true)
      .pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
}