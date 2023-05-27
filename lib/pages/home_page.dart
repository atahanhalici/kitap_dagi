import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:kitap_dagi/pages/book_details_page.dart';
import 'package:kitap_dagi/viewmodels/main_viewmodel.dart';
import 'package:kitap_dagi/widgets/appbar.dart';
import 'package:kitap_dagi/widgets/drawer.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/book.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MainViewModel _mainModel =
        Provider.of<MainViewModel>(context, listen: true);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(backgroundColor: kPrimaryColor, elevation: 0, actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.favorite)),
        IconButton(onPressed: () {}, icon: Icon(Icons.person))
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
                        buildBook(size, "Sizin İçin Seçtiklerimiz",
                            _mainModel.asd, 0),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: kDefaultPadding / 2),
                          child: SizedBox(
                            width: 275,
                            child: Divider(
                              thickness: 2,
                            ),
                          ),
                        ),
                        buildBook(
                            size, "Çok Satan Kitaplar", _mainModel.asd, 7),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: kDefaultPadding / 2),
                          child: SizedBox(
                            width: 275,
                            child: Divider(
                              thickness: 2,
                            ),
                          ),
                        ),
                        buildBook(
                            size, "Yeni Çıkan Kitaplar", _mainModel.asd, 14),
                        const SizedBox(
                          height: kDefaultPadding,
                        ),
                        /* const Padding(
                padding: EdgeInsets.only(left: kDefaultPadding),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Daha Fazlası İçin",
                    style: TextStyle(color: kPrimaryColor, fontSize: 15),
                  ),
                ),
              ),
              const Padding(
                padding: const EdgeInsets.only(left: kDefaultPadding),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 175,
                    child: Divider(
                      color: kPrimaryColor,
                      thickness: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: kDefaultPadding / 2,
              ),*/
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
  Widget buildBook(Size size, String baslik, List<Book> asd, int baslama) {
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
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BookDetails(
                                      book: asd[index + baslama],
                                    )),
                          );
                        },
                        child: SizedBox(
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
                      ),
                      const SizedBox(
                        width: kDefaultPadding / 2,
                      )
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }

  slider(Size size) {
    return CarouselSlider(
      options: CarouselOptions(
          viewportFraction: 1,
          height:
              size.height > size.width ? size.height / 3.5 : size.width / 3.5,
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
}
