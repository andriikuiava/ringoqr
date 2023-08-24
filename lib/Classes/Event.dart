import 'package:ringoqr/Classes/Coordinates.dart';
import 'package:ringoqr/Classes/Category.dart';
import 'package:ringoqr/Classes/Currency.dart';

class Event {
  int? id;
  String name;
  String? description;
  bool isActive;
  String? address;
  Coordinates? coordinates;
  int? mainPhotoId;
  int? distance;
  bool isTicketNeeded;
  double? price;
  Currency? currency;
  String? startTime;
  String? endTime;
  List<Category>? categories;
  int? hostId;
  int peopleCount;
  int capacity;

  Event({
    this.id,
    required this.name,
    this.description,
    required this.isActive,
    this.address,
    this.coordinates,
    this.mainPhotoId,
    this.distance,
    required this.isTicketNeeded,
    this.price,
    this.currency,
    this.startTime,
    this.endTime,
    this.categories,
    this.hostId,
    required this.peopleCount,
    required this.capacity,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    List<Category>? categories;
    if (json['categories'] != null) {
      categories = List<Category>.from(
          json['categories'].map((x) => Category.fromJson(x)));
    }

    return Event(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      isActive: json['isActive'],
      address: json['address'],
      coordinates: json['coordinates'] != null
          ? Coordinates.fromJson(json['coordinates'])
          : null,
      mainPhotoId: json['mainPhotoId'],
      distance: json['distance'],
      isTicketNeeded: json['isTicketNeeded'],
      price: json['price'],
      currency: json['currency'] != null
          ? Currency.fromJson(json['currency'])
          : null,
      startTime: json['startTime'],
      endTime: json['endTime'],
      categories: categories,
      hostId: json['hostId'],
      peopleCount: json['peopleCount'],
      capacity: json['capacity'],
    );
  }
}