import 'package:flutter/material.dart';
import 'package:kitap_dagi/constants.dart';
import 'package:kitap_dagi/pages/category_page.dart';
import 'package:kitap_dagi/viewmodels/category_viewmodel.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatelessWidget {
  final int sayfa;
  const MyAppBar({Key? key, required this.sayfa}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // ignore: no_leading_underscores_for_local_identifiers
    TextEditingController _controller = TextEditingController();
    return Container(
      margin: const EdgeInsets.only(bottom: kDefaultPadding * 2.5),
      // It will cover 20% of our total height
      height: size.height > size.width ? size.height * 0.1 : size.width * 0.1,
      child: Stack(
        children: <Widget>[
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
          Positioned(
            left: 0,
            right: 0,
            top: 15,
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 10),
                    blurRadius: 50,
                    color: kPrimaryColor.withOpacity(0.23),
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      textInputAction: TextInputAction.search,
                      controller: _controller,
                      onSubmitted: (value) {
                        aramaMetodu(context, value, _controller);
                      },
                      decoration: InputDecoration(
                        hintText: "Arama yap",
                        hintStyle: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontFamily: "Comfortaa",
                        ),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        // surffix isn't working properly  with SVG
                        // thats why we use row
                        suffixIcon: GestureDetector(
                            onTap: () {
                              aramaMetodu(
                                  context, _controller.text, _controller);
                            },
                            child: const Icon(Icons.search)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  aramaMetodu(
      BuildContext context, String isim, TextEditingController controller) {
    if (isim.isNotEmpty) {
      // ignore: no_leading_underscores_for_local_identifiers
      CategoryViewModel _categoryModel =
          Provider.of<CategoryViewModel>(context, listen: false);
      _categoryModel.baslama = 0;
      _categoryModel.aramaKitapGetir(isim);
      if (sayfa == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CategoryPage(title: isim.toUpperCase())),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => CategoryPage(title: isim.toUpperCase())),
        );
      }

      controller.clear();
    } else {
      showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Arama Kutusu Boş",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text(
                    "Kutucuk Boş Bırakılamaz! Lütfen Aramak İstediğiniz İçeriğin Adını Giriniz.",
                    style: TextStyle(
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
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }
}
