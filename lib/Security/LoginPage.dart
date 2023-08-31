import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ringoqr/Themes.dart';
import 'package:ringoqr/ApiEndpoints.dart';
import 'dart:io';
import 'package:ringoqr/Classes/Tokens.dart';
import 'package:ringoqr/Classes/LoginCredentials.dart';
import 'package:http/http.dart' as http;
import 'package:ringoqr/AppTabBar/HomeScreen.dart';
import 'package:ringoqr/main.dart';
import 'dart:developer';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});


  @override
  State<LoginPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<LoginPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  void login(String email, String password) async {
    var loginCredentials = LoginCredentials(email: email, password: password);
    var url = Uri.parse('${ApiEndpoints.LOGIN_RINGO}');
    var jsonBody = jsonEncode(loginCredentials.toJson());
    var headers = {'Content-Type': 'application/json'};
    var response = await http.post(url, headers: headers, body: jsonBody);
    const storage = FlutterSecureStorage();
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      final jsonResponse = customJsonDecode(response.body);
      DateTime currentTime = DateTime.now();
      DateTime futureTime =
      currentTime.add(const Duration(seconds: 30));
      storage.write(
          key: "timestamp",
          value: futureTime.toString());
      storage.write(
          key: "access_token",
          value: jsonResponse['accessToken']);
      storage.write(
          key: "refresh_token",
          value: jsonResponse['refreshToken']);
      Navigator.of(context, rootNavigator: true).pushReplacement(
          MaterialPageRoute(builder: (_) => const AppTabBar()));
    }
    else {
      showErrorAlert("Unable to login", "Check your password and try again", context);
      throw Exception('Failed to login');
    }
  }

  Future<void> signInWithGoogle() async {
    const storage = FlutterSecureStorage();
    try {
      GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email'],
          clientId: "445780816677-on7ff5l41ig1ervle491sc7vuvg4n5ro.apps.googleusercontent.com");
      GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account != null) {
        GoogleSignInAuthentication authentication = await account
            .authentication;
        String idToken = authentication.idToken ?? '';
        var url = Uri.parse('${ApiEndpoints.LOGIN_GOOGLE}');
        var headers = {'Content-Type': 'application/json'};
        var body = jsonEncode({'idToken': idToken});
        var response = await http.post(url, headers: headers, body: body);
        if (response.statusCode == 200) {
          final jsonResponse = customJsonDecode(response.body);
          DateTime currentTime = DateTime.now();
          DateTime futureTime =
          currentTime.add(const Duration(seconds: 30));
          storage.write(
              key: "timestamp",
              value: futureTime.toString());
          storage.write(
              key: "access_token",
              value: jsonResponse['accessToken']);
          storage.write(
              key: "refresh_token",
              value: jsonResponse['refreshToken']);
          Navigator.of(context, rootNavigator: true).pushReplacement(
              MaterialPageRoute(builder: (_) => const AppTabBar()));
        }
        else {
          showErrorAlert("Unable to login", "Check your password and try again", context);
          throw Exception('Failed to login');
        }
      }
    }
    catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    return CupertinoPageScaffold(
      backgroundColor: currentTheme.scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Row(
              children: [
                Spacer(),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    currentTheme.brightness == Brightness.light
                        ? 'assets/logo-ringo-w.png'
                        : 'assets/logo-ringo.png',
                    width: 200,
                    height: 200,
                  ),
                ),
                Spacer(),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Login to RingoQR',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: currentTheme.primaryColor,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 40),
            Container(
              width: MediaQuery.of(context).size.width * 0.90,
              child: CupertinoTextField(
                maxLength: 256,
                controller: _emailController,
                placeholder: 'Enter your email',
                padding: EdgeInsets.all(20),
                clearButtonMode: OverlayVisibilityMode.editing,
                cursorColor: currentTheme.primaryColor,
                keyboardType: TextInputType.emailAddress,
                decoration: BoxDecoration(
                  color: currentTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                style: TextStyle(
                  color: currentTheme.primaryColor,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width * 0.90,
              child: CupertinoTextField(
                maxLength: 64,
                controller: _passwordController,
                placeholder: 'Enter your password',
                padding: EdgeInsets.all(20),
                clearButtonMode: OverlayVisibilityMode.editing,
                cursorColor: currentTheme.primaryColor,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                decoration: BoxDecoration(
                  color: currentTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                style: TextStyle(
                  color: currentTheme.primaryColor,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width * 0.90,
              child: CupertinoButton(
                onPressed: () {
                  login(_emailController.text, _passwordController.text);
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: currentTheme.primaryColor,
                    decoration: TextDecoration.none,
                  ),
                ),
                color: currentTheme.backgroundColor,
                borderRadius: BorderRadius.circular(10),
                padding: EdgeInsets.all(20),
              ),
            ),
            const SizedBox(height: 20),
            Divider(
              color: currentTheme.backgroundColor,
              thickness: 1,
            ),
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width * 0.90,
              child: CupertinoButton(
                color: currentTheme.backgroundColor,
                borderRadius: BorderRadius.circular(10),
                padding: EdgeInsets.all(20),
                onPressed: signInWithGoogle,
                child: Row(
                  children: [
                    Spacer(),
                    Image.asset(
                      'assets/google-logo.png',
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Login with Google',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: currentTheme.primaryColor,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (Platform.isIOS)
              Container(
                width: MediaQuery.of(context).size.width * 0.90,
                height: 60,
                child: SignInWithAppleButton(
                  style: currentTheme.brightness == Brightness.light
                      ? SignInWithAppleButtonStyle.black
                      : SignInWithAppleButtonStyle.white,
                  onPressed: () async {
                    const storage = FlutterSecureStorage();
                    final credential = await SignInWithApple.getAppleIDCredential(
                      scopes: [
                        AppleIDAuthorizationScopes.email,
                        AppleIDAuthorizationScopes.fullName,
                      ],
                    );
                    var idToken = credential.identityToken;
                    var url = Uri.parse('${ApiEndpoints.LOGIN_APPLE}');
                    var headers = {'Content-Type': 'application/json'};
                    var body = jsonEncode({'idToken': idToken});
                    var response = await http.post(url, headers: headers, body: body);
                    if (response.statusCode == 200) {
                      final jsonResponse = customJsonDecode(response.body);
                      DateTime currentTime = DateTime.now();
                      DateTime futureTime =
                      currentTime.add(const Duration(seconds: 30));
                      storage.write(
                          key: "timestamp",
                          value: futureTime.toString());
                      storage.write(
                          key: "access_token",
                          value: jsonResponse['accessToken']);
                      storage.write(
                          key: "refresh_token",
                          value: jsonResponse['refreshToken']);
                      Navigator.of(context, rootNavigator: true).pushReplacement(
                          MaterialPageRoute(builder: (_) => const AppTabBar()));
                    }
                    else {
                      showErrorAlert("Unable to login", "Check your password and try again", context);
                      throw Exception('Failed to login');
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}