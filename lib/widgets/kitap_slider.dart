import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:kitap_dagi/constants.dart';
import 'package:kitap_dagi/models/book.dart';
import 'package:kitap_dagi/pages/book_details_page.dart';
import 'package:kitap_dagi/viewmodels/comment_viewmodel.dart';
import 'package:provider/provider.dart';

class KitapSlider extends StatefulWidget {
  final Size size;
  final List<Book> asd;
  final String baslik;
  final double cizgiUzunluk;
  const KitapSlider(
      {Key? key,
      required this.size,
      required this.asd,
      required this.baslik,
      required this.cizgiUzunluk})
      : super(key: key);

  @override
  State<KitapSlider> createState() => _KitapSliderState();
}

class _KitapSliderState extends State<KitapSlider> {
  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    CommentViewModel _commentModel =
        Provider.of<CommentViewModel>(context, listen: true);
    Size size = MediaQuery.of(context).size;
    double mywidth = (size.width - (2 * kDefaultPadding)) / 150;
    mywidth = mywidth.ceil().toDouble();
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Column(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.baslik,
                style: const TextStyle(
                    fontFamily: "Poppins",
                    color: kPrimaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: widget.cizgiUzunluk,
                child: const Divider(
                  color: kPrimaryColor,
                  thickness: 2,
                ),
              ),
              CarouselSlider(
                options: CarouselOptions(
                    viewportFraction: 1 / mywidth,
                    height: 280,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 7)),
                items: widget.asd.map((book) {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          _commentModel.yorumlariGetir(book.id);
                          _commentModel.yildizPuanla(0);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BookDetails(
                                      book: book,
                                    )),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: SizedBox(
                            width: 130,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                FadeInImage.assetNetwork(
                                  placeholder: 'assets/yukleniyor.jpg',
                                  image: book.bookImage,
                                  width: 130,
                                  height: 200,
                                  fit: BoxFit.contain,
                                ),
                                Text(
                                  book.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontFamily: "Poppins",
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13),
                                ),
                                Text(
                                  book.author,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontFamily: "Poppins",
                                      color: kPrimaryColor,
                                      fontSize: 12),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ]));
  }
}
