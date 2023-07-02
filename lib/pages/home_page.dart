// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable

import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kitap_dagi/pages/book_details_page.dart';
import 'package:kitap_dagi/pages/category_page.dart';
import 'package:kitap_dagi/pages/favorites_page.dart';
import 'package:kitap_dagi/pages/no_connection.dart';
import 'package:kitap_dagi/pages/profile_page.dart';
import 'package:kitap_dagi/viewmodels/category_viewmodel.dart';
import 'package:kitap_dagi/viewmodels/favorites_viewmodel.dart';
import 'package:kitap_dagi/viewmodels/main_viewmodel.dart';
import 'package:kitap_dagi/viewmodels/user_viewmodel.dart';
import 'package:kitap_dagi/widgets/appbar.dart';
import 'package:kitap_dagi/widgets/drawer.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../constants.dart';
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
    FocusScopeNode currentFocus = FocusScopeNode();
    if (_userModel.sifreKontrol == true && a == 0) {
      a++;
      Future.delayed(Duration.zero, () {
        return showDialog<void>(
          context: context,
          barrierDismissible: true, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                "Şifre Değişikliği Tespit Edildi!",
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: Colors.black,
                ),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text(
                      "Şifre Değişikliği Yaptığınız İçin Hesabınızdan Çıkış Yapıldı. Lütfen Tekrar Giriş Yapınız!",
                      style: TextStyle(
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
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      });
    }
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
              title: const Text(
                "Kitap Dağı",
                style: TextStyle(
                    fontFamily: "Comfortaa", fontWeight: FontWeight.bold),
              ),
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
                                builder: (context) => const FavoritesPage()),
                          );
                        },
                        icon: const Icon(Icons.favorite))),
                IconButton(
                    onPressed: () {
                      _userModel.users.durum == false
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            )
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ProfilPage()),
                            );
                    },
                    icon: const Icon(Icons.person))
              ]),
          drawerEnableOpenDragGesture: true,
          drawer: const MyDrawer(sayi: 5, gidilecek: ""),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const MyAppBar(sayfa: 1),
                  slider(size, context),
                  _mainModel.state == ViewState.geldi
                      ? KitapSlider(
                          size: size,
                          asd: _mainModel.sizinicin,
                          baslik: "Sizin İçin Seçtiklerimiz",
                          cizgiUzunluk: 160,
                        )
                      : yukleniyor(size, "Sizin İçin Seçtiklerimiz", 160),
                  //buildBook(size, "Sizin İçin Seçtiklerimiz",
                  //  _mainModel.asd, 0),
                  _mainModel.state == ViewState.geldi
                      ? KitapSlider(
                          size: size,
                          asd: _mainModel.coksatan,
                          baslik: "Çok Satan Kitaplar",
                          cizgiUzunluk: 130,
                        )
                      : yukleniyor(size, "Çok Satan Kitaplar", 130),

                  //  buildBook(
                  //   size, "Çok Satan Kitaplar", _mainModel.asd, 7),
                  _mainModel.state == ViewState.geldi
                      ? KitapSlider(
                          size: size,
                          asd: _mainModel.yenicikan,
                          baslik: "Yeni Çıkan Kitaplar",
                          cizgiUzunluk: 130,
                        )
                      : yukleniyor(size, "Yeni Çıkan Kitaplar", 130),

                  // buildBook(
                  //     size, "Yeni Çıkan Kitaplar", _mainModel.asd, 14),
                  const SizedBox(
                    height: kDefaultPadding,
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Padding yukleniyor(Size size, String isim, double uzunluk) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Text(
              isim,
              style: const TextStyle(
                fontFamily: "Poppins",
                color: kPrimaryColor,
                fontSize: 15,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: SizedBox(
              width: uzunluk,
              child: const Divider(
                color: kPrimaryColor,
                thickness: 2,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Shimmer.fromColors(
                    period: const Duration(milliseconds: 1000),
                    baseColor: const Color.fromARGB(255, 205, 205, 205),
                    highlightColor: const Color.fromARGB(255, 214, 214, 214),
                    direction: ShimmerDirection.ltr,
                    child: Container(
                      color: Colors.grey,
                      height: 200,
                      width: (size.width - 50) / 3,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Shimmer.fromColors(
                    period: const Duration(milliseconds: 1000),
                    baseColor: const Color.fromARGB(255, 205, 205, 205),
                    highlightColor: const Color.fromARGB(255, 214, 214, 214),
                    direction: ShimmerDirection.ltr,
                    child: Container(
                      color: Colors.grey,
                      height: 20,
                      width: (size.width - 50) / 3,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Shimmer.fromColors(
                    period: const Duration(milliseconds: 1000),
                    baseColor: const Color.fromARGB(255, 205, 205, 205),
                    highlightColor: const Color.fromARGB(255, 214, 214, 214),
                    direction: ShimmerDirection.ltr,
                    child: Container(
                      color: Colors.grey,
                      height: 20,
                      width: (size.width - 50) / 3,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  Shimmer.fromColors(
                    period: const Duration(milliseconds: 1000),
                    baseColor: const Color.fromARGB(255, 205, 205, 205),
                    highlightColor: const Color.fromARGB(255, 214, 214, 214),
                    direction: ShimmerDirection.ltr,
                    child: Container(
                      color: Colors.grey,
                      height: 200,
                      width: (size.width - 50) / 3,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Shimmer.fromColors(
                    period: const Duration(milliseconds: 1000),
                    baseColor: const Color.fromARGB(255, 205, 205, 205),
                    highlightColor: const Color.fromARGB(255, 214, 214, 214),
                    direction: ShimmerDirection.ltr,
                    child: Container(
                      color: Colors.grey,
                      height: 20,
                      width: (size.width - 50) / 3,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Shimmer.fromColors(
                    period: const Duration(milliseconds: 1000),
                    baseColor: const Color.fromARGB(255, 205, 205, 205),
                    highlightColor: const Color.fromARGB(255, 214, 214, 214),
                    direction: ShimmerDirection.ltr,
                    child: Container(
                      color: Colors.grey,
                      height: 20,
                      width: (size.width - 50) / 3,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  Shimmer.fromColors(
                    period: const Duration(milliseconds: 1000),
                    baseColor: const Color.fromARGB(255, 205, 205, 205),
                    highlightColor: const Color.fromARGB(255, 214, 214, 214),
                    direction: ShimmerDirection.ltr,
                    child: Container(
                      color: Colors.grey,
                      height: 200,
                      width: (size.width - 50) / 3,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Shimmer.fromColors(
                    period: const Duration(milliseconds: 1000),
                    baseColor: const Color.fromARGB(255, 205, 205, 205),
                    highlightColor: const Color.fromARGB(255, 214, 214, 214),
                    direction: ShimmerDirection.ltr,
                    child: Container(
                      color: Colors.grey,
                      height: 20,
                      width: (size.width - 50) / 3,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Shimmer.fromColors(
                    period: const Duration(milliseconds: 1000),
                    baseColor: const Color.fromARGB(255, 205, 205, 205),
                    highlightColor: const Color.fromARGB(255, 214, 214, 214),
                    direction: ShimmerDirection.ltr,
                    child: Container(
                      color: Colors.grey,
                      height: 20,
                      width: (size.width - 50) / 3,
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
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
        autoPlayInterval: const Duration(seconds: 7)),
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
                    fit: BoxFit.fill,
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
