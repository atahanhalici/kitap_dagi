// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kitap_dagi/constants.dart';
import 'package:kitap_dagi/pages/no_connection.dart';
import 'package:provider/provider.dart';

import '../viewmodels/user_viewmodel.dart';

class ForgotMyPassword extends StatefulWidget {
  const ForgotMyPassword({Key? key}) : super(key: key);

  @override
  State<ForgotMyPassword> createState() => _ForgotMyPasswordState();
}

class _ForgotMyPasswordState extends State<ForgotMyPassword> {
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

  bool uyari = false;
  @override
  Widget build(BuildContext context) {
    final _emailController = TextEditingController();
    Size size = MediaQuery.of(context).size;
    UserViewModel _userModel =
        Provider.of<UserViewModel>(context, listen: true);
    FocusScopeNode currentFocus = FocusScopeNode();
    return Listener(
      onPointerDown: (_) {
        currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: Scaffold(
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
                SizedBox(
                  height: size.height > size.width
                      ? (size.height - (size.height * 0.1 - 27 + 80 + 225)) / 2
                      : (size.height - (size.width * 0.1 - 27 + 80 + 225)) / 2,
                ),
                Container(
                  //height: 225,
                  //width: 100,
                  margin:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
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
                          "Şifremi Unuttum",
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
                            style: const TextStyle(
                              fontFamily: "Poppins",
                            ),
                            //  controller: _titleController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                        TextButton(
                            onPressed: () async {
                              if (_emailController.text.isNotEmpty) {
                                Map sonuc = await _userModel
                                    .sifremiUnuttum(_emailController.text);
                                if (context.mounted) {
                                  alertDialog(
                                      "Şifre Sıfırlama Talebi", sonuc["mesaj"],
                                      () {
                                    if (sonuc["durum"] == true) {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    } else {
                                      Navigator.of(context).pop();
                                    }
                                  }, context);
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
                                "Şifremi Unuttum",
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
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height > size.width
                      ? (size.height - (size.height * 0.1 - 27 + 80 + 225)) / 2
                      : (size.height - (size.width * 0.1 - 27 + 80 + 225)) / 2,
                ),
              ])))),
    );
  }

  alertDialog(String baslik, String icerik, void Function() fonksiyon,
      BuildContext context) {
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
              onPressed: fonksiyon,
              child: const Text(
                "Tamam",
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
