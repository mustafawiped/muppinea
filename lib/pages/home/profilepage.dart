import 'package:flutter/material.dart';
import 'package:src/models/usermodel.dart';

class ProfilePage extends StatefulWidget {
  final userData user;

  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 32, 32, 32),
      body: Center(
        child: Text(
          "Profile Page",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
