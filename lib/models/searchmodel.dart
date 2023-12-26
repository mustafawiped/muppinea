// ignore_for_file: camel_case_types

class searchUserDatas {
  final String username;
  final String pp;
  final String documentId;
  final String about;

  searchUserDatas(
      {required this.username,
      required this.pp,
      required this.documentId,
      required this.about});

  factory searchUserDatas.fromMap(Map<String, dynamic> map) {
    return searchUserDatas(
      username: map['username'] ?? '',
      pp: map['image'] ?? '',
      documentId: map['id'] ?? '',
      about: map['about'] ?? '',
    );
  }
}
