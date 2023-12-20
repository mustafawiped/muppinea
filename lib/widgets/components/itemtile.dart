import 'package:flutter/material.dart';

class ItemTile extends StatelessWidget {
  final String socialname;
  final String title;
  final VoidCallback onTap;
  const ItemTile({
    Key? key,
    required this.socialname,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: CircleAvatar(
              radius: 10,
              backgroundColor: Colors.transparent,
              child: Image.asset(
                'assets/socials/$socialname.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Spacer(),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.forward),
          )
        ],
      ),
    );
  }
}
