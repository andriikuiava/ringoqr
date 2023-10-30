import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
  String searchQuery = "";
  final _searchController = TextEditingController();
  List<Ticket> _filteredTickets = [];

  @override
  void initState() {
    super.initState();
    _filteredTickets = widget.tickets;
  }

  void _searchTickets(String query) {
    setState(() {
      _filteredTickets = widget.tickets.where((ticket) {
        return ticket.participant.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

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
      child: Column(
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: CupertinoTextField(
              maxLength: 256,
              controller: _searchController,
              placeholder: 'Enter search query',
              padding: EdgeInsets.all(12),
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
              onChanged: (query) {
                _searchTickets(query);
              },
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: ListView.builder(
              itemCount: _filteredTickets.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Card(
                    elevation: 0,
                    color: currentTheme.backgroundColor,
                    child: ListTile(
                      title: Text(
                        "${_filteredTickets[index].participant.name}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: currentTheme.primaryColor,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        "Issued at ${convertHourTimestamp(_filteredTickets[index].timeOfSubmission)}\nType: ${_filteredTickets[index].ticketType!.title}",
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
                            color: _filteredTickets[index].isValidated ? Colors.red : isTimestampInThePast(_filteredTickets[index].event!.endTime!) ? Colors.yellow : Colors.green,),
                          const SizedBox(width: 5),
                          Text(
                            _filteredTickets[index].isValidated ? "Validated" : isTimestampInThePast(_filteredTickets[index].event!.endTime!) ? "Expired" : "Valid",
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
          )
        ],
      ),
    );
  }
}
