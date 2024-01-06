// Kullanıcı avatarı oluşturma
// ignore_for_file: camel_case_types

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class listAvatar extends StatelessWidget {
  final String filename;
  const listAvatar({
    super.key,
    required this.filename,
  });

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;

    return filename.isNotEmpty
        ? ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(mq.height * .3)),
            child: CachedNetworkImage(
              width: mq.height * .045,
              height: mq.height * .045,
              imageUrl: filename,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.error, size: 50),
            ),
          )
        : CircleAvatar(
            radius: 29,
            backgroundColor: Colors.white24,
            child: CircleAvatar(
              radius: 26,
              backgroundColor: Colors.blueGrey,
              backgroundImage: Image.asset("assets/images/default.png").image,
            ),
          );
  }
}
