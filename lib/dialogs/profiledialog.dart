import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:src/models/usermodel.dart';
import 'package:src/pages/profile/profilepage.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});

  final userData user;

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: const Color.fromARGB(255, 32, 32, 32),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        width: mq.width * .6,
        height: mq.height * .35,
        child: Stack(
          children: [
            // profile
            Positioned(
              top: mq.height * .07,
              left: mq.width * .12,
              child: Align(
                alignment: Alignment.center,
                child: profilePhotoWidget(mq),
              ),
            ),

            // user name
            Positioned(
              left: mq.width * .04,
              top: mq.height * .02,
              width: mq.width * .55,
              child: Text(
                user.username,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),

            // info
            Positioned(
              right: 8,
              top: 6,
              child: Align(
                  alignment: Alignment.topRight,
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfilePage(user: user)));
                    },
                    shape: const CircleBorder(),
                    minWidth: 0,
                    padding: const EdgeInsets.all(0),
                    child: const Icon(
                      Icons.info_outline,
                      color: Colors.blue,
                      size: 30,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget profilePhotoWidget(Size mq) {
    return user.image.isEmpty
        ? Container(
            width: mq.height * .2,
            height: mq.height * .2,
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.all(
                Radius.circular(mq.height * .1),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(mq.height * .1),
              ),
              child: Image.asset(
                "assets/images/default.png",
                width: mq.height * .5,
                height: mq.height * .5,
                fit: BoxFit.cover,
              ),
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(mq.height * .1)),
            child: CachedNetworkImage(
              width: mq.height * .23,
              height: mq.height * .23,
              fit: BoxFit.cover,
              imageUrl: user.image,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.error, size: 50),
            ),
          );
  }
}
