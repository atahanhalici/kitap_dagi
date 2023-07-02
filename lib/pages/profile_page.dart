// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kitap_dagi/constants.dart';
import 'package:kitap_dagi/pages/favorites_page.dart';
import 'package:kitap_dagi/viewmodels/favorites_viewmodel.dart';
import 'package:kitap_dagi/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';

import '../widgets/drawer.dart';
import 'home_page.dart';
import 'no_connection.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
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

  bool sifreGuncelle = false;
  bool _gizli = true;
  bool _gizli1 = true;
  bool _gizli2 = true;
  @override
  Widget build(BuildContext context) {
    UserViewModel _userModel =
        Provider.of<UserViewModel>(context, listen: true);
    FavoritesViewModel _favModel =
        Provider.of<FavoritesViewModel>(context, listen: true);
    String isim = _userModel.users.user["name"];
    String soyisim = _userModel.users.user["surname"];
    String email = "";
    Size size = MediaQuery.of(context).size;
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
              actions: [
                IconButton(
                    onPressed: () {
                      _favModel.favoriGetir(_userModel.users.user["_id"]);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FavoritesPage()),
                      );
                    },
                    icon: const Icon(Icons.favorite)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.person))
              ]),
          drawerEnableOpenDragGesture: true,
          drawer: const MyDrawer(sayi: 7, gidilecek: ""),
          body: SafeArea(
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
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
                  height: size.height > 500 ? 60 : 20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              color: !sifreGuncelle
                                  ? const Color.fromARGB(255, 250, 250, 250)
                                  : const Color.fromARGB(255, 226, 226, 226),
                              border: Border(
                                top: BorderSide(
                                    width: 1.0,
                                    color: !sifreGuncelle
                                        ? kPrimaryColor
                                        : Colors.black),
                              ),
                            ),
                            height: 50,
                            child: const Center(
                                child: Text(
                              "Bilgilerimi Güncelle",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Poppins",
                              ),
                            )),
                          ),
                          onTap: () {
                            setState(() {});
                            sifreGuncelle = false;
                          },
                        ),
                      ),
                      Visibility(
                        visible:
                            _userModel.users.mailgiris == true ? true : false,
                        child: Expanded(
                          child: GestureDetector(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: sifreGuncelle
                                    ? const Color.fromARGB(255, 250, 250, 250)
                                    : const Color.fromARGB(255, 226, 226, 226),
                                border: Border(
                                  top: BorderSide(
                                      width: 1.0,
                                      color: sifreGuncelle
                                          ? kPrimaryColor
                                          : Colors.black),
                                ),
                              ),
                              child: const Center(
                                  child: Text(
                                "Şifremi Güncelle",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                ),
                              )),
                            ),
                            onTap: () {
                              setState(() {
                                sifreGuncelle = true;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
                  child: TextFormField(
                    //  controller: _titleController,
                    key: Key(
                        !sifreGuncelle ? _userModel.users.user["name"] : "eski"),
                    initialValue:
                        !sifreGuncelle ? _userModel.users.user["name"] : "",
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    cursorColor: Colors.black,
                    maxLines: 1,
                    obscureText: sifreGuncelle ? _gizli : false,
                    decoration: InputDecoration(
                      suffixIcon: sifreGuncelle
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  _gizli = !_gizli;
                                });
                              },
                              icon: _gizli
                                  ? const Icon(Icons.visibility,
                                      color: Colors.grey)
                                  : const Icon(Icons.visibility_off,
                                      color: Colors.grey))
                          : null,
                      labelText: !sifreGuncelle ? "İsim" : "Eski Şifre",
                      labelStyle: const TextStyle(
                        color: Colors.black,
                        fontFamily: "Poppins",
                      ),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor)),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (deger) {
                      if (deger!.isEmpty) {
                        if (!sifreGuncelle) {
                          return "İsim Kısmı Boş Bırakılamaz!";
                        } else {
                          return "Eski Şifre Kısmı Boş Bırakılamaz!";
                        }
                      } else {
                        isim = deger;
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
                  child: TextFormField(
                    //  controller: _titleController,
                    key: Key(!sifreGuncelle
                        ? _userModel.users.user["surname"]
                        : "yeni"),
                    initialValue:
                        !sifreGuncelle ? _userModel.users.user["surname"] : "",
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    cursorColor: Colors.black,
                    maxLines: 1,
                    obscureText: sifreGuncelle ? _gizli1 : false,
                    decoration: InputDecoration(
                      suffixIcon: sifreGuncelle
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  _gizli1 = !_gizli1;
                                });
                              },
                              icon: _gizli1
                                  ? const Icon(Icons.visibility,
                                      color: Colors.grey)
                                  : const Icon(Icons.visibility_off,
                                      color: Colors.grey))
                          : null,
                      labelText: !sifreGuncelle ? "Soyisim" : "Yeni Şifre",
                      labelStyle: const TextStyle(
                        color: Colors.black,
                        fontFamily: "Poppins",
                      ),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor)),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (deger) {
                      if (deger!.isEmpty) {
                        if (!sifreGuncelle) {
                          return "Soyisim Kısmı Boş Bırakılamaz!";
                        } else {
                          return "Yeni Şifre Kısmı Boş Bırakılamaz!";
                        }
                      } else {
                        if (deger.length < 4) {
                          return "Şifreniz en az 4 karakter uzunluğunda olmalıdır!";
                        } else if (deger.length > 20) {
                          return "Şifreniz en çok 20 karakter uzunluğunda olmalıdır!";
                        } else {
                          soyisim = deger;
                        }
                      }
    
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
                  child: TextFormField(
                    //  controller: _titleController,
                    key: Key(!sifreGuncelle
                        ? _userModel.users.user["email"]
                        : "yeniden"),
                    initialValue:
                        !sifreGuncelle ? _userModel.users.user["email"] : "",
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    readOnly: !sifreGuncelle,
                    cursorColor: Colors.black,
                    maxLines: 1,
                    obscureText: sifreGuncelle ? _gizli2 : false,
                    decoration: InputDecoration(
                      suffixIcon: sifreGuncelle
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  _gizli2 = !_gizli2;
                                });
                              },
                              icon: _gizli2
                                  ? const Icon(Icons.visibility,
                                      color: Colors.grey)
                                  : const Icon(Icons.visibility_off,
                                      color: Colors.grey))
                          : null,
                      labelText: !sifreGuncelle
                          ? "E-Mail"
                          : "Yeni Şifrenizi Tekrar Giriniz",
                      labelStyle: const TextStyle(
                        color: Colors.black,
                        fontFamily: "Poppins",
                      ),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor)),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (deger) {
                      if (deger!.isEmpty) {
                        if (!sifreGuncelle) {
                          return "Soyisim Kısmı Boş Bırakılamaz!";
                        } else {
                          return "Yeni Şifrenizi Tekrar Giriniz Kısmı Boş Bırakılamaz!";
                        }
                      } else {
                        if (deger.length < 4) {
                          return "Şifreniz en az 4 karakter uzunluğunda olmalıdır!";
                        } else if (deger.length > 20) {
                          return "Şifreniz en çok 20 karakter uzunluğunda olmalıdır!";
                        } else {
                          email = deger;
                        }
                      }
    
                      return null;
                    },
                  ),
                ),
                TextButton(
                    onPressed: () async {
                      if (sifreGuncelle == false) {
                        var sonuc = await _userModel.guncelle(
                            isim, soyisim, _userModel.users.user["email"]);
                        if (context.mounted) {
                          if (sonuc["durum"] == true) {
                            // ignore: use_build_context_synchronously
                            Navigator.popUntil(context, (route) => route.isFirst);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()));
                            aDialog(
                                "İşlem Başarılı", "${sonuc["mesaj"]}", context);
                          } else {
                            // ignore: use_build_context_synchronously
                            aDialog(
                                "İşlem Başarısız", "${sonuc["mesaj"]} ", context);
                          }
                        }
                      } else {
                        if (email == soyisim) {
                          var sonuc = await _userModel.sifreGuncelle(
                              isim, soyisim, _userModel.users.user["email"]);
                          if (context.mounted) {
                            if (sonuc["durum"] == true) {
                              // ignore: use_build_context_synchronously
                              Navigator.popUntil(
                                  context, (route) => route.isFirst);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()));
                              aDialog(
                                  "İşlem Başarılı", "${sonuc["mesaj"]}", context);
                            } else {
                              // ignore: use_build_context_synchronously
                              aDialog("İşlem Başarısız", "${sonuc["mesaj"]} ",
                                  context);
                            }
                          }
                        } else {
                          aDialog(
                              "İşlem Başarısız",
                              "Girmiş Olduğunuz Şifreler Uyuşmuyor! Lütfen Kontrol Ediniz.",
                              context);
                        }
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
                        "Değişiklikleri Kaydet",
                        style: TextStyle(
                            fontFamily: "Comfortaa",
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )),
                    )),
                TextButton(
                    onPressed: () async {
                      alertDialog("Hesabınızdan Çıkış Yapılacak",
                          "Hesabınızdan Çıkış Yapmak Üzeresiniz! Çıkış Yapmak İstediğinize Emin misiniz?",
                          () async {
                        bool sonuc = await _userModel.cikisYap();
                        if (context.mounted) {
                          if (sonuc == true) {
                            Navigator.popUntil(context, (route) => route.isFirst);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()));
                          }
                        }
                      }, context);
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
                        "Çıkış Yap",
                        style: TextStyle(
                            fontFamily: "Comfortaa",
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )),
                    )),
              ])))),
    );
  }

  aDialog(String baslik, String icerik, BuildContext context) {
    showDialog<void>(
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
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
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
              child: const Text(
                "Hayır",
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: fonksiyon,
              child: const Text(
                "Evet",
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
