import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ringoqr/Security/checkTimestamp.dart';
import 'package:ringoqr/Classes/Event.dart';
import 'package:ringoqr/Classes/Ticket.dart';
import 'package:ringoqr/ApiEndpoints.dart';
import 'package:http/http.dart' as http;
import 'package:ringoqr/AppTabBar/TicketList.dart';

class PastEventsPage extends StatefulWidget {
  const PastEventsPage({Key? key}) : super(key: key);

  @override
  State<PastEventsPage> createState() => _PastEventsPageState();
}

class _PastEventsPageState extends State<PastEventsPage> {

  @override
  void initState() {
    super.initState();
  }

  Future<List<Event>> getPastEvents() async {
    await checkTimestamp();
    var storage = FlutterSecureStorage();
    var hostId = await storage.read(key: "hostId");

    var url = Uri.parse(ApiEndpoints.GET_PAST_EVENTS + hostId!);
    var headers = {
      'Content-Type' : 'application/json'
    };

    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = customJsonDecode(response.body);
      List<Event> events = [];
      for (var event in jsonResponse) {
        events.add(Event.fromJson(event));
      }
      return events;
    } else {
      throw Exception("Failed to load events");
    }
  }

  @override
  Widget build(BuildContext context) {
    var currentTheme = Theme.of(context);
    return CupertinoPageScaffold(
      backgroundColor: currentTheme.scaffoldBackgroundColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: currentTheme.scaffoldBackgroundColor,
        middle: Text(
          "Past Events",
          style: TextStyle(
            color: currentTheme.primaryColor,
          ),
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
      child: FutureBuilder<List<Event>>(
        future: getPastEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: currentTheme.primaryColor,
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No past events found",
                style: TextStyle(
                  color: currentTheme.primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                ),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Card(
                  color: currentTheme.backgroundColor,
                  child: Container(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              "${ApiEndpoints.GET_PHOTO}/${snapshot.data![index].mainPhotoId}",
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data![index].name,
                              style: TextStyle(
                                color: currentTheme.primaryColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  CupertinoIcons.calendar_today,
                                  color: Colors.grey,
                                  size: 18,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  convertHourTimestamp(snapshot.data![index].startTime!),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  CupertinoIcons.person_2_fill,
                                  color: Colors.grey,
                                  size: 18,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "${snapshot.data![index].peopleCount} / ${snapshot.data![index].capacity}",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
                        CupertinoButton(
                          child: Icon(
                            CupertinoIcons.chevron_right,
                            color: Colors.grey,
                          ),
                          onPressed: () async {
                            await checkTimestamp();
                            var storage = FlutterSecureStorage();
                            var token = await storage.read(key: "access_token");
                            var url = Uri.parse('${ApiEndpoints.GET_TICKETS}/${snapshot.data![index].id}');
                            var headers = {
                              'Content-Type' : 'application/json',
                              'Authorization': 'Bearer $token'
                            };
                            var response = await http.get(url, headers: headers);
                            if (response.statusCode == 200) {
                              var jsonResponse = customJsonDecode(response.body);
                              List<Ticket> tickets = [];
                              for (var ticket in jsonResponse) {
                                tickets.add(Ticket.fromJson(ticket));
                              }
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => TicketList(tickets: tickets),
                                ),
                              );
                            } else {
                              throw Exception("Failed to load tickets");
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

