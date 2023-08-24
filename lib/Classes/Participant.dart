class Participant {
  int id;
  String? email;
  String name;
  String username;
  int? profilePictureId;
  bool isActive;
  bool withIdProvider;
  String? dateOfBirth;
  String? gender;

  Participant({
    required this.id,
    this.email,
    required this.name,
    required this.username,
    required this.withIdProvider,
    this.profilePictureId,
    required this.isActive,
    this.dateOfBirth,
    this.gender,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      username: json['username'],
      withIdProvider: json['withIdProvider'],
      profilePictureId: json['profilePictureId'],
      isActive: json['isActive'],
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
    );
  }
}
