import 'package:ringoqr/Classes/Event.dart';
import 'package:ringoqr/Classes/Participant.dart';

class Ticket {
  Participant participant;
  Event? event;
  String timeOfSubmission;
  String expiryDate;
  bool isValidated;
  String? ticketCode;

  Ticket({
    required this.participant,
    this.event,
    required this.timeOfSubmission,
    required this.expiryDate,
    required this.isValidated,
    this.ticketCode,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      participant: Participant.fromJson(json['participant']),
      event: json['event'] != null ? Event.fromJson(json['event']) : null,
      timeOfSubmission: json['timeOfSubmission'],
      expiryDate: json['expiryDate'],
      isValidated: json['isValidated'],
      ticketCode: json['ticketCode'],
    );
  }
}
