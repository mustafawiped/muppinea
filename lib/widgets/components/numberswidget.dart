// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

class NumbersWidget extends StatelessWidget {
  final String friendCount;
  final String popularity;
  final String badgeCount;

  const NumbersWidget(
      {super.key,
      required this.friendCount,
      required this.popularity,
      required this.badgeCount});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildButton(context, friendCount, 'Arkadaşlar'),
          buildDivider(),
          buildButton(context, popularity, 'Popülerlik'),
          buildDivider(),
          buildButton(context, badgeCount, 'Rozetler'),
        ],
      );
  Widget buildDivider() => Container(
        height: 24,
        child: const VerticalDivider(),
      );

  Widget buildButton(BuildContext context, String value, String text) =>
      MaterialButton(
        padding: const EdgeInsets.symmetric(vertical: 4),
        onPressed: () {},
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white),
            ),
            const SizedBox(height: 2),
            Text(
              text,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      );
}
