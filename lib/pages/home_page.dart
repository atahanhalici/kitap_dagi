import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:kitap_dagi/pages/book_details_page.dart';
import 'package:kitap_dagi/pages/registration.dart';
import 'package:kitap_dagi/viewmodels/main_viewmodel.dart';
import 'package:kitap_dagi/widgets/appbar.dart';
import 'package:kitap_dagi/widgets/drawer.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/book.dart';
import '../viewmodels/comment_viewmodel.dart';
import '../widgets/kitap_slider.dart';
import 'login_page.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MainViewModel _mainModel =
        Provider.of<MainViewModel>(context, listen: true);
    CommentViewModel _commentModel =
        Provider.of<CommentViewModel>(context, listen: true);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text("Kitap Dağı"),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.favorite)),
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                icon: Icon(Icons.person))
          ]),
      drawerEnableOpenDragGesture: true,
      drawer: const MyDrawer(),
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
                        const MyAppBar(),
                        slider(size),
                        KitapSlider(
                          size: size,
                          asd: _mainModel.sizinicin,
                          baslik: "Sizin İçin Seçtiklerimiz",
                          cizgiUzunluk: 160,
                        ),
                        //buildBook(size, "Sizin İçin Seçtiklerimiz",
                        //  _mainModel.asd, 0),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: kDefaultPadding / 2),
                          child: SizedBox(
                            width: size.width / 1.5,
                            child: Divider(
                              thickness: 2,
                            ),
                          ),
                        ),
                        KitapSlider(
                          size: size,
                          asd: _mainModel.coksatan,
                          baslik: "Çok Satan Kitaplar",
                          cizgiUzunluk: 130,
                        ),

                        //  buildBook(
                        //   size, "Çok Satan Kitaplar", _mainModel.asd, 7),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: kDefaultPadding / 2),
                          child: SizedBox(
                            width: size.width / 1.5,
                            child: Divider(
                              thickness: 2,
                            ),
                          ),
                        ),
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

/*  Widget firsatlar(Size size, String resim) {
    if (size.width < size.height) {
      return Container(
        height: size.height / 4,
        margin: EdgeInsets.only(
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
                resim,
              ),
            )),
      );
    } else {
      return Container(
        height: size.width / 4,
        margin: EdgeInsets.all(kDefaultPadding),
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
                resim,
              ),
            )),
      );
    }
  }
*/
  /* Widget buildBook(Size size, String baslik, List<Book> asd) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            baslik,
            style: const TextStyle(color: kPrimaryColor, fontSize: 15),
          ),
          const SizedBox(
            width: 150,
            child: Divider(
              color: kPrimaryColor,
              thickness: 2,
            ),
          ),
          SizedBox(
            height: 270,
            child: ListView.builder(
                itemCount: 7,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BookDetails(
                                  book: asd[index + baslama],
                                )),
                      );
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 130,
                          height: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Image.network(
                                asd[index + baslama].bookImage,
                                // "assets/harry.jpg",
                                //height: 190,
                                width: 130,
                                height: 200,
                                fit: BoxFit.contain,
                              ),
                              Text(
                                asd[index + baslama].title,
                                style: const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14),
                              ),
                              Text(
                                asd[index + baslama].author,
                                style: const TextStyle(
                                    color: kPrimaryColor, fontSize: 13),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: kDefaultPadding / 2,
                        )
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
*/
}

slider(Size size) {
  return CarouselSlider(
    options: CarouselOptions(
        viewportFraction: 1,
        height: size.height > size.width ? size.height / 3.5 : size.width / 3.5,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 7)),
    items: imgList.map((imgAsset) {
      return Builder(
        builder: (BuildContext context) {
          return Container(
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
