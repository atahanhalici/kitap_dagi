// ignore_for_file: no_leading_underscores_for_local_identifiers, duplicate_ignore

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kitap_dagi/constants.dart';
import 'package:kitap_dagi/models/book.dart';
import 'package:kitap_dagi/pages/book_details_page.dart';
import 'package:kitap_dagi/pages/no_connection.dart';
import 'package:kitap_dagi/pages/profile_page.dart';
import 'package:kitap_dagi/viewmodels/comment_viewmodel.dart';
import 'package:kitap_dagi/viewmodels/favorites_viewmodel.dart';
import 'package:kitap_dagi/viewmodels/user_viewmodel.dart';
import 'package:kitap_dagi/widgets/appbar.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../widgets/drawer.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
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
    Size size = MediaQuery.of(context).size;
    // ignore: no_leading_underscores_for_local_identifiers
    FavoritesViewModel _favModel =
        Provider.of<FavoritesViewModel>(context, listen: true);
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
                      fontFamily: "Comfortaa",
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              centerTitle: true,
              elevation: 0,
              actions: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.favorite)),
                IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfilPage()),
                      );
                    },
                    icon: const Icon(Icons.person))
              ]),
          drawerEnableOpenDragGesture: true,
          drawer: const MyDrawer(sayi: 3, gidilecek: ""),
          body: SafeArea(
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                const MyAppBar(
                  sayfa: 0,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: Text(
                    "Favorilerim",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        color: kPrimaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: SizedBox(
                    width: 100,
                    child: Divider(
                      color: kPrimaryColor,
                      thickness: 2,
                    ),
                  ),
                ),
                _favModel.state == ViewStatex.geldi
                    ? _favModel.kitaplar.isNotEmpty
                        ? Liste(_favModel, size)
                        : Container(
                            height: 100,
                            margin: const EdgeInsets.symmetric(
                                horizontal: kDefaultPadding, vertical: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(255, 207, 207, 207)),
                            child: const Center(
                              child: Text(
                                "Favori Listenize Eklenmiş Kitap Bulunmamaktadır",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                ),
                              ),
                            ),
                          )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: kDefaultPadding,
                          ),
                          Shimmer.fromColors(
                            period: const Duration(milliseconds: 1000),
                            baseColor: const Color.fromARGB(255, 205, 205, 205),
                            highlightColor:
                                const Color.fromARGB(255, 214, 214, 214),
                            direction: ShimmerDirection.ltr,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: kDefaultPadding),
                              child: Container(
                                height: 250,
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 223, 223, 223),
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: kDefaultPadding,
                          ),
                          Shimmer.fromColors(
                            period: const Duration(milliseconds: 1000),
                            baseColor: const Color.fromARGB(255, 205, 205, 205),
                            highlightColor:
                                const Color.fromARGB(255, 214, 214, 214),
                            direction: ShimmerDirection.ltr,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: kDefaultPadding),
                              child: Container(
                                height: 250,
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 223, 223, 223),
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                          ),
                        ],
                      )
              ])))),
    );
  }

  // ignore: non_constant_identifier_names
  Widget Liste(FavoritesViewModel favoritesViewModel, Size size) {
    return ListView.builder(
        itemCount: favoritesViewModel.kitaplar.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Favori(size, context, favoritesViewModel.kitaplar[index],
              favoritesViewModel);
        });
  }

  // ignore: non_constant_identifier_names
  Widget Favori(Size size, BuildContext context, Book kitap,
      FavoritesViewModel favoritesViewModel) {
    CommentViewModel _commentModel =
        Provider.of<CommentViewModel>(context, listen: true);
    UserViewModel _userModel =
        Provider.of<UserViewModel>(context, listen: true);
    double rating = 0;
    if (kitap.rating != "NaN") {
      rating = double.parse(kitap.rating);
    }

    return Container(
        margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(255, 246, 246, 246)),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: size.width < size.height
                      ? size.width / 3
                      : size.height / 3,
                  height: size.width < size.height
                      ? size.height / 4
                      : size.width / 4,
                  child: FadeInImage.assetNetwork(
                      placeholder: 'assets/yukleniyor.jpg',
                      image: kitap.bookImage,
                      fit: BoxFit.contain),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  height: size.width < size.height
                      ? size.height / 4
                      : size.width / 4,
                  margin: const EdgeInsets.only(top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        kitap.title,
                        style: const TextStyle(
                            fontFamily: "Poppins",
                            color: kTextColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                      Wrap(
                        children: [
                          const Text(
                            "Yazar:",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                color: kPrimaryColor,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            kitap.author,
                            style: const TextStyle(
                                fontFamily: "Poppins",
                                color: kTextColor,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Wrap(
                        children: [
                          const Text(
                            "Yayınevi:",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                color: kPrimaryColor,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            kitap.publisher,
                            style: const TextStyle(
                                fontFamily: "Poppins",
                                color: kTextColor,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Değerlendirmeler",
                        style: TextStyle(
                            fontFamily: "Comfortaa",
                            color: kPrimaryColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                        width: 100,
                        child: Divider(
                          color: kPrimaryColor,
                          thickness: 2,
                        ),
                      ),
                      yildizlar(rating == "NaN" ? 0 : rating),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          _commentModel.yorumlariGetir(kitap.id);
                          _commentModel.yildizPuanla(0);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BookDetails(
                                      book: kitap,
                                    )),
                          );
                        },
                        child: Container(
                          width: 200,
                          height: 20,
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Center(
                              child: Text(
                            "Kitabı İncele",
                            style: TextStyle(
                                fontFamily: "Comfortaa",
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () async {
                          bool sonuc = await favoritesViewModel.favoriKaldir(
                              _userModel.users.user["_id"], kitap.id);

                          if (context.mounted) {
                            if (sonuc == true) {
                              // ignore: use_build_context_synchronously
                              aDialog(
                                  "İşlem Başarılı",
                                  "${kitap.title} İsimli Kitap Favorilerden Başarıyla Kaldırıldı.",
                                  context);
                            } else {
                              // ignore: use_build_context_synchronously
                              aDialog(
                                  "İşlem Başarısız",
                                  "${kitap.title} İsimli Kitap Favorilerden Kaldırılamadı!",
                                  context);
                            }
                          }

                          favoritesViewModel
                              .favoriGetir(_userModel.users.user["_id"]);
                        },
                        child: Container(
                          width: 200,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Center(
                              child: Text(
                            "Favorilerden Kaldır",
                            style: TextStyle(
                              fontFamily: "Comfortaa",
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          )),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Visibility(
                    visible: size.width > size.height ? true : false,
                    child: satinAl(context, kitap)),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            Visibility(
              visible: size.height > size.width ? true : false,
              child: const SizedBox(
                height: 10,
              ),
            ),
            Visibility(
                visible: size.height > size.width ? true : false,
                child: satinAl(context, kitap)),
            Visibility(
              visible: size.height > size.width ? true : false,
              child: const SizedBox(
                height: 5,
              ),
            ),
            const SizedBox(
              height: kDefaultPadding,
            )
          ],
        ));
  }

  satinAl(BuildContext context, Book kitap) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width > size.height
          ? ((size.width - ((size.height / 3) + 200))) - 80
          : (size.width - 2 * kDefaultPadding),
      child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 6,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: size.width > size.height
                ? (size.width - ((size.height / 3) + 200)) / 2
                : (size.width - 2 * kDefaultPadding) / 6,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            mainAxisExtent: 50,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                showDialog<void>(
                  context: context,
                  barrierDismissible: true, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        "Kitap Dağı'ndan Ayrılıyorsunuz!",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.black,
                        ),
                      ),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text(
                              kitap.buyLinks[index]["name"] +
                                  " Web Sitesi Açılacak. Onaylıyor musunuz?",
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
                          child: const Text(
                            "Evet",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.black,
                            ),
                          ),
                          onPressed: () async {
                            await launchUrlString(
                              kitap.buyLinks[index]["url"],
                              mode: LaunchMode.externalNonBrowserApplication,
                            );

                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    // color: Color.fromARGB(255, 207, 207, 207),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        width: 1.5,
                        color: const Color.fromARGB(255, 112, 112, 112))),
                child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        kitap.buyLinks[index]["name"],
                        style: const TextStyle(
                          fontSize: 8,
                          color: kPrimaryColor,
                          fontFamily: "Poppins",
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        kitap.buyLinks[index]["linkPrice"] + " TL",
                        style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 10,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
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

  Widget yildizlar(num sayi) {
    sayi = sayi.round();
    return Row(
      children: [
        Icon(
          Icons.star,
          color: sayi >= 1 ? Colors.orange : Colors.grey,
        ),
        Icon(
          Icons.star,
          color: sayi >= 2 ? Colors.orange : Colors.grey,
        ),
        Icon(
          Icons.star,
          color: sayi >= 3 ? Colors.orange : Colors.grey,
        ),
        Icon(
          Icons.star,
          color: sayi >= 4 ? Colors.orange : Colors.grey,
        ),
        Icon(
          Icons.star,
          color: sayi >= 5 ? Colors.orange : Colors.grey,
        ),
      ],
    );
  }
}
