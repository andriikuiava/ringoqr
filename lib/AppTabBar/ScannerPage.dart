import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:ringoqr/Themes.dart';
import 'package:ringoqr/main.dart';
import 'package:ringoqr/Security/checkTimestamp.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:typed_data';
import 'package:ringoqr/TicketPage.dart';
import 'package:ringoqr/ApiEndpoints.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ringoqr/Classes/Ticket.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  State<ScannerPage> createState() => ScannerPageState();
}

void getHostId() async {
  await checkTimestamp();
  var storage = FlutterSecureStorage();
  var token = await storage.read(key: "access_token");
  if (await storage.read(key: "hostId") == null) {
  var url = Uri.parse('${ApiEndpoints.GET_ORGANISATION}');
  var headers = {
  'Content-Type' : 'application/json',
  'Authorization': 'Bearer $token'
  };
  var response = await http.get(url, headers: headers);
  print(response.body);
  var hostId = jsonDecode(response.body)['id'];
  await storage.write(key: "hostId", value: hostId.toString());
  }
}

class ScannerPageState extends State<ScannerPage> {

  @override
  initState() {
    super.initState();
    getHostId();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: currentTheme.scaffoldBackgroundColor,
        middle: Text(
          'Scanner',
          style: TextStyle(color: currentTheme.primaryColor),
        ),
      ),
      child: MobileScanner(
        startDelay: true,
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
          autoStart: true,
          detectionTimeoutMs: 1000,
        ),
        onDetect: (capture) async {
          final List<Barcode> barcodes = capture.barcodes;
          final Uint8List? image = capture.image;
          for (final barcode in barcodes) {
            print(barcode.rawValue);
            await checkTimestamp();
              final storage = FlutterSecureStorage();
              var token = await storage.read(key: "access_token");
              var url = Uri.parse('${ApiEndpoints.SCAN_TICKET}');
              var headers = {
                'Content-Type' : 'application/json',
                'Authorization': 'Bearer $token'
              };
              var body = {
                'ticketCode': "${barcode.rawValue}"
              };
                var response = await http.post(url, headers: headers, body: jsonEncode(body));
                if (response.statusCode == 200) {
                  var ticketScanned = Ticket.fromJson(jsonDecode(response.body));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TicketPage(ticket: ticketScanned, ticketCode: barcode.rawValue!),
                    ),
                  );
                } else {
                  showErrorAlert("Error", "Ticket code is not valid", context);
                }
          }
        },
      ),
      // child: CupertinoButton(
      //   child: Text('Scan'),
      //   onPressed: () async {
      //     await checkTimestamp();
      //     final storage = FlutterSecureStorage();
      //     var token = await storage.read(key: "access_token");
      //     var url = Uri.parse('${ApiEndpoints.SCAN_TICKET}');
      //     var headers = {
      //       'Content-Type' : 'application/json',
      //       'Authorization': 'Bearer $token'
      //     };
      //     var body = {
      //       'ticketCode': "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJSaW5nbyIsInN1YiI6IjhxcXpjZnQ3dGpAcHJpdmF0ZXJlbGF5LmFwcGxlaWQuY29tIiwiZXhwIjoxNjkzNjEyODAwLCJ0eXBlIjoidGlja2V0IiwiZXZlbnQiOjEsInBhcnRpY2lwYW50Ijo2fQ.gBhGpSz1TU0gVn0lro57JDglD5YnQR3DL9FA3uVqVK0EwZnT7DYTJkBWiZ1oWRrL-f96d6gEkZCkHdXT5X3aaQ"
      //     };
      //     var response = await http.post(url, headers: headers, body: jsonEncode(body));
      //     if (response.statusCode == 200) {
      //       var ticketScanned = Ticket.fromJson(jsonDecode(response.body));
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => TicketPage(ticket: ticketScanned, ticketCode: "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJSaW5nbyIsInN1YiI6IjhxcXpjZnQ3dGpAcHJpdmF0ZXJlbGF5LmFwcGxlaWQuY29tIiwiZXhwIjoxNjkzNjEyODAwLCJ0eXBlIjoidGlja2V0IiwiZXZlbnQiOjEsInBhcnRpY2lwYW50Ijo2fQ.gBhGpSz1TU0gVn0lro57JDglD5YnQR3DL9FA3uVqVK0EwZnT7DYTJkBWiZ1oWRrL-f96d6gEkZCkHdXT5X3aaQ",),
      //         ),
      //       );
      //     } else {
      //       showErrorAlert("Error", "Ticket code is not valid", context);
      //     }
      //   },
      // ),
    );
  }
}