// ignore_for_file: camel_case_types

class notificationModel {
  final String user;
  final String header;
  final String desc;
  final String process;
  final String time;

  notificationModel(
      {required this.user,
      required this.header,
      required this.desc,
      required this.process,
      required this.time});

  factory notificationModel.fromMap(Map<String, dynamic> map) {
    return notificationModel(
      user: map['user'] ?? '',
      header: map['header'] ?? '',
      desc: map['desc'] ?? '',
      process: map['process'] ?? '',
      time: map['time'] ?? '',
    );
  }
}
