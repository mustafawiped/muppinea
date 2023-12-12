// ignore: file_names
class userData {
  late String id;
  late String username;
  late String email;
  late String about;
  late String image;
  late String createdAt;
  late String lastActive;
  late String pushToken;
  late List badges;
  late Map socials;
  late String pronouns;
  late bool security;
  late bool isOnline;

  userData(
      {required this.about,
      required this.createdAt,
      required this.email,
      required this.id,
      required this.image,
      required this.isOnline,
      required this.lastActive,
      required this.username,
      required this.badges,
      required this.pronouns,
      required this.security,
      required this.socials,
      required this.pushToken});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "username": username,
      "email": email,
      "about": about,
      "image": image,
      "createdAt": createdAt,
      "lastActive": lastActive,
      "pushToken": pushToken,
      "badges": badges,
      "socials": socials,
      "pronouns": pronouns,
      "security": security,
      "isOnline": isOnline
    };
  }

  userData.fromMap(Map<String, dynamic> json) {
    id = json["id"] ?? "";
    username = json["username"] ?? "";
    email = json["email"] ?? "";
    about = json["about"] ?? "";
    image = json["image"] ?? "";
    createdAt = json["createdAt"] ?? "";
    lastActive = json["lastActive"] ?? "";
    pushToken = json["pushToken"] ?? "";
    badges = json["badges"] ?? [];
    socials = json["socials"] ?? {};
    pronouns = json["pronouns"] ?? "";
    security = json["security"] ?? false;
    isOnline = json["isOnline"] ?? false;
  }
}
