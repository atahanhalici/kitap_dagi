// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:kitap_dagi/constants.dart';
import 'package:kitap_dagi/pages/home_page.dart';
import 'package:kitap_dagi/pages/login_page.dart';
import 'package:kitap_dagi/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';

import '../widgets/drawer.dart';

class KayitOl extends StatefulWidget {
  const KayitOl({Key? key}) : super(key: key);

  @override
  State<KayitOl> createState() => _KayitOlState();
}

class _KayitOlState extends State<KayitOl> {
  bool uyari = false;
  bool _gizli = true;
  bool _gizli1 = true;
  bool uyusmuyor = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final _isimController = TextEditingController();
    final _soyisimController = TextEditingController();
    final _emailController = TextEditingController();
    final _sifreController = TextEditingController();
    final _sifreTekrarController = TextEditingController();
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
        drawer: const MyDrawer(sayi: 8, gidilecek: ""),
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
                        "Kayıt Ol",
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
                        width: size.width,
                        child: Row(
                          children: [
                            Expanded(
                                child: SizedBox(
                              height: 70,
                              child: TextFormField(
                                //  controller: _titleController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                cursorColor: Colors.black,
                                maxLines: 1,
                                decoration: const InputDecoration(
                                  labelText: "İsim",
                                  labelStyle: TextStyle(color: Colors.black),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: kPrimaryColor)),
                                  border: UnderlineInputBorder(),
                                ),
                                validator: (deger) {
                                  _isimController.text = deger!;
                                  return null;
                                },
                              ),
                            )),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                                child: SizedBox(
                              height: 70,
                              child: TextFormField(
                                //  controller: _titleController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                cursorColor: Colors.black,
                                maxLines: 1,
                                decoration: const InputDecoration(
                                  labelText: "Soyisim",
                                  labelStyle: TextStyle(color: Colors.black),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: kPrimaryColor)),
                                  border: UnderlineInputBorder(),
                                ),
                                validator: (deger) {
                                  _soyisimController.text = deger!;
                                  return null;
                                },
                              ),
                            )),
                          ],
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
                          decoration: const InputDecoration(
                            labelText: "E-Mail",
                            errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)),
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: kPrimaryColor)),
                            border: UnderlineInputBorder(),
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
                          obscureText: _gizli1,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _gizli1 = !_gizli1;
                                  });
                                },
                                icon: _gizli1
                                    ? const Icon(Icons.visibility,
                                        color: Colors.grey)
                                    : const Icon(Icons.visibility_off,
                                        color: Colors.grey)),
                            labelText: "Şifre",
                            labelStyle: const TextStyle(color: Colors.black),
                            focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: kPrimaryColor)),
                            border: const UnderlineInputBorder(),
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
                            labelText: "Şifrenizi Tekrar Giriniz",
                            labelStyle: const TextStyle(color: Colors.black),
                            focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: kPrimaryColor)),
                            border: const UnderlineInputBorder(),
                          ),
                          validator: (deger) {
                            if (deger!.length < 4) {
                              return "Şifreniz en az 4 karakter uzunluğunda olmalıdır!";
                            } else if (deger.length > 20) {
                              return "Şifreniz en çok 20 karakter uzunluğunda olmalıdır!";
                            } else {
                              _sifreTekrarController.text = deger;
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextButton(
                          onPressed: () async {
                            if (_isimController.text != "" &&
                                _soyisimController.text != "" &&
                                _emailController.text != "" &&
                                _sifreTekrarController.text != "" &&
                                _sifreController.text != "") {
                              if (_sifreController.text ==
                                  _sifreTekrarController.text) {
                                Map<String, String> bilgiler = {
                                  "name": _isimController.text,
                                  "surname": _soyisimController.text,
                                  "email": _emailController.text,
                                  "password": _sifreController.text
                                };
                                bool kayit = await _userModel.kayit(bilgiler);
                                if (context.mounted && kayit == true) {
                                  Navigator.popUntil(
                                      context, (route) => route.isFirst);
                                  alertDialog(
                                      "Kayıt İşlemi Başarıyla Tamamlandı",
                                      "E postanızı kontrol edip hesabınızı onaylamanız gerekmektedir. Onaylamadığınız takdirde hesabınıza giriş yapmanız mümkün değildir!");
                                } else if (context.mounted && kayit == false) {
                                  alertDialog("Kayıt İşlemi Tamamlanamadı",
                                      "Kayıt İşlemi Tamamlanamadı. Google - Facebook - Twitter ile daha önceden giriş yaptıysanız bu nedenle kayıt olamamış olabilirsiniz. Bu durumlar geçerli değilse sunucularımızda sorun oluşmuş olabilir. Lütfen Daha Sonra Tekrar Deneyiniz!");
                                }
                              } else {
                                setState(() {
                                  uyusmuyor = true;
                                  uyari = false;
                                });
                              }
                            } else {
                              setState(() {
                                uyari = true;
                                uyusmuyor = false;
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
                              "Kayıt Ol",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )),
                          )),
                      Visibility(
                        visible: uyari,
                        child: const Text(
                          "Lütfen Hiçbir Alanı Boş Geçmeyiniz!",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      Visibility(
                        visible: uyusmuyor,
                        child: const Text(
                          "İki şifre birbiriyle uyuşmuyor!",
                          style: TextStyle(color: Colors.red),
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
                              child: Text("Veya")),
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
                          const Text("Hesabınız mı var? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()));
                              /* Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );*/
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: const Text(
                                "Giriş Yap",
                                style: TextStyle(color: kPrimaryColor),
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
