import 'package:flutter/material.dart';
import 'package:kitap_dagi/constants.dart';
import 'package:kitap_dagi/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';

import '../widgets/appbar.dart';
import '../widgets/drawer.dart';
import 'home_page.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({Key? key}) : super(key: key);

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
              IconButton(onPressed: () {}, icon: Icon(Icons.favorite)),
              IconButton(onPressed: () {}, icon: Icon(Icons.person))
            ]),
        drawerEnableOpenDragGesture: true,
        drawer: const MyDrawer(),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
              const MyAppBar(),
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
