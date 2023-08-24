import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ringoqr/main.dart';
import 'package:ringoqr/Security/checkTimestamp.dart';
import 'package:ringoqr/Classes/Ticket.dart';
import 'package:ringoqr/Themes.dart';
import 'package:action_slider/action_slider.dart';
import 'package:ringoqr/ApiEndpoints.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';





class TicketPage extends StatefulWidget {
  final Ticket ticket;
  const TicketPage({Key? key, required this.ticket}) : super(key: key);

@override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  bool isErrorMessage = false;

  @override
  Widget build(BuildContext context) {
    var currentTheme = Theme.of(context);
    return CupertinoPageScaffold(
      backgroundColor: currentTheme.scaffoldBackgroundColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: currentTheme.scaffoldBackgroundColor,
        middle: Text("Ticket",
          style: TextStyle(color: currentTheme.primaryColor,),
        ),
        leading: CupertinoButton(
          child: Icon(
            CupertinoIcons.back,
            color: currentTheme.primaryColor
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ),
      child: Column(
        children: [
          const SizedBox(height: 20,),
          Row(
            children: [
              Spacer(),
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: ActionSlider.standard(
                      child: Row(
                        children: [
                          Spacer(),
                          Text('Slide to validate ticket',
                            style: TextStyle(
                              color: currentTheme.primaryColor,
                              fontSize: 16,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                      icon: Icon(
                        CupertinoIcons.right_chevron,
                        color: currentTheme.backgroundColor,
                      ),
                      successIcon: Icon(
                        CupertinoIcons.checkmark_alt_circle_fill,
                        color: currentTheme.backgroundColor,
                      ),
                      toggleColor: currentTheme.primaryColor,
                      failureIcon: Icon(
                        CupertinoIcons.xmark_circle_fill,
                        color: currentTheme.backgroundColor,
                      ),
                      loadingIcon: CupertinoActivityIndicator(
                        radius: 15,
                        color: currentTheme.backgroundColor,
                      ),
                      backgroundColor: (isErrorMessage) ? Colors.red : (widget.ticket.isValidated) ? Colors.green : currentTheme.backgroundColor,
                      action: (controller) async {
                        controller.loading();
                        await checkTimestamp();
                        final storage = FlutterSecureStorage();
                        var token = await storage.read(key: "access_token");
                        var url = Uri.parse('${ApiEndpoints.VALIDATE_TICKET}');
                        var headers = {
                          'Content-Type' : 'application/json',
                          'Authorization': 'Bearer $token'
                        };
                        var body = {
                          'ticketCode': "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJSaW5nbyIsInN1YiI6IjhxcXpjZnQ3dGpAcHJpdmF0ZXJlbGF5LmFwcGxlaWQuY29tIiwiZXhwIjoxNzA0MDY5NjAwLCJ0eXBlIjoidGlja2V0IiwiZXZlbnQiOjIsInBhcnRpY2lwYW50IjoyfQ.DTEtb60KLRO7VX4aJWu6p1pDYee7lmnnHA1MXWjfZQCulzQeSqY03mNp-lHT1YKziC68HyJvsVSsfYtRwuF1FA"
                        };
                        var response = await http.post(url, headers: headers, body: jsonEncode(body));
                        print(response.body);
                        if (response.statusCode == 200) {
                          controller.success();
                          await Future.delayed(Duration(seconds: 1));
                          setState(() {
                            widget.ticket.isValidated = true;
                          });
                        } else {
                          setState(() {
                            isErrorMessage = true;
                          });
                          controller.failure();
                          await Future.delayed(Duration(seconds: 2));
                          controller.reset();
                        }
                      },
                    ),
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}