/* ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:src/dialogs/loading.dart';
import 'package:src/services/apis/users.dart';
import 'package:src/services/auth/authservice.dart';
import 'package:src/services/shippers/emails.dart';
import 'package:src/widgets/components/inputs/emailTextfield.dart';
import 'package:src/widgets/components/inputs/passwordTextfield.dart';
import 'package:src/widgets/components/inputs/verifycodeTextfield.dart';

class EmailUpdate extends StatefulWidget {
  const EmailUpdate({super.key});

  @override
  State<EmailUpdate> createState() => _EmailUpdateState();
}

class _EmailUpdateState extends State<EmailUpdate> {
  TextEditingController verifyController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  int step = 1;
  int otherStep = 1;
  bool buttonEnabled = true;
  bool buttonLoading = false;

  // region for Email Input Controls  //
  bool emailErrorState = false;
  String emailErrorMessage = "";
  String newEmail = "";

  String removeConsecutiveUnderscores(String input) {
    RegExp regex = RegExp(r'_+');
    return input.replaceAll(regex, '_');
  }

  void emailErrorCatcher(String text) {
    List<String> words = text.split(' ');
    String email = words.where((word) => word.isNotEmpty).join(' ');
    text = removeConsecutiveUnderscores(email);
    emailController.text = text.toLowerCase();
    if (emailController.text == "") {
      setState(() {
        buttonEnabled = false;
        emailErrorState = true;
        emailErrorMessage = "Eposta boş olamaz.";
      });
    } else {
      setState(() {
        if (emailController.text.isNotEmpty &&
            (emailController.text.contains(".com") ||
                emailController.text.contains(".edu") ||
                emailController.text.contains(".gov")) &&
            emailController.text.contains("@")) {
          buttonEnabled = true;
        } else {
          buttonEnabled = false;
        }
        emailErrorState = false;
      });
    }
  }

  // region for Verify Code Input Controls  //
  bool verifyErrorState = false;
  String verifyErrorMessage = "";
  bool verifyTextEnabled = false;

  void verifyErrorCatcher(String text) {
    List<String> words = text.split(' ');
    String verify = words.where((word) => word.isNotEmpty).join(' ');
    text = verify;
    verifyController.text = text.toLowerCase();
    if (verifyController.text == "") {
      setState(() {
        buttonEnabled = false;
        verifyErrorState = true;
        verifyErrorMessage = "Onay kodu boş olamaz.";
      });
    } else {
      setState(() {
        if (verifyController.text.isNotEmpty) {
          buttonEnabled = true;
        } else {
          buttonEnabled = false;
        }
        verifyErrorState = false;
      });
    }
  }
  //endregion

// region for Password Input Controls //
  bool passwordErrorState = false;
  String passwordErrorMessage = "";
  bool isPasswordFieldVisible = false;

  void passwordErrorCatcher(String text) {
    List<String> words = text.split(' ');
    String password = words.where((word) => word.isNotEmpty).join(' ');
    text = password;
    if (passwordController.text == "") {
      setState(() {
        buttonEnabled = false;
        passwordErrorState = true;
        passwordErrorMessage = "Şifre boş olamaz.";
      });
    } else {
      setState(() {
        if (passwordController.text.isNotEmpty) {
          buttonEnabled = true;
        } else {
          buttonEnabled = false;
        }
        passwordErrorState = false;
      });
    }
  }

  GestureDetector passwordObs() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isPasswordFieldVisible = !isPasswordFieldVisible;
        });
      },
      child: Icon(
        isPasswordFieldVisible ? Icons.visibility : Icons.visibility_off,
        color: const Color.fromARGB(255, 32, 32, 32),
      ),
    );
  }
  //endregion

  void onButtonClick() {
    if (!buttonEnabled) return;
    if (step == 1 || step == 3) {
      step1_3Apply();
    } else if (step == 2) {
      step2Apply();
    } else {
      step4Apply();
    }
  }

  Future<void> step1_3Apply() async {
    setState(() {
      buttonLoading = true;
    });
    if (otherStep == 1) {
      await emailPass().verifyEmail(AuthService.me.email);
      setState(() {
        ++otherStep;
        buttonLoading = false;
        verifyTextEnabled = true;
      });
    } else {
      String verifyText = verifyController.text;
      bool state;
      try {
        state = emailPass().tryVerifyCode(int.parse(verifyText));
      } catch (e) {
        state = false;
      }
      if (state) {
        verifyController.clear();
        setState(() {
          buttonEnabled = false;
          buttonLoading = false;
          step++;
        });
      } else {
        setState(() {
          verifyErrorState = true;
          verifyErrorMessage = "Girilen kod hatalıdır.";
          buttonLoading = false;
          buttonEnabled = false;
        });
      }
    }
  }

  Future<void> step2Apply() async {
    String? email = emailController.text.trim();
    if (!emailErrorState) {
      setState(() {
        buttonLoading = true;
      });
      Future<bool> state = APIs.existsControl("email", email);
      state.then((value) async {
        if (value) {
          newEmail = email;
          await emailPass().verifyEmail(email);
          await AuthService.user.sendEmailVerification();
          setState(() {
            buttonLoading = false;
            buttonEnabled = true;
            step++;
          });
        } else {
          setState(() {
            buttonEnabled = false;
            emailErrorState = true;
            buttonLoading = false;
            emailErrorMessage = "Bu Eposta adresi zaten kullanılmaktadır.";
          });
        }
      });
    }
  }

  void step4Apply() async {
    String password = passwordController.text;
    loadingDilaog().show(context);
    try {
      await AuthService.auth
          .signInWithEmailAndPassword(
              email: AuthService.me.email, password: password)
          .then((userCredential) async {
        await AuthService.updateEmail(userCredential, newEmail);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      });
    } catch (e) {
      Navigator.of(context).pop();
      if (e is FirebaseException) {
        if (e.code == 'user-not-found') {
          passwordErrorMessage = "Bu epostaya sahip kullanıcı bulunamadı.";
          passwordErrorState = true;
        } else if (e.code == 'wrong-password' ||
            e.code == "invalid-credential") {
          passwordErrorMessage = "Şifre hatalı!";
          passwordErrorState = true;
        } else {
          passwordErrorMessage = "Bilinmeyen sebeplerden dolayı hata oluştu.";
          passwordErrorState = true;
        }
      }
      setState(() {
        buttonLoading = false;
      });
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    (step == 1)
                        ? "Eposta Adresini Güncelle"
                        : (step == 2)
                            ? "Yeni Eposta Adresi"
                            : (step == 3)
                                ? "Yenisini Doğrula"
                                : "Şifreni Doğrula",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    (step == 1)
                        ? "Hesabın sahibi olduğunu kanıtlaman için, şuanki eposta adresini onayla."
                        : (step == 2)
                            ? "Yeni eposta adresini yazman için harika bir fırsat."
                            : (step == 3)
                                ? "Yazdığın eposta adresine doğrulama kodu gönderildi!"
                                : "Merak etme! son aşama. hesabının güvenliği için bir de şifreni girer misin?",
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
    );
  }

  Widget getInput() {
    if (step == 1 || step == 3) {
      return createVerifyCodeTextfield(
          controller: verifyController,
          hintText: step == 1
              ? otherStep == 1
                  ? "Butona basarak kod gönderebilirsin."
                  : "Doğrulama Kodu giriniz"
              : "Doğrulama Kodu giriniz",
          changed: verifyErrorCatcher,
          errorState: verifyErrorState,
          enabled: verifyTextEnabled,
          errorText: verifyErrorMessage);
    } else if (step == 2) {
      return createEmailTextfield(
          controller: emailController,
          hintText: "Yeni eposta adresi",
          changed: emailErrorCatcher,
          errorState: emailErrorState,
          errorText: emailErrorMessage);
    } else {
      return createPasswordTextField(
          controller: passwordController,
          hintText: "Mevcut şifrenizi girin..",
          changed: passwordErrorCatcher,
          errorState: passwordErrorState,
          errorText: passwordErrorMessage,
          visibility: passwordObs(),
          obscureState: isPasswordFieldVisible);
    }
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
                  step == 1
                      ? otherStep == 1
                          ? "Doğrulama Kodu Gönder"
                          : "Doğrula"
                      : "Devam",
                  style: TextStyle(
                      color: (buttonEnabled == false)
                          ? Colors.grey
                          : Colors.white),
                ),
        ),
      ),
    );
  }
}
*/