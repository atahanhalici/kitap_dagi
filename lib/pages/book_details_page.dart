import 'package:flutter/material.dart';
import 'package:kitap_dagi/models/book.dart';
import 'package:kitap_dagi/viewmodels/comment_viewmodel.dart';
import 'package:kitap_dagi/widgets/appbar.dart';
import 'package:kitap_dagi/widgets/drawer.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class BookDetails extends StatefulWidget {
  final Book book;
  const BookDetails({Key? key, required this.book}) : super(key: key);

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  String title = "", desc = "";
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CommentViewModel _commentModel =
        Provider.of<CommentViewModel>(context, listen: true);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text(widget.book.title),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.favorite)),
            IconButton(onPressed: () {}, icon: Icon(Icons.person))
          ]),
      drawerEnableOpenDragGesture: true,
      drawer: const MyDrawer(),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const MyAppBar(),
            size.width < size.height
                ? Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: size.width / 1.5,
                            height: size.height / 2,
                            child: Image.network(widget.book.bookImage),
                          ),
                        ),
                        const SizedBox(
                          height: kDefaultPadding,
                        ),
                        bilgiler(_commentModel),
                      ],
                    ),
                  )
                : Row(
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultPadding),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                                width: size.height / 1.5,
                                height: size.width / 2,
                                child: Image.network(widget.book.bookImage)),
                          )),
                      SizedBox(
                        width: size.width -
                            (2 * kDefaultPadding) -
                            (size.height / 1.5),
                        child: bilgiler(_commentModel),
                      )
                    ],
                  ),
            const SizedBox(
              height: kDefaultPadding,
            ),
            _commentModel.state == ViewStates.geldi
                ? _commentModel.comments.yorumSayisi > 0
                    ? yorumlar(size, _commentModel)
                    : Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: kDefaultPadding),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 214, 214, 214),
                            borderRadius: BorderRadius.circular(10)),
                        height: size.height / 4,
                        child: Center(
                          child: Text(
                            "Bu Kitap İçin Herhangi Bir Yorum Bulunmamaktadır!",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
            const SizedBox(
              height: kDefaultPadding,
            ),
            yorumyap(size, _commentModel, widget.book),
            const SizedBox(
              height: kDefaultPadding,
            ),
          ],
        ),
      )),
    );
  }

  Column bilgiler(CommentViewModel commentModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.book.title,
          style: const TextStyle(
              color: kTextColor, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              const Text(
                "Yazar:",
                style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                widget.book.author,
                style: const TextStyle(
                    color: kTextColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              const Text(
                "Yayınevi:",
                style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                widget.book.author,
                style: const TextStyle(
                    color: kTextColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "Değerlendirmeler",
          style: TextStyle(
              color: kPrimaryColor, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          width: 120,
          child: Divider(
            color: kPrimaryColor,
            thickness: 2,
          ),
        ),
        commentModel.state == ViewStates.geldi
            ? Row(
                children: [
                  yildizlar(widget.book.rating != "NaN"
                      ? double.parse(widget.book.rating)
                      : 0.0),
                  Text("(" + commentModel.comments.yorumSayisi.toString() + ")")
                ],
              )
            : Container(),
        const SizedBox(
          height: 10,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              Text(
                "Açıklama:",
                style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                widget.book.description,
                style: TextStyle(
                    color: kTextColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              Text(
                "Kitap Boyutu:",
                style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "${widget.book.bookImageHeight} x ${widget.book.bookImageWidth} mm",
                style: TextStyle(
                    color: kTextColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ],
    );
  }

  yorumlar(Size size, CommentViewModel commentModel) {
    return commentModel.comments.yorumSayisi > 0
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: size.width - 2 * kDefaultPadding,
                          child: Row(
                            children: [
                              const Text(
                                "Yorumlar",
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              Expanded(child: SizedBox()),
                              Row(
                                children: const [
                                  Text(
                                    "Tüm Yorumları Görüntüle",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey,
                                    size: 15,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: size.width - 2 * kDefaultPadding,
                          child: Divider(
                            color: kPrimaryColor,
                            thickness: 2,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: size.width - 2 * kDefaultPadding,
                          child: ListView.builder(
                              itemCount: commentModel.comments.yorumSayisi >= 2
                                  ? 2
                                  : commentModel.comments.yorumSayisi,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.all(kDefaultPadding / 2),
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 223, 223, 223),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: size.width -
                                                (2 * kDefaultPadding) -
                                                kDefaultPadding,
                                            child: Wrap(
                                              direction: Axis.horizontal,
                                              alignment:
                                                  WrapAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "Atahan Halıcı",
                                                  style: TextStyle(
                                                      color: kTextColor,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(child: SizedBox()),
                                                SizedBox(
                                                    width: 120,
                                                    child: yildizlar(double
                                                        .parse(commentModel
                                                                .comments
                                                                .yorumlar[index]
                                                            ["rank"]))),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            commentModel.comments
                                                .yorumlar[index]["title"],
                                            style: TextStyle(
                                                color: kTextColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(commentModel
                                              .comments.yorumlar[index]["desc"])
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    )
                                  ],
                                );
                              }),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        : Container();
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

  yorumyap(Size size, CommentViewModel commentModel, Book book) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Yorum Yap",
            style: TextStyle(
                color: kPrimaryColor,
                fontSize: 15,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            width: 75,
            child: Divider(
              color: kPrimaryColor,
              thickness: 2,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _titleController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            cursorColor: Colors.black,
            maxLines: 1,
            decoration: const InputDecoration(
              labelText: "Başlık",
              labelStyle: TextStyle(color: Colors.black),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kPrimaryColor)),
              errorBorder:
                  OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
              border: OutlineInputBorder(),
            ),
            validator: (deger) {
              title = deger!;
              deger = "";
            },
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _descController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            cursorColor: Colors.black,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: "Yorumunuz",
              labelStyle: TextStyle(color: Colors.black),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kPrimaryColor)),
              errorBorder:
                  OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
              border: OutlineInputBorder(),
            ),
            validator: (deger) {
              desc = deger!;
              deger = "";
            },
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {});
                    commentModel.yildizPuanla(1);
                  },
                  child: Icon(
                    Icons.star,
                    size: 30,
                    color: commentModel.verilenYildiz < 1
                        ? Colors.grey
                        : Colors.orange,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {});
                    commentModel.yildizPuanla(2);
                  },
                  child: Icon(
                    Icons.star,
                    size: 30,
                    color: commentModel.verilenYildiz < 2
                        ? Colors.grey
                        : Colors.orange,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {});
                    commentModel.yildizPuanla(3);
                  },
                  child: Icon(
                    Icons.star,
                    size: 30,
                    color: commentModel.verilenYildiz < 3
                        ? Colors.grey
                        : Colors.orange,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {});
                    commentModel.yildizPuanla(4);
                  },
                  child: Icon(
                    Icons.star,
                    size: 30,
                    color: commentModel.verilenYildiz < 4
                        ? Colors.grey
                        : Colors.orange,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {});
                    commentModel.yildizPuanla(5);
                  },
                  child: Icon(
                    Icons.star,
                    size: 30,
                    color: commentModel.verilenYildiz < 5
                        ? Colors.grey
                        : Colors.orange,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextButton(
              onPressed: () {
                if (_titleController.text != "" && _descController.text != "") {
                  commentModel.yorumYap(title, desc, book.id);
                  _descController.text = "";
                  _titleController.text = "";
                  commentModel.yildizPuanla(0);
                }
              },
              child: Container(
                width: size.width - (2 * kDefaultPadding),
                height: 50,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                    child: Text(
                  "Yorum Yap",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )),
              )),
        ],
      ),
    );
  }
}
