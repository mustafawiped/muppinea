// ignore: camel_case_types, Hikaye oluşturma
import 'package:flutter/material.dart';
import 'package:src/widgets/components/useravatar.dart';

// ignore: camel_case_types
class createUserStatus extends StatelessWidget {
  final String filename;
  final String name;
  const createUserStatus({
    super.key,
    required this.filename,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: SizedBox(
        width: 60,
        height: 60,
        child: Column(
          children: [
            UserAvatar(filename: filename),
            const SizedBox(
              height: 5,
            ),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
