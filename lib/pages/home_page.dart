import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:kitap_dagi/pages/book_details_page.dart';
import 'package:kitap_dagi/pages/category_page.dart';
import 'package:kitap_dagi/pages/favorites_page.dart';
import 'package:kitap_dagi/pages/profile_page.dart';
import 'package:kitap_dagi/pages/registration.dart';
import 'package:kitap_dagi/viewmodels/category_viewmodel.dart';
import 'package:kitap_dagi/viewmodels/favorites_viewmodel.dart';
import 'package:kitap_dagi/viewmodels/main_viewmodel.dart';
import 'package:kitap_dagi/viewmodels/user_viewmodel.dart';
import 'package:kitap_dagi/widgets/appbar.dart';
import 'package:kitap_dagi/widgets/drawer.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/book.dart';
import '../viewmodels/comment_viewmodel.dart';
import '../widgets/kitap_slider.dart';
import 'login_page.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int a = 0;

  @override
  Widget build(BuildContext context) {
    MainViewModel _mainModel =
        Provider.of<MainViewModel>(context, listen: true);
    CommentViewModel _commentModel =
        Provider.of<CommentViewModel>(context, listen: true);
    UserViewModel _userModel =
        Provider.of<UserViewModel>(context, listen: true);
    FavoritesViewModel _favModel =
        Provider.of<FavoritesViewModel>(context, listen: true);
    Size size = MediaQuery.of(context).size;

    if (_userModel.sifreKontrol == true && a == 0) {
      a++;
      Future.delayed(Duration.zero, () {
        return showDialog<void>(
          context: context,
          barrierDismissible: true, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Şifre Değişikliği Tespit Edildi!",
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                      "Şifre Değişikliği Yaptığınız İçin Hesabınızdan Çıkış Yapıldı. Lütfen Tekrar Giriş Yapınız!",
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
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      });
    }
    return Scaffold(
      appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text("Kitap Dağı"),
          centerTitle: true,
          elevation: 0,
          actions: [
            Visibility(
                visible: _userModel.users.durum,
                child: IconButton(
                    onPressed: () {
                      _favModel.favoriGetir(_userModel.users.user["_id"]);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FavoritesPage()),
                      );
                    },
                    icon: Icon(Icons.favorite))),
            IconButton(
                onPressed: () {
                  _userModel.users.durum == false
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        )
                      : Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfilPage()),
                        );
                },
                icon: Icon(Icons.person))
          ]),
      drawerEnableOpenDragGesture: true,
      drawer: const MyDrawer(sayi:5,gidilecek: ""),
      body: _mainModel.state == ViewState.geliyor
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _mainModel.state == ViewState.geldi
              ? SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const MyAppBar(sayfa:1),
                        slider(size, context),
                        KitapSlider(
                          size: size,
                          asd: _mainModel.sizinicin,
                          baslik: "Sizin İçin Seçtiklerimiz",
                          cizgiUzunluk: 160,
                        ),
                        //buildBook(size, "Sizin İçin Seçtiklerimiz",
                        //  _mainModel.asd, 0),

                        KitapSlider(
                          size: size,
                          asd: _mainModel.coksatan,
                          baslik: "Çok Satan Kitaplar",
                          cizgiUzunluk: 130,
                        ),

                        //  buildBook(
                        //   size, "Çok Satan Kitaplar", _mainModel.asd, 7),

                        KitapSlider(
                          size: size,
                          asd: _mainModel.yenicikan,
                          baslik: "Yeni Çıkan Kitaplar",
                          cizgiUzunluk: 130,
                        ),

                        // buildBook(
                        //     size, "Yeni Çıkan Kitaplar", _mainModel.asd, 14),
                        const SizedBox(
                          height: kDefaultPadding,
                        ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Text("HATA"),
                ),
    );
  }
}

slider(Size size, BuildContext context) {
  CategoryViewModel _categoryModel =
      Provider.of<CategoryViewModel>(context, listen: true);
  MainViewModel _mainModel = Provider.of<MainViewModel>(context, listen: true);
  CommentViewModel _commentModel =
      Provider.of<CommentViewModel>(context, listen: true);
  return CarouselSlider(
    options: CarouselOptions(
        viewportFraction: 1,
        height: size.height > size.width ? size.height / 3.5 : size.width / 3.5,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 7)),
    items: imgList.map((imgAsset) {
      return Builder(
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              if (imgAsset == "assets/superindirimler.png" ||
                  imgAsset == "assets/coksatanlar.png") {
                _categoryModel.baslama = 0;
                _categoryModel.kategoriKitapGetir(
                    imgAsset == "assets/superindirimler.png"
                        ? "indirimdekiler"
                        : "cok-satan-kitaplar");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CategoryPage(
                          title: imgAsset == "assets/superindirimler.png"
                              ? "Süper İndirimler"
                              : "Çok Satanlar")),
                );
              } else if (imgAsset == "assets/gununkitabi.png") {
                _mainModel.kitaplariGetir();
                _commentModel.yorumlariGetir(_mainModel.gununkitabi.id);
                _commentModel.yildizPuanla(0);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          BookDetails(book: _mainModel.gununkitabi)),
                );
              }
            },
            child: Container(
              // height: size.height / 4,
              margin: const EdgeInsets.only(
                  bottom: kDefaultPadding,
                  right: kDefaultPadding,
                  left: kDefaultPadding),
              decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ), //BoxShadow
                  ],
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      imgAsset,
                    ),
                  )),
            ),
          );
        },
      );
    }).toList(),
  );
}

List imgList = [
  "assets/gununkitabi.png",
  "assets/superindirimler.png",
  "assets/coksatanlar.png",
];
List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }
  return result;
}
