import 'package:flutter/material.dart';
import 'package:kitap_dagi/constants.dart';
import 'package:kitap_dagi/pages/favorites_page.dart';
import 'package:kitap_dagi/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';

import '../widgets/drawer.dart';
import 'home_page.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  bool sifreGuncelle = false;
  @override
  Widget build(BuildContext context) {
    UserViewModel _userModel =
        Provider.of<UserViewModel>(context, listen: true);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
            backgroundColor: kPrimaryColor,
            title: Text("Kitap Dağı"),
            centerTitle: true,
            elevation: 0,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => FavoritesPage()),
                    );
                  },
                  icon: Icon(Icons.favorite)),
              IconButton(onPressed: () {}, icon: Icon(Icons.person))
            ]),
        drawerEnableOpenDragGesture: true,
        drawer: const MyDrawer(),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
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
                                ? Color.fromARGB(255, 250, 250, 250)
                                : Color.fromARGB(255, 226, 226, 226),
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
                          )),
                        ),
                        onTap: () {
                          setState(() {});
                          sifreGuncelle = false;
                        },
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: sifreGuncelle
                                ? Color.fromARGB(255, 250, 250, 250)
                                : Color.fromARGB(255, 226, 226, 226),
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
                          )),
                        ),
                        onTap: () {
                          setState(() {
                            sifreGuncelle = true;
                          });
                        },
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
                  key: Key(!sifreGuncelle ? _userModel.users.user["name"] : ""),
                  initialValue:
                      !sifreGuncelle ? _userModel.users.user["name"] : "",
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  cursorColor: Colors.black,
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: !sifreGuncelle ? "İsim" : "Eski Şifre",
                    labelStyle: const TextStyle(color: Colors.black),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor)),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (deger) {
                    if (deger!.isEmpty) {
                      return "İsim Kısmı Boş Bırakılamaz!";
                    } else {
                      //_emailController.text = deger;
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
                  key: Key(
                      !sifreGuncelle ? _userModel.users.user["surname"] : ""),
                  initialValue:
                      !sifreGuncelle ? _userModel.users.user["surname"] : "",
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  cursorColor: Colors.black,
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: !sifreGuncelle ? "Soyisim" : "Yeni Şifre",
                    labelStyle: const TextStyle(color: Colors.black),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor)),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (deger) {
                    if (deger!.isEmpty) {
                      return "Soyisim Kısmı Boş Bırakılamaz!";
                    } else {
                      //_emailController.text = deger;
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
                  key:
                      Key(!sifreGuncelle ? _userModel.users.user["email"] : ""),
                  initialValue:
                      !sifreGuncelle ? _userModel.users.user["email"] : "",
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  cursorColor: Colors.black,
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: !sifreGuncelle
                        ? "E-Mail"
                        : "Yeni Şifrenizi Tekrar Giriniz",
                    labelStyle: const TextStyle(color: Colors.black),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor)),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (deger) {
                    if (deger!.isEmpty) {
                      return "E-Mail Kısmı Boş Bırakılamaz!";
                    } else if (!deger.contains("@") || !deger.contains(".")) {
                      return "Geçersiz Mail Formatı. Lütfen Kontrol Ediniz";
                    } else {
                      //_emailController.text = deger;
                    }
                    return null;
                  },
                ),
              ),
              TextButton(
                  onPressed: () async {},
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
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )),
                  )),
            ]))));
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
                "Hayır",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                "Evet",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: fonksiyon,
            ),
          ],
        );
      },
    );
  }
}
