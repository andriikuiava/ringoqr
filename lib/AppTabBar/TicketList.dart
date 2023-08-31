import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ringoqr/Security/checkTimestamp.dart';
import 'package:ringoqr/Classes/Event.dart';
import 'package:ringoqr/Classes/Ticket.dart';
import 'package:ringoqr/ApiEndpoints.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TicketList extends StatefulWidget {
  final List<Ticket> tickets;

  const TicketList({Key? key, required this.tickets}) : super(key: key);

  @override
  State<TicketList> createState() => _TicketListState();
}

class _TicketListState extends State<TicketList> {

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: currentTheme.scaffoldBackgroundColor,
        middle: Text(
          'Tickets',
          style: TextStyle(color: currentTheme.primaryColor),
        ),
        leading: CupertinoButton(
          child: Icon(
            CupertinoIcons.back,
            color: currentTheme.primaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      child: ListView.builder(
        itemCount: widget.tickets.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 0,
              color: currentTheme.backgroundColor,
              child: ListTile(
                title: Text("${widget.tickets[index].participant.name}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: currentTheme.primaryColor,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text("Issued at ${convertTimestamp(widget.tickets[index].timeOfSubmission)}",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.circle_fill,
                      size: 10,
                      color: widget.tickets[index].isValidated ? Colors.red : Colors.green,
                    ),
                    const SizedBox(width: 5),
                    Text(widget.tickets[index].isValidated ? "Validated" : "Not Validated",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
