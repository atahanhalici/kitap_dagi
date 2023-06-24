import 'package:flutter/material.dart';
import 'package:kitap_dagi/constants.dart';
import 'package:kitap_dagi/pages/category_page.dart';
import 'package:kitap_dagi/viewmodels/category_viewmodel.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

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
              child: Image.asset("assets/logopng.png")),
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
    return ListTile(
      title: Text(ad),
      onTap: () async {
        _categoryModel.kategoriKitapGetir(name);
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CategoryPage(title: ad)),
        );
        // Update the state of the app
        // ...
        // Then close the drawer
        // Navigator.pop(context);
      },
    );
  }
}
