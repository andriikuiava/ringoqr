import 'package:ringoqr/Classes/Event.dart';
import 'package:ringoqr/Classes/Participant.dart';

class Ticket {
  Participant participant;
  Event? event;
  String timeOfSubmission;
  String expiryDate;
  bool isValidated;
  String? ticketCode;
  RegistrationForm? registrationForm;
  RegistrationSubmission? registrationSubmission;


  Ticket({
    required this.participant,
    this.event,
    required this.timeOfSubmission,
    required this.expiryDate,
    required this.isValidated,
    this.ticketCode,
    this.registrationForm,
    this.registrationSubmission
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      participant: Participant.fromJson(json['participant']),
      event: json['event'] != null ? Event.fromJson(json['event']) : null,
      timeOfSubmission: json['timeOfSubmission'],
      expiryDate: json['expiryDate'],
      isValidated: json['isValidated'],
      ticketCode: json['ticketCode'],
      registrationForm: json['registrationForm'] != null ? RegistrationForm.fromJson(json['registrationForm']) : null,
      registrationSubmission: json['registrationSubmission'] != null ? RegistrationSubmission.fromJson(json['registrationSubmission']) : null,
    );
  }
}


class RegistrationCredentials {
  String name;
  String username;
  String email;
  String password;
  String dateOfBirth;
  String gender;

  RegistrationCredentials({
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    required this.dateOfBirth,
    required this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'email': email,
      'password': password,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
    };
  }
}


class RegistrationForm {
  String title;
  String? description;
  List<Question> questions;

  RegistrationForm({
    required this.title,
    this.description,
    required this.questions,
  });

  factory RegistrationForm.fromJson(Map<String, dynamic> json) {
    return RegistrationForm(
      title: json['title'],
      description: json['description'],
      questions: List<Question>.from(
        json['questions'].map((question) => Question.fromJson(question)),
      ),
    );
  }
}

class Question {
  int id;
  String content;
  bool required;
  bool? multipleOptionsAllowed;
  String type;
  int? maxCharacters;
  List<Option>? options;


  Question({
    required this.id,
    required this.content,
    required this.required,
    required this.multipleOptionsAllowed,
    required this.type,
    required this.maxCharacters,
    this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      content: json['content'],
      required: json['required'],
      multipleOptionsAllowed: json['multipleOptionsAllowed'],
      type: json['type'],
      maxCharacters: json['maxCharacters'],
      options: json['options'] != null
          ? List<Option>.from(
        json['options'].map((option) => Option.fromJson(option)),
      )
          : null,
    );
  }
}

class Option {
  int id;
  String content;

  Option({
    required this.id,
    required this.content,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['id'],
      content: json['content'],
    );
  }
}

class Answer {
  int questionId;
  String? content;
  List<int>? optionIds;

  Answer({
    required this.questionId,
    this.content,
    this.optionIds,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      questionId: json['questionId'],
      content: json['content'],
      optionIds: json['optionIds'] != null ? List<int>.from(json['optionIds']) : null,
    );
  }
}

class RegistrationSubmission {
  List<Answer>? answers;

  RegistrationSubmission({
    this.answers,
  });

  factory RegistrationSubmission.fromJson(Map<String, dynamic> json) {
    List<dynamic>? answersJson = json['answers'];

    List<Answer>? answers;
    if (answersJson != null) {
      answers = answersJson.map((answerJson) {
        return Answer.fromJson(answerJson);
      }).toList();
    }

    return RegistrationSubmission(answers: answers);
  }
}