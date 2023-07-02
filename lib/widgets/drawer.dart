import 'package:flutter/material.dart';
import 'package:kitap_dagi/constants.dart';
import 'package:kitap_dagi/pages/category_page.dart';
import 'package:kitap_dagi/pages/favorites_page.dart';
import 'package:kitap_dagi/pages/login_page.dart';
import 'package:kitap_dagi/pages/profile_page.dart';
import 'package:kitap_dagi/viewmodels/category_viewmodel.dart';
import 'package:kitap_dagi/viewmodels/favorites_viewmodel.dart';
import 'package:kitap_dagi/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  final int sayi;
  final String gidilecek;
  const MyDrawer({Key? key, required this.sayi, required this.gidilecek})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    UserViewModel _userModel =
        Provider.of<UserViewModel>(context, listen: true);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: const BoxDecoration(
                color: kPrimaryColor,
              ),
              child: Image.asset("assets/logopng2.png")),
          const SizedBox(
            child: Divider(
              color: kPrimaryColor,
              thickness: 2,
            ),
          ),
          const Center(
              child: Text(
            "Hızlı Ulaşım",
            style: TextStyle(
                color: kPrimaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          )),
          const SizedBox(
            child: Divider(
              color: kPrimaryColor,
              thickness: 2,
            ),
          ),
          Categories(context, 'Anasayfa', "anasayfa", false),
          _userModel.users.durum == true
              ? Categories(context, 'Profil', "profil", false)
              : Categories(context, 'Giriş Yap / Kayıt Ol', "girisyap", false),
          Visibility(
              visible: _userModel.users.durum,
              child: Categories(context, 'Favoriler', "favoriler", false)),
          const SizedBox(
            child: Divider(
              color: kPrimaryColor,
              thickness: 2,
            ),
          ),
          const Center(
              child: Text(
            "Kategoriler",
            style: TextStyle(
                color: kPrimaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          )),
          const SizedBox(
            child: Divider(
              color: kPrimaryColor,
              thickness: 2,
            ),
          ),
          Categories(context, 'Edebiyat', "edebiyat", true),
          Categories(context, 'Bilim Kurgu', "bilim-kurgu", true),
          Categories(context, 'Çocuk', "cocuk", true),
          Categories(context, 'Kişisel Gelişim', "kisisel-gelisim", true),
          Categories(context, 'Tarih', "tarih", true),
          Categories(context, 'Psikoloji', "psikoloji", true),
          Categories(context, 'Felsefe', "felsefe", true),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  ListTile Categories(
      BuildContext context, String ad, String name, bool category) {
    // ignore: no_leading_underscores_for_local_identifiers
    CategoryViewModel _categoryModel =
        Provider.of<CategoryViewModel>(context, listen: true);
    // ignore: no_leading_underscores_for_local_identifiers
    FavoritesViewModel _favModel =
        Provider.of<FavoritesViewModel>(context, listen: true);
    // ignore: no_leading_underscores_for_local_identifiers
    UserViewModel _userModel =
        Provider.of<UserViewModel>(context, listen: true);
    _categoryModel.baslama = 0;
    return ListTile(
      title: Text(ad),
      onTap: () async {
        if (gidilecek == ad) {
          Navigator.pop(context);
        } else {
          if (ad == "Anasayfa") {
            Navigator.pop(context);
            Navigator.popUntil(context, (route) => route.isFirst);
          } else if (category) {
            if (sayi == 5) {
              _categoryModel.kategoriKitapGetir(name);
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CategoryPage(title: ad)),
              );
            } else if (sayi == 0 ||
                sayi == 1 ||
                sayi == 2 ||
                sayi == 3 ||
                sayi == 6 ||
                sayi == 7 ||
                sayi == 8) {
              _categoryModel.kategoriKitapGetir(name);
              Navigator.pop(context);
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CategoryPage(title: ad)));
            }
          } else if (ad == "Favoriler") {
            if (sayi == 5) {
              _favModel.favoriGetir(_userModel.users.user["_id"]);
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritesPage()),
              );
            } else if (sayi == 0 ||
                sayi == 1 ||
                sayi == 2 ||
                sayi == 3 ||
                sayi == 6 ||
                sayi == 7 ||
                sayi == 8) {
              _favModel.favoriGetir(_userModel.users.user["_id"]);
              Navigator.pop(context);
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FavoritesPage()));
            }
          } else if (ad == "Profil") {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ProfilPage()));
          } else if (name == "girisyap") {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginPage()));
          }
        }

        // Update the state of the app
        // ...
        // Then close the drawer
        // Navigator.pop(context);
      },
    );
  }
}
