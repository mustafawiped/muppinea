// ignore_for_file: use_build_context_synchronously,

import 'package:flutter/material.dart';
import 'package:src/dialogs/loading.dart';
import 'package:src/services/apis/users.dart';
import 'package:src/services/auth/authservice.dart';
import 'package:src/widgets/utils/noglowscroll.dart';

class ProfileOtherEdits extends StatefulWidget {
  const ProfileOtherEdits(
      {super.key, required this.step, required this.social});
  final int step;
  final String social;

  @override
  State<ProfileOtherEdits> createState() => _ProfileOtherEditsState();
}

class _ProfileOtherEditsState extends State<ProfileOtherEdits> {
  bool buttonEnabled = false;
  bool buttonLoading = false;

  TextEditingController textController = TextEditingController();
  bool textErrorState = false;
  String textErrorText = "";

  void onButtonClick() async {
    if (!buttonEnabled || buttonLoading) return;
    if (widget.step == 1) {
      String text = textController.text.trim();
      if (text.isEmpty) {
        Map map = AuthService.me.socials;
        if (map.containsKey(widget.social)) {
          loadingDilaog().show(context);
          map.remove(widget.social);
          await APIs.updateUserInfo("socials", map);
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        } else {
          setState(() {
            textErrorState = true;
            textErrorText = "Zaten bu sosyal medya hesabını kaldırmışsın.";
          });
        }
      } else {
        Map map = AuthService.me.socials;
        loadingDilaog().show(context);
        map[widget.social] = text;
        await APIs.updateUserInfo("socials", map);

        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
    } else {
      loadingDilaog().show(context);
      String pronouns =
          textController.text.trim().isNotEmpty ? textController.text : "";
      await APIs.updateUserInfo("pronouns", pronouns);
      AuthService.me.pronouns = pronouns;
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1), () {
      if (widget.step == 1) {
        textController.text = AuthService.me.socials.containsKey(widget.social)
            ? AuthService.me.socials[widget.social].toString()
            : "";
      } else {
        textController.text = AuthService.me.pronouns.isNotEmpty
            ? AuthService.me.pronouns.toString()
            : "";
      }
    });
  }

  void onChanged(String e) {
    if (textController.text == "") {
      setState(() {
        buttonEnabled = true;
        textErrorState = false;
      });
    } else {
      if (textController.text.length <= 3) {
        setState(() {
          buttonEnabled = false;
          textErrorState = true;
          textErrorText = "Lütfen geçerli bir metin değeri girin. ";
        });
      } else {
        setState(() {
          buttonEnabled = true;
          textErrorState = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 32, 32, 32),
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Center(
          child: ScrollConfiguration(
            behavior: NoGlowScrollBehavior().copyWith(overscroll: false),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      (widget.step == 1)
                          ? "${widget.social} 'da kullandığın kullanıcı adını/linki aşağıya yazabilirsin.\nEğer kaldırmak istiyorsan boş bırak ve kaydet butonuna bas."
                          : "Kendine hitaplar ekle, bu hitaplar sohbet profilinde gözükecek.",
                      style: const TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),

                    // sizedbox
                    const SizedBox(
                      height: 25,
                    ),

                    // input
                    getInput(),

                    // sizedbox
                    const SizedBox(
                      height: 10,
                    ),

                    // next button
                    createButton(),

                    // sizedbox
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget createButton() {
    return SizedBox(
      width: double.infinity,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: (buttonEnabled == false)
                ? const Color.fromARGB(154, 73, 47, 85)
                : const Color.fromARGB(154, 195, 90, 255),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          onPressed: buttonLoading ? null : onButtonClick,
          child: buttonLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 159, 159, 159)),
                  ),
                )
              : Text(
                  "Kaydet",
                  style: TextStyle(
                      color: (buttonEnabled == false)
                          ? Colors.grey
                          : Colors.white),
                ),
        ),
      ),
    );
  }

  Widget getInput() {
    if (widget.step == 1) {
      if (widget.social == "instagram") {
        return TextFormField(
          controller: textController,
          maxLength: 30,
          onChanged: onChanged,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixText: "@",
            labelText: "Instagram Hesabın",
            hintText: "muppinapp",
            labelStyle: const TextStyle(color: Colors.white),
            filled: true,
            fillColor: const Color.fromARGB(255, 54, 54, 54),
            hintStyle: const TextStyle(color: Colors.grey),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10.0),
            ),
            counterText: "",
            errorText: textErrorState ? textErrorText : null,
          ),
        );
      } else if (widget.social == "twitter") {
        return TextFormField(
          controller: textController,
          maxLength: 30,
          onChanged: onChanged,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixText: "@",
            labelText: "X Hesabın",
            hintText: "muppinapp",
            labelStyle: const TextStyle(color: Colors.white),
            filled: true,
            fillColor: const Color.fromARGB(255, 54, 54, 54),
            hintStyle: const TextStyle(color: Colors.grey),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10.0),
            ),
            counterText: "",
            errorText: textErrorState ? textErrorText : null,
          ),
        );
      } else if (widget.social == "youtube") {
        return TextFormField(
          controller: textController,
          maxLength: 30,
          onChanged: onChanged,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixText: "youtube.com/@",
            labelText: "Youtube Hesabın",
            hintText: "muppinapp",
            labelStyle: const TextStyle(color: Colors.white),
            filled: true,
            fillColor: const Color.fromARGB(255, 54, 54, 54),
            hintStyle: const TextStyle(color: Colors.grey),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10.0),
            ),
            counterText: "",
            errorText: textErrorState ? textErrorText : null,
          ),
        );
      } else {
        return TextFormField(
          controller: textController,
          maxLength: 30,
          onChanged: onChanged,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixText: "discord.gg/",
            labelText: "Sunucu Linkin",
            labelStyle: const TextStyle(color: Colors.white),
            filled: true,
            fillColor: const Color.fromARGB(255, 54, 54, 54),
            hintStyle: const TextStyle(color: Colors.grey),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10.0),
            ),
            counterText: "",
            errorText: textErrorState ? textErrorText : null,
          ),
        );
      }
    } else {
      return TextFormField(
        controller: textController,
        maxLength: 15,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: "Hitaplar",
          labelStyle: const TextStyle(color: Colors.white),
          filled: true,
          fillColor: const Color.fromARGB(255, 54, 54, 54),
          hintStyle: const TextStyle(color: Colors.grey),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
          counterText: "",
          errorText: textErrorState ? textErrorText : null,
        ),
      );
    }
  }
}
