// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:src/dialogs/awesome.dart';
import 'package:src/dialogs/loading.dart';
import 'package:src/models/usermodel.dart';
import 'package:src/pages/profile/connects.dart';
import 'package:src/pages/profile/profilecnpr.dart';
import 'package:src/pages/profile/profileupdate.dart';
import 'package:src/services/apis/users.dart';
import 'package:src/services/auth/authservice.dart';

class ProfileEdit extends StatefulWidget {
  final userData user;

  const ProfileEdit({super.key, required this.user});

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  bool isMe = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1), () {
      initConfigures();
    });
  }

  void initConfigures() {
    isMe = widget.user.id == AuthService.me.id;
    setState(() {
      isLoading = false;
    });
  }

  void btnOnClick() {
    if (isMe) {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => ProfileEdit(user: widget.user)));
    }
  }

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
          actions: isMe
              ? null
              : [
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
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Column(
                      children: [
                        // profile photo
                        Stack(
                          children: [
                            profilePhotoWidget(mq),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: MaterialButton(
                                elevation: 1,
                                onPressed: () {
                                  photoBottomSheet(context);
                                },
                                color: Colors.white,
                                shape: const CircleBorder(),
                                child: const Icon(
                                  Icons.edit,
                                  color: Color.fromARGB(255, 32, 32, 32),
                                ),
                              ),
                            ),
                          ],
                        ),

                        //sizedbox
                        const SizedBox(
                          height: 24,
                        ),

                        //username
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const ProfileUpdate(step: 1)));
                          },
                          child: itemProfile("Kullanıcı Adı",
                              widget.user.username, Icons.person),
                        ),

                        //sizedbox
                        const SizedBox(
                          height: 24,
                        ),

                        // about
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const ProfileUpdate(step: 2)));
                          },
                          child: itemProfile(
                              "Hakkında", widget.user.about, Icons.info),
                        ),

                        //sizedbox
                        const SizedBox(
                          height: 24,
                        ),

                        // socials
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const ProfileConnectionsInfo(step: 1)));
                          },
                          child: itemProfile("Bağlantılar",
                              "Bağlantılar Ekleyin / Kaldırın", Icons.share),
                        ),

                        //sizedbox
                        const SizedBox(
                          height: 24,
                        ),

                        // pronouns
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const ProfileOtherEdits(
                                          step: 2,
                                          social: '',
                                        )));
                          },
                          child: itemProfile(
                              "Hitaplar",
                              "Hitaplar ekleyin / kaldırın",
                              Icons.library_books),
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

  itemProfile(String title, String subtitle, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 5),
              color: Colors.white.withOpacity(.1),
              spreadRadius: 2,
              blurRadius: 10,
            )
          ]),
      child: ListTile(
        title: Text(
          title,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        leading: Icon(
          iconData,
          color: Colors.white,
        ),
        trailing: const Icon(Icons.arrow_upward, color: Colors.white),
        tileColor: Colors.transparent,
      ),
    );
  }

  // photo select from profile edit
  void photoBottomSheet(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    showModalBottomSheet(
        backgroundColor: const Color.fromARGB(255, 32, 32, 32),
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .02, bottom: mq.height * .05),
            children: [
              // black divider
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(
                    vertical: mq.height * .015, horizontal: mq.width * .4),
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(8)),
              ),

              // header
              const Text(
                "Fotoğrafı nereden almamızı istersin?",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),

              // header and items between's empty
              SizedBox(
                height: mq.height * .02,
              ),

              // items
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // pick from gallery button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const CircleBorder(),
                        fixedSize: Size(mq.width * .3, mq.height * .15),
                      ),
                      onPressed: () async {
                        // Pick an image.
                        final picker = ImagePicker();
                        var pickedFile = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 80);
                        if (pickedFile != null) {
                          final croppedFile = await ImageCropper().cropImage(
                            sourcePath: pickedFile.path,
                            compressFormat: ImageCompressFormat.jpg,
                            compressQuality: 70,
                            aspectRatioPresets: [
                              CropAspectRatioPreset.square,
                            ],
                            uiSettings: [
                              AndroidUiSettings(
                                  toolbarTitle: 'Muppin | Resim Düzenleyici',
                                  toolbarColor:
                                      const Color.fromARGB(255, 32, 36, 47),
                                  toolbarWidgetColor:
                                      const Color.fromARGB(255, 220, 220, 220),
                                  initAspectRatio:
                                      CropAspectRatioPreset.original,
                                  lockAspectRatio: false),
                            ],
                          );
                          if (croppedFile != null) {
                            Navigator.pop(context);
                            loadingDilaog().show(context);
                            await APIs.updateProfilePicture(
                                File(croppedFile.path));
                            Navigator.pop(context);
                            awesomeDialog().show(
                                context,
                                "Başarılı!",
                                "Başarıyla Profil Fotoğrafı güncellendi! Değişikliklerin uygulanması biraz zaman alabilir.",
                                "",
                                "Tamam!",
                                DialogType.success,
                                null, () {
                              setState(() {});
                            });
                          } else {
                            awesomeDialog().show(
                                context,
                                "Başarısız.",
                                "Bir şeyler ters gitti, profil fotoğrafı güncellenemedi.",
                                "Tamam",
                                "",
                                DialogType.error,
                                () {},
                                null);
                          }
                        } else {
                          awesomeDialog().show(
                              context,
                              "Başarısız.",
                              "Bir şeyler ters gitti, profil fotoğrafı güncellenemedi.",
                              "Tamam",
                              "",
                              DialogType.error,
                              () {},
                              null);
                        }
                      },
                      child: Image.asset("assets/images/gallery.png")),

                  // pick from camera button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const CircleBorder(),
                        fixedSize: Size(mq.width * .3, mq.height * .15),
                      ),
                      onPressed: () async {
                        // Pick an image.
                        final picker = ImagePicker();
                        var pickedFile = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 80);
                        if (pickedFile != null) {
                          final croppedFile = await ImageCropper().cropImage(
                            sourcePath: pickedFile.path,
                            compressFormat: ImageCompressFormat.jpg,
                            compressQuality: 70,
                            aspectRatioPresets: [
                              CropAspectRatioPreset.square,
                            ],
                            uiSettings: [
                              AndroidUiSettings(
                                  toolbarTitle: 'Muppin | Resim Düzenleyici',
                                  toolbarColor:
                                      const Color.fromARGB(255, 32, 36, 47),
                                  toolbarWidgetColor:
                                      const Color.fromARGB(255, 220, 220, 220),
                                  initAspectRatio:
                                      CropAspectRatioPreset.original,
                                  lockAspectRatio: false),
                            ],
                          );
                          if (croppedFile != null) {
                            Navigator.pop(context);
                            loadingDilaog().show(context);
                            await APIs.updateProfilePicture(
                                File(croppedFile.path));
                            Navigator.pop(context);
                            awesomeDialog().show(
                                context,
                                "Başarılı!",
                                "Başarıyla Profil Fotoğrafı güncellendi! Değişikliklerin uygulanması biraz zaman alabilir.",
                                "",
                                "Tamam!",
                                DialogType.success,
                                null, () {
                              setState(() {});
                            });
                          } else {
                            awesomeDialog().show(
                                context,
                                "Başarısız.",
                                "Bir şeyler ters gitti, profil fotoğrafı güncellenemedi.",
                                "Tamam",
                                "",
                                DialogType.error,
                                () {},
                                null);
                          }
                        } else {
                          awesomeDialog().show(
                              context,
                              "Başarısız.",
                              "Bir şeyler ters gitti, profil fotoğrafı güncellenemedi.",
                              "Tamam",
                              "",
                              DialogType.error,
                              () {},
                              null);
                        }
                      },
                      child: Image.asset("assets/images/camera.png")),
                ],
              )
            ],
          );
        });
  }
}
