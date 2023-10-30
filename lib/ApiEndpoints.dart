import 'package:status_alert/status_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';

class ApiEndpoints {
  static const String BASE_URL = "http://localhost:8080/api";
  // static const String BASE_URL = "http://18.194.208.48:8080/api";

  //LOGIN/REGISTER
  static const String LOGIN_RINGO = "$BASE_URL/auth/login";
  static const String LOGIN_GOOGLE = "$BASE_URL/auth/login/google";
  static const String LOGIN_APPLE = "$BASE_URL/auth/login/apple";

  //ORGANISATION
  static const String GET_ORGANISATION = "$BASE_URL/organisations";

  //PHOTOS
  static const String GET_PHOTO = "$BASE_URL/photos";

  //TOKENS
  static const String REFRESH_TOKENS = "$BASE_URL/auth/refresh-token";

  //TICKETS
  static const String SCAN_TICKET = "$BASE_URL/tickets/scan";
  static const String VALIDATE_TICKET = "$BASE_URL/tickets/validate";
  static const String GET_TICKETS = "$BASE_URL/tickets";

  //EVENTS
  static String GET_UPCOMING_EVENTS = "$BASE_URL/events?startTimeMin=${getCurrentTimestamp()}&sort=startTime&dir=ASC&hostId=";
  static String GET_PAST_EVENTS = "$BASE_URL/events?startTimeMax=${getCurrentTimestamp()}&sort=startTime&dir=DESC&&hostId=";
}

String getCurrentTimestamp() {
  DateTime now = DateTime.now();
  String year = now.year.toString().padLeft(4, '0');
  String month = now.month.toString().padLeft(2, '0');
  String day = now.day.toString().padLeft(2, '0');
  String hour = now.hour.toString().padLeft(2, '0');
  String minute = now.minute.toString().padLeft(2, '0');

  String timestamp = '$year-$month-${day}T${hour}:$minute';
  return timestamp;
}

dynamic customJsonDecode(String responseBody) {
  return jsonDecode(utf8.decode(responseBody.codeUnits));
}

void showSuccessAlert(String? title, String? message, context) {
  StatusAlert.show(
    context,
    duration: Duration(seconds: 2),
    title: 'Success',
    subtitle: message,
    configuration: IconConfiguration(icon: CupertinoIcons.check_mark, size: MediaQuery.of(context).size.width * 0.3),
  );
}

void showErrorAlert(String? title, String? message, context) {
  StatusAlert.show(
    context,
    duration: Duration(seconds: 2),
    title: title,
    subtitle: message,
    configuration: IconConfiguration(icon: CupertinoIcons.exclamationmark_triangle, size: MediaQuery.of(context).size.width * 0.3),
  );
}

String convertHourTimestamp(String timestamp) {
  DateTime parsedDateTime = DateTime.parse('${timestamp}Z').toLocal();
  String formattedDate = parsedDateTime.day.toString();
  String formattedTime = '${parsedDateTime.hour.toString().padLeft(2, '0')}:${parsedDateTime.minute.toString().padLeft(2, '0')}';
  String formattedMonth;

  switch (parsedDateTime.month) {
    case 1:
      formattedMonth = 'Jan';
      break;
    case 2:
      formattedMonth = 'Feb';
      break;
    case 3:
      formattedMonth = 'Mar';
      break;
    case 4:
      formattedMonth = 'Apr';
      break;
    case 5:
      formattedMonth = 'May';
      break;
    case 6:
      formattedMonth = 'Jun';
      break;
    case 7:
      formattedMonth = 'Jul';
      break;
    case 8:
      formattedMonth = 'Aug';
      break;
    case 9:
      formattedMonth = 'Sep';
      break;
    case 10:
      formattedMonth = 'Oct';
      break;
    case 11:
      formattedMonth = 'Nov';
      break;
    case 12:
      formattedMonth = 'Dec';
      break;
    default:
      formattedMonth = '';
      break;
  }

  String formattedTimestamp = '$formattedMonth $formattedDate ${parsedDateTime.year}, $formattedTime';
  return formattedTimestamp;
}

bool isTimestampInThePast(String timestamp) {
  DateTime parsedDateTimeStart = DateTime.parse('${timestamp}Z').toLocal();
  parsedDateTimeStart = parsedDateTimeStart.add(Duration(hours: 3));
  DateTime now = DateTime.now();
  DateTime today = DateTime.parse(timestamp);

  if (now.isAfter(today)) {
    return true;
  } else {
    return false;
  }
}