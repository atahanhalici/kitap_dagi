// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kitap_dagi/constants.dart';
import 'package:kitap_dagi/pages/book_details_page.dart';
import 'package:kitap_dagi/pages/favorites_page.dart';
import 'package:kitap_dagi/pages/login_page.dart';
import 'package:kitap_dagi/pages/no_connection.dart';
import 'package:kitap_dagi/pages/profile_page.dart';
import 'package:kitap_dagi/viewmodels/category_viewmodel.dart';
import 'package:kitap_dagi/viewmodels/comment_viewmodel.dart';
import 'package:kitap_dagi/viewmodels/favorites_viewmodel.dart';
import 'package:kitap_dagi/viewmodels/user_viewmodel.dart';
import 'package:kitap_dagi/widgets/appbar.dart';
import 'package:kitap_dagi/widgets/drawer.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CategoryPage extends StatefulWidget {
  final String title;
  const CategoryPage({Key? key, required this.title}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    execute();
    super.initState();
  }

  Future<void> execute() async {
    // ignore: unused_local_variable
    final StreamSubscription<InternetConnectionStatus> listener =
        InternetConnectionChecker().onStatusChange.listen(
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
    UserViewModel _userModel =
        Provider.of<UserViewModel>(context, listen: true);

    CategoryViewModel _categoryModel =
        Provider.of<CategoryViewModel>(context, listen: true);
    FavoritesViewModel _favModel =
        Provider.of<FavoritesViewModel>(context, listen: true);
    return Scaffold(
        appBar: AppBar(
            backgroundColor: kPrimaryColor,
            title: GestureDetector(
                onTap: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text(
                  "Kitap Dağı",
                  style: TextStyle(
                      fontFamily: "Comfortaa", fontWeight: FontWeight.bold),
                )),
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
        drawer: MyDrawer(sayi: 1, gidilecek: widget.title),
        body: SafeArea(
            child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const MyAppBar(sayfa: 0),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding),
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                              fontFamily: "Comfortaa",
                              color: kPrimaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: kDefaultPadding),
                        child: SizedBox(
                          child: Divider(
                            color: kPrimaryColor,
                            thickness: 2,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: kDefaultPadding,
                      ),
                      _categoryModel.state == ViewStatees.geldi
                          ? _categoryModel.kitaplar.isEmpty
                              ? Container(
                                  height: 100,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: kDefaultPadding,
                                      vertical: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color.fromARGB(
                                          255, 207, 207, 207)),
                                  child: const Center(
                                    child: Text(
                                      "Aradığınız İsimde Kitap Bulunamadı",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              : Kitaplar(context)
                          : kitaplarYukleniyor(),
                    ]))));
  }

  // ignore: non_constant_identifier_names
  Widget Kitaplar(BuildContext context) {
    CategoryViewModel _categoryModel =
        Provider.of<CategoryViewModel>(context, listen: true);
    CommentViewModel _commentModel =
        Provider.of<CommentViewModel>(context, listen: true);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Column(
        children: [
          GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount:
                  _categoryModel.kitaplar.length - _categoryModel.baslama >= 20
                      ? 20
                      : _categoryModel.kitaplar.length - _categoryModel.baslama,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 260,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  mainAxisExtent: 295),
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      _commentModel.yorumlariGetir(_categoryModel
                          .kitaplar[index + _categoryModel.baslama].id);
                      _commentModel.yildizPuanla(0);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BookDetails(
                                  book: _categoryModel
                                      .kitaplar[index + _categoryModel.baslama],
                                )),
                      );
                    },
                    child: Container(
                      // height: 295,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 207, 207, 207),
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FadeInImage.assetNetwork(
                                placeholder: 'assets/yukleniyor.jpg',
                                image: _categoryModel
                                    .kitaplar[index + _categoryModel.baslama]
                                    .bookImage,
                                height: 200,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  // book.title,
                                  _categoryModel
                                      .kitaplar[index + _categoryModel.baslama]
                                      .title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontFamily: "Poppins",
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  // book.author,
                                  _categoryModel
                                      .kitaplar[index + _categoryModel.baslama]
                                      .author,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontFamily: "Poppins",
                                      color: kPrimaryColor,
                                      fontSize: 13),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ));
              }),
          const SizedBox(
            height: kDefaultPadding,
          ),
          sayfalama(_categoryModel),
          const SizedBox(
            height: kDefaultPadding,
          ),
        ],
      ),
    );
  }

  kitaplarYukleniyor() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 10,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 260,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              mainAxisExtent: 295),
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              period: const Duration(milliseconds: 1000),
              baseColor: const Color.fromARGB(255, 205, 205, 205),
              highlightColor: const Color.fromARGB(255, 214, 214, 214),
              direction: ShimmerDirection.ltr,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 207, 207, 207),
                    borderRadius: BorderRadius.circular(10)),
              ),
            );
          }),
    );
  }

  sayfalama(CategoryViewModel categoryViewModel) {
    return SizedBox(
      height: 30,
      child: ListView.builder(
          itemCount: categoryViewModel.kitaplar.length % 20 != 0
              ? ((categoryViewModel.kitaplar.length / 20) + 1).toInt()
              // ignore: division_optimization
              : (categoryViewModel.kitaplar.length / 20).toInt(),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {});
                categoryViewModel.baslama = index * 20;
                _scrollController
                    .jumpTo(_scrollController.position.minScrollExtent);
              },
              child: Row(
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: categoryViewModel.baslama / 20 == index
                              ? kPrimaryColor
                              : Colors.white),
                      child: Text(
                        "${index + 1}",
                        style: TextStyle(
                            fontFamily: "Comfortaa",
                            color: categoryViewModel.baslama / 20 == index
                                ? Colors.white
                                : Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
