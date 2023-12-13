// Kullanıcı avatarı oluşturma
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String filename;
  const UserAvatar({
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
              width: mq.height * .065,
              height: mq.height * .065,
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
