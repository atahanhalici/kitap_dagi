// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kitap_dagi/constants.dart';
import 'package:kitap_dagi/pages/forgot_my_password_page.dart';
import 'package:kitap_dagi/pages/home_page.dart';
import 'package:kitap_dagi/pages/registration.dart';
import 'package:kitap_dagi/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';

import '../widgets/drawer.dart';
import 'no_connection.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
   late StreamSubscription<InternetConnectionStatus> listener;

  @override
  void initState() {
    execute();
    super.initState();
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }

  Future<void> execute() async {
   
    listener = InternetConnectionChecker().onStatusChange.listen(
      (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            break;
          case InternetConnectionStatus.disconnected:
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const NoConnectionPage()));
            break;
        }
      },
    );
  }

  final _emailController = TextEditingController();
  final _sifreController = TextEditingController();
  bool _gizli = true;
  bool uyari = false;
  bool isChecked = false;
  var box = Hive.box("informations");
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    UserViewModel _userModel =
        Provider.of<UserViewModel>(context, listen: true);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: GestureDetector(
              onTap: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text(
                "Kitap Dağı",
                style: TextStyle(
                    fontFamily: "Comfortaa", fontWeight: FontWeight.bold),
              )),
          centerTitle: true,
          elevation: 0,
        ),
        drawerEnableOpenDragGesture: true,
        drawer: const MyDrawer(sayi: 6, gidilecek: ""),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
              Container(
                padding: const EdgeInsets.only(
                  left: kDefaultPadding,
                  right: kDefaultPadding,
                  bottom: 36 + kDefaultPadding,
                ),
                height: size.height > size.width
                    ? size.height * 0.1 - 27
                    : size.width * 0.1 - 27,
                decoration: const BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(36),
                    bottomRight: Radius.circular(36),
                  ),
                ),
              ),
              const SizedBox(
                height: kDefaultPadding * 3,
              ),
              Container(
                //height: 500,
                //width: 100,
                margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                padding: const EdgeInsets.all(kDefaultPadding),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 236, 236, 236),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      ), //BoxShadow
                    ],
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Giriş Yap",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            color: kPrimaryColor,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: kDefaultPadding,
                      ),
                      SizedBox(
                        height: 70,
                        child: TextFormField(
                          //  controller: _titleController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          cursorColor: Colors.black,
                          maxLines: 1,
                          decoration: const InputDecoration(
                            labelText: "E-Mail",
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontFamily: "Poppins",
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: kPrimaryColor)),
                            border: UnderlineInputBorder(),
                            suffixIcon: Icon(Icons.person),
                          ),
                          validator: (deger) {
                            if (deger!.isEmpty) {
                              return "E-Mail Kısmı Boş Bırakılamaz!";
                            } else if (!deger.contains("@") ||
                                !deger.contains(".")) {
                              return "Geçersiz Mail Formatı. Lütfen Kontrol Ediniz";
                            } else {
                              _emailController.text = deger;
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 70,
                        child: TextFormField(
                          //  controller: _titleController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          cursorColor: Colors.black,
                          maxLines: 1,
                          obscureText: _gizli,
                          decoration: InputDecoration(
                            labelText: "Şifre",
                            labelStyle: const TextStyle(
                              color: Colors.black,
                              fontFamily: "Poppins",
                            ),
                            focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: kPrimaryColor)),
                            border: const UnderlineInputBorder(),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _gizli = !_gizli;
                                  });
                                },
                                icon: _gizli
                                    ? const Icon(Icons.visibility,
                                        color: Colors.grey)
                                    : const Icon(Icons.visibility_off,
                                        color: Colors.grey)),
                          ),
                          validator: (deger) {
                            if (deger!.length < 4) {
                              return "Şifreniz en az 4 karakter uzunluğunda olmalıdır!";
                            } else if (deger.length > 20) {
                              return "Şifreniz en çok 20 karakter uzunluğunda olmalıdır!";
                            } else {
                              _sifreController.text = deger;
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Checkbox(
                            checkColor: Colors.white,
                            activeColor: kPrimaryColor,
                            value: isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isChecked = !isChecked;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: const Text(
                                'Beni Hatırla',
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Color.fromARGB(255, 68, 68, 68),
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotMyPassword()));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: const Text(
                                "Şifremi Unuttum",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: kPrimaryColor,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextButton(
                          onPressed: () async {
                            if (_emailController.text != "" &&
                                _sifreController.text != "") {
                              Map<String, String> bilgiler = {
                                "email": _emailController.text,
                                "password": _sifreController.text
                              };
                              await _userModel.giris(bilgiler);
                              if (context.mounted) {
                                if (_userModel.users.durum == true) {
                                  if (isChecked) {
                                    await box.put(
                                        "user", _userModel.users.user);
                                    await box.put(
                                        "durum", _userModel.users.durum);
                                    await box.put("mesaj", "");
                                    await box.put("mailgiris", true);
                                  }
                                  if (context.mounted) {
                                    Navigator.popUntil(
                                        context, (route) => route.isFirst);

                                    /* Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomePage()));*/
                                  }
                                } else {
                                  alertDialog("Giriş Yapılamadı!",
                                      _userModel.users.mesaj);
                                }
                              }
                            } else {
                              setState(() {
                                uyari = true;
                              });
                            }
                          },
                          child: Container(
                            width: size.width - (2 * kDefaultPadding),
                            height: 50,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                                child: Text(
                              "Giriş Yap",
                              style: TextStyle(
                                  fontFamily: "Comfortaa",
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )),
                          )),
                      Visibility(
                        visible: uyari,
                        child: const Text(
                          "Lütfen Hiçbir Alanı Boş Geçmeyiniz!",
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: "Poppins",
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: kDefaultPadding,
                      ),
                      Row(
                        children: const [
                          Expanded(
                              child: Divider(
                            thickness: 2,
                          )),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                "Veya",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                ),
                              )),
                          Expanded(
                              child: Divider(
                            thickness: 2,
                          )),
                        ],
                      ),
                      const SizedBox(
                        height: kDefaultPadding,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              bool deger = await _userModel.googleGiris();
                              if (context.mounted) {
                                if (deger == true) {
                                  Navigator.popUntil(
                                      context, (route) => route.isFirst);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomePage()));
                                }
                              }
                            },
                            child: const CircleAvatar(
                              radius: 17,
                              backgroundImage:
                                  AssetImage("assets/google_logo.png"),
                              backgroundColor:
                                  Color.fromARGB(255, 236, 236, 236),
                              //child: Image.asset("assets/google_logo.png"),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              alertDialog("Şu Anda Aktif Değil",
                                  "Facebook ile oturum açma hizmetimiz şu anda maalesef aktif değil. Entegre edebilmek için çalışmaktayız.");
                            },
                            child: const CircleAvatar(
                              radius: 17,
                              backgroundImage:
                                  AssetImage("assets/face_logo.png"),
                              backgroundColor:
                                  Color.fromARGB(255, 236, 236, 236),
                              //child: Image.asset("assets/google_logo.png"),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () async {
                              /*bool deger = await _userModel.twitterGiris();
                              if (context.mounted) {
                                if (deger == true) {
                                  Navigator.popUntil(
                                      context, (route) => route.isFirst);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()));
                                }
                              }*/
                              alertDialog("Şu Anda Aktif Değil",
                                  "Twitter ile oturum açma hizmetimiz şu anda maalesef aktif değil. Entegre edebilmek için çalışmaktayız.");
                            },
                            child: const CircleAvatar(
                              radius: 17,
                              backgroundImage:
                                  AssetImage("assets/twitter_logo.png"),
                              backgroundColor:
                                  Color.fromARGB(255, 236, 236, 236),
                              //child: Image.asset("assets/google_logo.png"),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: kDefaultPadding,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Hesabınız yok mu? ",
                            style: TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const KayitOl()));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: const Text(
                                "Kayıt Ol",
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontFamily: "Poppins",
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: kDefaultPadding * 3,
              )
            ]))));
  }

  alertDialog(String baslik, String icerik) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            baslik,
            style: const TextStyle(
              fontFamily: "Poppins",
              color: Colors.black,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  icerik,
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Tamam",
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: Colors.black,
                ),
              ),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
