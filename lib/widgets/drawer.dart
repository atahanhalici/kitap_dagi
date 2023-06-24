import 'package:flutter/material.dart';
import 'package:kitap_dagi/constants.dart';
import 'package:kitap_dagi/pages/category_page.dart';

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
          Categories(context, 'Edebiyat'),
          Categories(context, 'Bilim Kurgu'),
          Categories(context, 'Çocuk'),
          Categories(context, 'Kişisel Gelişim'),
          Categories(context, 'Tarih'),
          Categories(context, 'Psikoloji'),
          Categories(context, 'Felsefe'),
        ],
      ),
    );
  }

  ListTile Categories(BuildContext context, String ad) {
    return ListTile(
      title: Text(ad),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CategoryPage()),
        );
        // Update the state of the app
        // ...
        // Then close the drawer
        // Navigator.pop(context);
      },
    );
  }
}
