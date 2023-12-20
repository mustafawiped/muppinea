// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:src/dialogs/awesome.dart';
import 'package:src/dialogs/loading.dart';
import 'package:src/services/apis/users.dart';
import 'package:src/services/auth/authservice.dart';
import 'package:src/services/shippers/emails.dart';
import 'package:src/widgets/components/inputs/emailTextfield.dart';
import 'package:src/widgets/components/inputs/passwordTextfield.dart';
import 'package:src/widgets/components/inputs/usernameTextfield.dart';
import 'package:src/widgets/components/inputs/verifycodeTextfield.dart';
import 'package:src/widgets/utils/noglowscroll.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late String rgUsername, rgPassword, rgEmail, rgVerify;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController verifyController = TextEditingController();

  bool buttonLoading = false;
  bool buttonEnabled = false;

  int step = 1;

  // Butona tıklayınca olanlar
  void onLoginButtonClick() {
    if (!buttonEnabled) return;
    setState(() {
      buttonLoading = true;
    });
    if (step == 1) {
      usernameNext();
    } else if (step == 2) {
      passwordNext();
    } else if (step == 3) {
      emailNext();
    } else if (step == 4) {
      verifyNext();
    }
  }

  void usernameNext() {
    String? userName = usernameController.text.trim();
    if (containsAtLeastTwoLetters(userName)) {
      Future<bool> state = APIs.existsControl("username", userName);
      state.then((value) {
        if (value) {
          rgUsername = userName;
          setState(() {
            buttonLoading = false;
            buttonEnabled = true;
            step++;
          });
        } else {
          setState(() {
            buttonEnabled = false;
            usernameErrorState = true;
            buttonLoading = false;
            usernameErrorMessage = "Bu kullanıcı adı zaten kullanılmaktadır.";
          });
        }
      });
    } else {
      setState(() {
        buttonEnabled = false;
        usernameErrorState = true;
        buttonLoading = false;
        usernameErrorMessage = "Kullanıcı adı minimum 3 harf içermeli.";
      });
    }
  }

  void passwordNext() {
    if (!passwordErrorState) {
      rgPassword = passwordController.text;
      setState(() {
        buttonLoading = false;
        buttonEnabled = true;
        step++;
      });
    }
  }

  void emailNext() {
    String? email = emailController.text.trim();
    if (!emailErrorState) {
      Future<bool> state = APIs.existsControl("email", email);
      state.then((value) async {
        if (value) {
          rgEmail = email;
          await emailPass().registerCodePass(email);
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

  void verifyNext() async {
    if (!verifyErrorState) {
      String verifyCode = verifyController.text;
      int? code = int.tryParse(verifyCode);
      if (code != null) {
        bool state = emailPass().tryVerifyCode(code);
        if (state) {
          loadingDilaog().show(context);
          awesomeDialog().show(
              context,
              "Dikkat!",
              "Muppin'e kayıt olmuş herkes Kullanım Koşulları ve Gizlilik Politikasını kabul etmiş sayılır.",
              "Evet, Farkındayım.",
              "Sözleşmeyi Göster",
              DialogType.info, () async {
            await AuthService.signUpWithEmailandPassword(
                    rgEmail, rgPassword, rgUsername, "")
                .then((value) {
              if (value) {
                Navigator.pop(context);
                Navigator.pop(context);
              } else {
                Navigator.pop(context);
                awesomeDialog().show(
                    context,
                    "Hata!",
                    "Bir şeyler ters gitti. Sonra tekrar dene.",
                    "Tamam",
                    "",
                    DialogType.error, () {
                  setState(() {
                    buttonLoading = false;
                  });
                }, null);
              }
            });
          }, () {});
        } else {
          setState(() {
            buttonEnabled = false;
            buttonLoading = false;
            verifyErrorState = true;
            verifyErrorMessage = "Girilen onay kodu yanlış.";
          });
        }
      } else {
        setState(() {
          buttonEnabled = false;
          buttonLoading = false;
          verifyErrorState = true;
          verifyErrorMessage = "Lütfen geçerli bir onay kodu girin.";
        });
      }
    }
  }

  void onGoogleSignInButtonClick() async {
    loadingDilaog().show(context);
    await GoogleSignIn().signOut();
    getGoogleUserInfo();
  }

  bool containsAtLeastTwoLetters(String input) {
    int letterCount = 0;

    for (int i = 0; i < input.length; i++) {
      if (isLetter(input[i])) {
        letterCount++;

        if (letterCount >= 2) {
          return true;
        }
      }
    }
    return false;
  }

  bool isLetter(String character) {
    return RegExp(r'[a-zA-Z]').hasMatch(character);
  }

  // region for Username Input Controls  //
  bool usernameErrorState = false;
  String usernameErrorMessage = "";

  void usernameErrorCatcher(String text) {
    List<String> words = text.split(' ');
    String username = words.where((word) => word.isNotEmpty).join(' ');
    text = removeConsecutiveUnderscores(username);
    usernameController.text = text.toLowerCase();
    if (usernameController.text == "") {
      setState(() {
        buttonEnabled = false;
        usernameErrorState = true;
        usernameErrorMessage = "Kullanıcı adı boş olamaz.";
      });
    } else {
      setState(() {
        if (usernameController.text.length > 3) {
          buttonEnabled = true;
        } else {
          buttonEnabled = false;
        }
        usernameErrorState = false;
      });
    }
  }

  String removeConsecutiveUnderscores(String input) {
    RegExp regex = RegExp(r'_+');
    return input.replaceAll(regex, '_');
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
  //endregion

  Future<void> getGoogleUserInfo() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Check if the user canceled the sign-in
      if (googleUser == null) {
        await GoogleSignIn().signOut();
        Navigator.pop(context);
        return;
      }

      // E-posta ve profil fotoğrafı bilgilerini al
      await googleUser.authentication;
      final userEmail = googleUser.email;
      final photoURL = googleUser.photoUrl ?? "";

      // giriş yapacak hesabı açacak.
      awesomeDialog().show(
          context,
          "Dikkat!",
          "Muppin'e kayıt olmuş herkes Kullanım Koşulları ve Gizlilik Politikasını kabul etmiş sayılır.",
          "Evet, Farkındayım.",
          "Sözleşmeyi Göster",
          DialogType.info, () async {
        await AuthService.signUpWithEmailandPassword(
                userEmail, rgPassword, rgUsername, photoURL)
            .then((value) {
          if (value) {
            Navigator.pop(context);
            Navigator.pop(context);
          } else {
            Navigator.pop(context);
            setState(() {
              buttonEnabled = false;
              emailErrorState = true;
              emailErrorMessage = "Bu eposta zaten kullanılmaktadır.";
            });
          }
        });
      }, () {});
    } catch (e) {
      Navigator.pop(context);
      await GoogleSignIn().signOut();
      awesomeDialog().show(
          context,
          "Bir şeyler ters gitti",
          "Lütfen internet bağlantınızı kontrol edin.",
          "Tamam",
          "",
          DialogType.error,
          () {},
          null);
      // Handle error
    }
  }

  // region for Email Input Controls  //
  bool emailErrorState = false;
  String emailErrorMessage = "";

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
  //endregion

  // region for Verify Code Input Controls  //
  bool verifyErrorState = false;
  String verifyErrorMessage = "";

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 32, 32, 32),
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
                    // Login Top Banner
                    Text(
                      (step == 1)
                          ? "Kullanıcı Adını Ayarla"
                          : (step == 2)
                              ? "Şifre Oluştur"
                              : (step == 3)
                                  ? "Eposta Adresini Gir"
                                  : "Doğrulama Kodunu Gir",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      (step == 1)
                          ? "İstediğin zaman kullanıcı adını değiştirebilirsin."
                          : (step == 2)
                              ? "şifrenin uzunluğu min 6 karakter olmalı."
                              : (step == 3)
                                  ? "Epostanı dikkatli seç! sonradan doğrulaman gerekecek."
                                  : "Kod 5 dakika sonra geçersiz hale gelecek.",
                      style: const TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),

                    // sizedbox
                    const SizedBox(
                      height: 25,
                    ),

                    // input
                    _getInput(),

                    // sizedbox
                    const SizedBox(
                      height: 10,
                    ),

                    // next button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(child: createButton()),
                        if (step == 3) const SizedBox(width: 10),
                        if (step == 3)
                          Expanded(child: createGoogleSignInButton()),
                      ],
                    ),

                    // sizedbox
                    const SizedBox(
                      height: 15,
                    ),

                    // divider
                    const Divider(
                      color: Colors.grey,
                    ),

                    // sizedbox
                    const SizedBox(
                      height: 15,
                    ),

                    createBottomLabel("Zaten hesabın var mı?", "Giriş Yap", () {
                      Navigator.of(context).pop();
                    }),

                    // sizedbox
                    const SizedBox(
                      height: 50,
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
          onPressed: buttonLoading ? null : onLoginButtonClick,
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
                  "Devam",
                  style: TextStyle(
                      color: (buttonEnabled == false)
                          ? Colors.grey
                          : Colors.white),
                ),
        ),
      ),
    );
  }

  Widget createGoogleSignInButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: onGoogleSignInButtonClick,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "G",
              style: TextStyle(color: Color.fromARGB(255, 66, 133, 244)),
            ),
            Text(
              "o",
              style: TextStyle(color: Color.fromARGB(255, 219, 68, 55)),
            ),
            Text(
              "o",
              style: TextStyle(color: Color.fromARGB(255, 244, 180, 0)),
            ),
            Text(
              "g",
              style: TextStyle(color: Color.fromARGB(255, 66, 133, 244)),
            ),
            Text(
              "l",
              style: TextStyle(color: Color.fromARGB(255, 52, 168, 83)),
            ),
            Text(
              "e",
              style: TextStyle(color: Color.fromARGB(255, 219, 68, 55)),
            ),
            Text(
              " ile Onayla",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget createBottomLabel(
      String firstString, String otherString, Function()? click) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          firstString,
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(
          width: 5,
        ),
        InkWell(
          onTap: click,
          child: Text(
            otherString,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
        )
      ],
    );
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

  Widget _getInput() {
    if (step == 1) {
      return createUsernameTextfield(
        controller: usernameController,
        hintText: "Kullanıcı Adı",
        errorState: usernameErrorState,
        errorText: usernameErrorMessage,
        changed: usernameErrorCatcher,
      );
    } else if (step == 2) {
      return createPasswordTextField(
        controller: passwordController,
        hintText: "Şifre",
        changed: passwordErrorCatcher,
        errorState: passwordErrorState,
        errorText: passwordErrorMessage,
        visibility: passwordObs(),
        obscureState: isPasswordFieldVisible,
      );
    } else if (step == 3) {
      return createEmailTextfield(
          controller: emailController,
          hintText: "Eposta",
          changed: emailErrorCatcher,
          errorState: emailErrorState,
          errorText: emailErrorMessage);
    } else {
      return createVerifyCodeTextfield(
        changed: verifyErrorCatcher,
        controller: verifyController,
        errorState: verifyErrorState,
        enabled: true,
        errorText: verifyErrorMessage,
        hintText: "Doğrulama Kodu",
      );
    }
  }
}
