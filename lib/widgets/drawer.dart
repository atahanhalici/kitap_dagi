import 'package:flutter/material.dart';
import 'package:kitap_dagi/constants.dart';
import 'package:kitap_dagi/pages/category_page.dart';
import 'package:kitap_dagi/viewmodels/category_viewmodel.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  final int sayi;
  final String gidilecek;
  const MyDrawer({Key? key, required this.sayi, required this.gidilecek})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: const BoxDecoration(
                color: kPrimaryColor,
              ),
              child: Image.asset("assets/logopng2.png")),
          Categories(context, 'Edebiyat', "edebiyat"),
          Categories(context, 'Bilim Kurgu', "bilim-kurgu"),
          Categories(context, 'Çocuk', "cocuk"),
          Categories(context, 'Kişisel Gelişim', "kisisel-gelisim"),
          Categories(context, 'Tarih', "tarih"),
          Categories(context, 'Psikoloji', "psikoloji"),
          Categories(context, 'Felsefe', "felsefe"),
        ],
      ),
    );
  }

  ListTile Categories(BuildContext context, String ad, String name) {
    CategoryViewModel _categoryModel =
        Provider.of<CategoryViewModel>(context, listen: true);
    _categoryModel.baslama = 0;
    return ListTile(
      title: Text(ad),
      onTap: () async {
        if (gidilecek == ad) {
          Navigator.pop(context);
        } else {
          if (sayi == 5) {
            _categoryModel.kategoriKitapGetir(name);
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CategoryPage(title: ad)),
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
        }

        // Update the state of the app
        // ...
        // Then close the drawer
        // Navigator.pop(context);
      },
    );
  }
}
