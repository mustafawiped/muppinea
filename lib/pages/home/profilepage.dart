import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:src/models/usermodel.dart';
import 'package:src/services/shippers/badges.dart';
import 'package:src/widgets/components/numberswidget.dart';
import 'package:src/widgets/utils/times.dart';

class ProfilePage extends StatefulWidget {
  final userData user;

  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 32, 32, 32),
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.white,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ))
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  // profile photo
                  profilePhotoWidget(mq),

                  //sizedbox
                  const SizedBox(
                    height: 24,
                  ),

                  //name and mail
                  buildName(),

                  //sized box
                  const SizedBox(
                    height: 24,
                  ),

                  //add friend button
                  buildAddFriendButton("Arkadaş Ekle", () {}),

                  //sized box
                  const SizedBox(height: 24),

                  //friends and popularity
                  NumbersWidget(
                      friendCount: "0",
                      popularity: "1.0",
                      badgeCount: widget.user.badges.length.toString()),

                  //sized box
                  const SizedBox(
                    height: 24,
                  ),

                  //about
                  buildAbout(),

                  //sized box
                  const SizedBox(
                    height: 24,
                  ),

                  //badges
                  if (widget.user.badges.isNotEmpty) buildBadges(),

                  //sizedbox
                  if (widget.user.badges.isNotEmpty)
                    const SizedBox(
                      height: 24,
                    ),

                  //joined date
                  buildJoined(),

                  //sizedbox
                  if (widget.user.socials.isNotEmpty)
                    const SizedBox(
                      height: 24,
                    ),

                  //socials
                  if (widget.user.socials.isNotEmpty) buildSocials(),

                  //sizedbox
                  if (widget.user.socials.isNotEmpty)
                    const SizedBox(
                      height: 24,
                    ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget profilePhotoWidget(Size mq) {
    return widget.user.image.isEmpty
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
                width: mq.height * .2,
                height: mq.height * .2,
                fit: BoxFit.cover,
              ),
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(mq.height * .1)),
            child: CachedNetworkImage(
              width: mq.height * .2,
              height: mq.height * .2,
              fit: BoxFit.cover,
              imageUrl: widget.user.image,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.error, size: 50),
            ),
          );
  }

  Widget buildName() {
    return Column(
      children: [
        Text(
          widget.user.username,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(
          widget.user.email,
          style: const TextStyle(color: Colors.grey),
        )
      ],
    );
  }

  Widget buildAddFriendButton(String text, VoidCallback onClicked) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey,
        foregroundColor: const Color.fromARGB(255, 32, 32, 32),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      ),
      onPressed: onClicked,
      child: Text(text),
    );
  }

  Widget buildAbout() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hakkında',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(
            widget.user.about,
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
              color: Colors.grey,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget buildBadges() {
    List userBadges = widget.user.badges;

    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rozetler',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          buildBadgeIcons(userBadges),
        ],
      ),
    );
  }

  Widget buildBadgeIcons(List userBadges) {
    if (userBadges.isEmpty) {
      return const Row();
    }
    return Row(
      children: userBadges.map((badgeIndex) {
        return Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: buildBadgeIcon(badgeIndex),
        );
      }).toList(),
    );
  }

  Widget buildBadgeIcon(int badgeIndex) {
    return CircleAvatar(
      radius: 14,
      backgroundColor: Colors.transparent,
      child: Image.asset(
        Badges().allBadges[badgeIndex],
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildJoined() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Katılım Tarihi',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(
            DateUtil.getJoinedDate(
                context: context, lastActive: widget.user.createdAt),
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
              color: Colors.grey,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget buildSocials() {
    Map socials = widget.user.socials;

    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bağlantılar',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          buildSocialIcons(socials),
        ],
      ),
    );
  }

  Widget buildSocialIcons(Map userSocials) {
    List<String> socialPlatforms = [
      'instagram',
      'twitter',
      'youtube',
      'discord'
    ];
    List<Widget> socialIcons = [];
    for (String platform in socialPlatforms) {
      if (userSocials.containsKey(platform) && userSocials[platform] != null) {
        socialIcons.add(buildSocialIcon(platform));
      }
    }
    return Row(
      children: socialIcons,
    );
  }

  Widget buildSocialIcon(String platform) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: CircleAvatar(
        radius: 14,
        backgroundColor: Colors.transparent,
        child: Image.asset(
          'assets/socials/$platform.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
