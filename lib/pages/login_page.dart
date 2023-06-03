import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kitap_dagi/constants.dart';
import 'package:kitap_dagi/pages/forgot_my_password_page.dart';
import 'package:kitap_dagi/pages/home_page.dart';
import 'package:kitap_dagi/pages/registration.dart';
import 'package:kitap_dagi/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';

import '../widgets/drawer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
          title: const Text("Kitap Dağı"),
          centerTitle: true,
          elevation: 0,
        ),
        drawerEnableOpenDragGesture: true,
        drawer: const MyDrawer(),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
              Container(
                padding: EdgeInsets.only(
                  left: kDefaultPadding,
                  right: kDefaultPadding,
                  bottom: 36 + kDefaultPadding,
                ),
                height: size.height > size.width
                    ? size.height * 0.1 - 27
                    : size.width * 0.1 - 27,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(36),
                    bottomRight: Radius.circular(36),
                  ),
                ),
              ),
              SizedBox(
                height: kDefaultPadding * 3,
              ),
              Container(
                //height: 500,
                //width: 100,
                margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                padding: EdgeInsets.all(kDefaultPadding),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 236, 236, 236),
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
                            color: kPrimaryColor,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: kDefaultPadding,
                      ),
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          //  controller: _titleController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          cursorColor: Colors.black,
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: "E-Mail",
                            labelStyle: const TextStyle(color: Colors.black),
                            focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: kPrimaryColor)),
                            border: const UnderlineInputBorder(),
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
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          //  controller: _titleController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          cursorColor: Colors.black,
                          maxLines: 1,
                          obscureText: _gizli,
                          decoration: InputDecoration(
                            labelText: "Şifre",
                            labelStyle: const TextStyle(color: Colors.black),
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
                      SizedBox(
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
                            child: const Text(
                              'Beni Hatırla',
                              style: TextStyle(
                                color: Color.fromARGB(255, 68, 68, 68),
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Expanded(child: SizedBox()),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotMyPassword()));
                            },
                            child: Text(
                              "Şifremi Unuttum",
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 15,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
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
                            child: Center(
                                child: Text(
                              "Giriş Yap",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )),
                          )),
                      Visibility(
                        visible: uyari,
                        child: Text(
                          "Lütfen Hiçbir Alanı Boş Geçmeyiniz!",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      SizedBox(
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
                              child: Text("Veya")),
                          Expanded(
                              child: Divider(
                            thickness: 2,
                          )),
                        ],
                      ),
                      SizedBox(
                        height: kDefaultPadding,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          CircleAvatar(
                            radius: 17,
                            backgroundImage:
                                AssetImage("assets/google_logo.png"),
                            backgroundColor:
                                Color.fromARGB(255, 236, 236, 236),
                            //child: Image.asset("assets/google_logo.png"),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          CircleAvatar(
                            radius: 17,
                            backgroundImage: AssetImage("assets/face_logo.png"),
                            backgroundColor: Color.fromARGB(255, 236, 236, 236),
                            //child: Image.asset("assets/google_logo.png"),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          CircleAvatar(
                            radius: 17,
                            backgroundImage:
                                AssetImage("assets/twitter_logo.png"),
                            backgroundColor: Color.fromARGB(255, 236, 236, 236),
                            //child: Image.asset("assets/google_logo.png"),
                          )
                        ],
                      ),
                      SizedBox(
                        height: kDefaultPadding,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Hesabınız yok mu? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => KayitOl()));
                            },
                            child: const Text(
                              "Kayıt Ol",
                              style: TextStyle(color: kPrimaryColor),
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
              color: Colors.black,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  icerik,
                  style: const TextStyle(
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
