import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ringoqr/Security/checkTimestamp.dart';
import 'package:ringoqr/Classes/Event.dart';
import 'package:ringoqr/Classes/Ticket.dart';
import 'package:ringoqr/ApiEndpoints.dart';
import 'package:http/http.dart' as http;
import 'package:ringoqr/AppTabBar/TicketList.dart';
import 'package:ringoqr/AppTabBar/PastEvents.dart';

class ListViewPage extends StatefulWidget {
  const ListViewPage({Key? key}) : super(key: key);

  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  int page = 0;
  bool isLoading = false;
  bool hasMoreData = true;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadMoreData();
      }
    });
  }

  Future<void> _loadMoreData() async {
    if (!isLoading && hasMoreData) {
      setState(() {
        isLoading = true;
      });

      try {
        List<Event> newEvents = await getUpcomingEvents();

        if (newEvents.isEmpty) {
          setState(() {
            hasMoreData = false;
            isLoading = false;
          });
        } else {
          setState(() {
            page++;
            isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print("Error loading more data: $e");
      }
    }
  }

  Future<List<Event>> getUpcomingEvents() async {
    await checkTimestamp();
    var storage = FlutterSecureStorage();
    var hostId = await storage.read(key: "hostId");

    var url = Uri.parse(ApiEndpoints.GET_UPCOMING_EVENTS + hostId! + "&page=$page");
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
          "Events",
          style: TextStyle(
            color: currentTheme.primaryColor,
          ),
        ),
        trailing: CupertinoButton(
          child: Icon(
            CupertinoIcons.list_bullet,
            color: currentTheme.primaryColor,
          ),
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => PastEventsPage(),
              ),
            );
          },
        ),
      ),
      child: FutureBuilder<List<Event>>(
        future: getUpcomingEvents(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: snapshot.data!.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < snapshot.data!.length) {
                  var event = snapshot.data![index];
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
                                "${ApiEndpoints.GET_PHOTO}/${event.mainPhotoId}",
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
                                event.name,
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
                                    convertHourTimestamp(event.startTime!),
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
                                    "${event.peopleCount} / ${event.capacity}",
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
                              var url = Uri.parse('${ApiEndpoints.GET_TICKETS}/${event.id}');
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
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: currentTheme.primaryColor,
                      ),
                    ),
                  );
                }
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(
            child: CircularProgressIndicator(
              color: currentTheme.primaryColor,
            ),
          );
        },
      ),
    );
  }
}
