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
  final String ticketCode;
  const TicketPage({Key? key, required this.ticket, required this.ticketCode}) : super(key: key);

@override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  bool isErrorMessage = false;
  List<Answer> answers = [];
  bool isAnswersExpanded = false;

  void loadAnswers() async {
    answers = widget.ticket.registrationSubmission!.answers!;
  }

  @override
  void initState() {
    super.initState();
    loadAnswers();
  }

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
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20,),
            FractionallySizedBox(
              widthFactor: 0.9,
              child: ClipRRect(
                borderRadius: defaultWidgetCornerRadius,
                child: Container(
                  padding: EdgeInsets.all(8),
                  color: currentTheme.primaryColor,
                  child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: defaultWidgetCornerRadius,
                            child: Image.network(
                              '${ApiEndpoints.GET_PHOTO}/${widget.ticket.event!.mainPhotoId}',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text("${widget.ticket.event!.name}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: currentTheme
                                          .scaffoldBackgroundColor,
                                      decoration: TextDecoration.none,
                                    )
                                ),
                              ),
                              const SizedBox(height: 2,),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(convertHourTimestamp(widget.ticket.event!.startTime!),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                      decoration: TextDecoration.none,
                                    )
                                ),
                              ),
                              const SizedBox(height: 2,),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text("${widget.ticket.event!.peopleCount}/${widget.ticket.event!.capacity} people are going",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                      decoration: TextDecoration.none,
                                    )
                                ),
                              ),
                              const SizedBox(height: 1,),
                            ],
                          ),
                        ],
                      )
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            FractionallySizedBox(
              widthFactor: 0.9,
              child: ClipRRect(
                borderRadius: defaultWidgetCornerRadius,
                child: Container(
                  color: currentTheme.backgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("NAME",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                              decoration: TextDecoration.none,
                            )
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.87,
                          child: Text(widget.ticket.participant.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: currentTheme.primaryColor,
                                decoration: TextDecoration.none,
                              )
                          ),
                        ),
                        const SizedBox(height: 7,),
                        const Text("USERNAME",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                              decoration: TextDecoration.none,
                            )
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.87,
                          child: Text("@${widget.ticket.participant.username}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: currentTheme.primaryColor,
                                decoration: TextDecoration.none,
                              )
                          ),
                        ),
                        const SizedBox(height: 7,),
                        const Text("COST",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                              decoration: TextDecoration.none,
                            )
                        ),
                        (widget.ticket.event!.price == 0.0 || widget.ticket.event!.price == null)
                        ? Container(
                          width: MediaQuery.of(context).size.width * 0.87,
                          child: Text("Free",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: currentTheme.primaryColor,
                                decoration: TextDecoration.none,
                              )
                          ),
                        )
                        : Container(
                          width: MediaQuery.of(context).size.width * 0.87,
                          child: Text("${widget.ticket.event!.currency!.symbol}${widget.ticket.event!.price}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: currentTheme.primaryColor,
                                decoration: TextDecoration.none,
                              )
                          ),
                        ),
                        const SizedBox(height: 7,),
                        const Text("ADDRESS",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                              decoration: TextDecoration.none,
                            )
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.87,
                          child: Text(widget.ticket.event!.address!,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: currentTheme.primaryColor,
                                decoration: TextDecoration.none,
                              )
                          ),
                        ),
                        const SizedBox(height: 7,),
                        const Text("ISSUED AT",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                              decoration: TextDecoration.none,
                            )
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.87,
                          child: Text(convertHourTimestamp(widget.ticket.timeOfSubmission),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: currentTheme.primaryColor,
                                decoration: TextDecoration.none,
                              )
                          ),
                        ),
                        const SizedBox(height: 8,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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
                            Text(
                              (widget.ticket.isValidated) ? "Already validated" : "Slide to validate ticket",
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
                          color: (widget.ticket.isValidated) ? Colors.green : currentTheme.backgroundColor,
                        ),
                        successIcon: Icon(
                          CupertinoIcons.checkmark_alt_circle_fill,
                          color: currentTheme.backgroundColor,
                        ),
                        toggleColor: (widget.ticket.isValidated) ? Colors.green : currentTheme.primaryColor,
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
                            'ticketCode': "${widget.ticketCode}"
                          };
                          var response = await http.post(url, headers: headers, body: jsonEncode(body));
                          if (response.statusCode == 200) {
                            controller.success();
                            await Future.delayed(Duration(seconds: 1));
                            setState(() {
                              widget.ticket.isValidated = true;
                            });
                            controller.reset();
                          } else {
                            setState(() {
                              isErrorMessage = true;
                            });
                            controller.failure();
                            await Future.delayed(Duration(seconds: 2));
                            controller.reset();
                            setState(() {
                              isErrorMessage = false;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Spacer(),
              ],
            ),
            const SizedBox(height: 20,),
            (widget.ticket.registrationForm != null)
                ? FractionallySizedBox(
              widthFactor: 0.9,
              child: ClipRRect(
                borderRadius: defaultWidgetCornerRadius,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  color: currentTheme.backgroundColor,
                  child: CupertinoButton(
                    onPressed: () {
                      setState(() {
                        isAnswersExpanded = !isAnswersExpanded;
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          "Registration Form",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: currentTheme
                                .primaryColor,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          isAnswersExpanded
                              ? CupertinoIcons.chevron_up
                              : CupertinoIcons.chevron_down,
                          color: currentTheme.primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
                : Container(),
            const SizedBox(height: 10,),
            AnimatedSize(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: (isAnswersExpanded)
                  ? FractionallySizedBox(
                widthFactor: 0.9,
                child: ClipRRect(
                  borderRadius: defaultWidgetCornerRadius,
                  child: Container(
                    color: currentTheme.backgroundColor,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.ticket.registrationForm!.questions.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final question = widget.ticket.registrationForm!.questions[index];
                        switch (question.type) {
                          case "INPUT_FIELD":
                            return buildInputFieldQuestion(question);
                          case "MULTIPLE_CHOICE":
                            return buildMultipleChoiceQuestion(question);
                          case "CHECKBOX":
                            return buildCheckboxQuestion(question);
                          default:
                            return Container();
                        }
                      },
                    ),
                  ),
                ),
              )
                  : Placeholder(
                  color: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputFieldQuestion(Question question) {
    final currentTheme = Theme.of(context);
    return Card(
      elevation: 0,
      margin: EdgeInsets.all(16),
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    "${question.content}${question.required ? ' *' : ''}",
                    style: TextStyle(
                      fontSize: 16,
                      color: currentTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8,),
          CupertinoTextField(
              enabled: false,
              maxLength: question.maxCharacters,
              decoration: BoxDecoration(
                color: currentTheme.backgroundColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              controller: TextEditingController(
                text: answers.firstWhere((answer) => answer.questionId == question.id).content,
              ),
              padding: EdgeInsets.all(16),
              style: TextStyle(
                fontSize: 16,
                color: currentTheme.primaryColor,
              ),
              cursorColor: currentTheme.primaryColor
          ),
        ],
      ),
    );
  }

  Widget buildMultipleChoiceQuestion(Question question) {
    var currentTheme = Theme.of(context);
    return Card(
      elevation: 0,
      margin: EdgeInsets.all(16),
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  "${question.content}${question.required ? ' *' : ''}",
                  style: TextStyle(
                    fontSize: 16,
                    color: currentTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: question.options!.length,
            itemBuilder: (context, index) {
              final option = question.options![index];
              return Container(
                margin: EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: currentTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    Icon(
                      answers.firstWhere((answer) => answer.questionId == question.id).optionIds!.contains(option.id)
                          ? CupertinoIcons.smallcircle_fill_circle
                          : CupertinoIcons.circle,
                      color: answers.firstWhere((answer) => answer.questionId == question.id).optionIds!.contains(option.id)
                          ? currentTheme.primaryColor
                          : currentTheme.primaryColor.withOpacity(0.3),
                    ),
                    SizedBox(width: 16),
                    Text(
                      option.content,
                      style: TextStyle(
                        fontSize: 16,
                        color: answers.firstWhere((answer) => answer.questionId == question.id).optionIds!.contains(option.id)
                            ? currentTheme.primaryColor
                            : currentTheme.primaryColor.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildCheckboxQuestion(Question question) {
    var currentTheme = Theme.of(context);
    return Card(
      elevation: 0,
      margin: EdgeInsets.all(16),
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Text(
              "${question.content}${question.required ? ' *' : ''}",
              style: TextStyle(
                fontSize: 16,
                color: currentTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: question.options!.length,
            itemBuilder: (context, index) {
              final option = question.options![index];
              return Container(
                margin: EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: currentTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    Icon(
                      answers.firstWhere((answer) => answer.questionId == question.id).optionIds!.contains(option.id)
                          ? CupertinoIcons.checkmark_square_fill
                          : CupertinoIcons.square,
                      color: answers.firstWhere((answer) => answer.questionId == question.id).optionIds!.contains(option.id)
                          ? currentTheme.primaryColor
                          : currentTheme.primaryColor.withOpacity(0.3),
                    ),
                    SizedBox(width: 16),
                    Text(
                      option.content,
                      style: TextStyle(
                        fontSize: 16,
                        color: answers.firstWhere((answer) => answer.questionId == question.id).optionIds!.contains(option.id)
                            ? currentTheme.primaryColor
                            : currentTheme.primaryColor.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}