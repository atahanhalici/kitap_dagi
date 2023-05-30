import 'package:flutter/material.dart';
import 'package:kitap_dagi/constants.dart';
import 'package:kitap_dagi/viewmodels/comment_viewmodel.dart';
import 'package:kitap_dagi/widgets/yorumlar.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../models/comment.dart';
import '../widgets/appbar.dart';
import '../widgets/drawer.dart';

class CommentsDetails extends StatefulWidget {
  final Book book;
  final Comments comments;
  const CommentsDetails({Key? key, required this.book, required this.comments})
      : super(key: key);

  @override
  State<CommentsDetails> createState() => _CommentsDetailsState();
}

class _CommentsDetailsState extends State<CommentsDetails> {
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding),
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
                          degerlendirmeOzet(
                              widget.comments, size, _commentModel),
                        ],
                      ),
                    )
                  : Row(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(
                                left: kDefaultPadding,
                                right: kDefaultPadding / 2),
                            child: SizedBox(
                                width: (size.height / 1.5) - 10,
                                height: (size.width / 2) - 10,
                                child: Image.network(
                                  widget.book.bookImage,
                                ))),
                        Padding(
                          padding:
                              const EdgeInsets.only(right: kDefaultPadding),
                          child: SizedBox(
                            width: size.width -
                                (2 * kDefaultPadding) -
                                (size.height / 1.5),
                            child: degerlendirmeOzet(
                                widget.comments, size, _commentModel),
                          ),
                        )
                      ],
                    ),
              const SizedBox(
                height: kDefaultPadding,
              ),
              YorumlarWidget(
                baslama: _commentModel.baslama,
              ),
              const SizedBox(
                height: kDefaultPadding / 2,
              ),
              Sayfalama(widget.comments, _commentModel),
              const SizedBox(
                height: kDefaultPadding,
              ),
            ]))));
  }

  Sayfalama(Comments comments, CommentViewModel commentViewModel) {
    return SizedBox(
      height: 30,
      child: ListView.builder(
          itemCount: ((comments.yorumlar.length / 10) + 1).toInt(),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {});
                commentViewModel.baslama = index * 10;
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: commentViewModel.baslama / 10 == index
                              ? kPrimaryColor
                              : Colors.white),
                      child: Text(
                        "${index + 1}",
                        style: TextStyle(
                            color: commentViewModel.baslama / 10 == index
                                ? Colors.white
                                : Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            );
          }),
    );
  }

  degerlendirmeOzet(
      Comments comments, Size size, CommentViewModel commentModel) {
    double bookRating = double.parse(widget.book.rating);
    return Column(
      children: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Container(
              width: (size.width / 2) - (2 * kDefaultPadding),
              height: 35,
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                  child: Text(
                "Kitap Detayına Dön",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              )),
            )),
        SizedBox(
          height: kDefaultPadding,
        ),
        Text(
          widget.book.title,
          style: TextStyle(
              color: kPrimaryColor, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: size.width - 2 * kDefaultPadding,
          child: Divider(
            color: kPrimaryColor,
            thickness: 2,
          ),
        ),
        SizedBox(
          height: kDefaultPadding,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 214, 214, 214),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  spreadRadius: 2.0,
                ), //BoxShadow
              ],
              borderRadius: BorderRadius.circular(10)),
          width: size.width > size.height ? size.height / 3 : size.width / 3,
          height: size.width > size.height ? size.height / 3 : size.width / 3,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.book.rating,
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star,
                    color: bookRating >= 1 ? Colors.orange : Colors.grey,
                  ),
                  Icon(
                    Icons.star,
                    color: bookRating >= 2 ? Colors.orange : Colors.grey,
                  ),
                  Icon(
                    Icons.star,
                    color: bookRating >= 3 ? Colors.orange : Colors.grey,
                  ),
                  Icon(
                    Icons.star,
                    color: bookRating >= 4 ? Colors.orange : Colors.grey,
                  ),
                  Icon(
                    Icons.star,
                    color: bookRating >= 5 ? Colors.orange : Colors.grey,
                  ),
                ],
              )
            ],
          )),
        ),
        SizedBox(
          height: kDefaultPadding,
        ),
        Text(
          "(" +
              commentModel.comments.yorumSayisi.toString() +
              " Değerlendirme)",
          style: TextStyle(
              color: Color.fromARGB(255, 70, 70, 70),
              fontSize: 15,
              fontWeight: FontWeight.bold),
        ),
        cizelge(size, commentModel),
        SizedBox(
          height: kDefaultPadding,
        ),
      ],
    );
  }

  cizelge(Size size, CommentViewModel commentModel) {
    return SizedBox(
      height: 65,
      child: ListView.builder(
          itemCount: 5,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(border: Border.all()),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 2.5),
                    child: Row(
                      children: [
                        Text(
                          "${index + 1}",
                          style: TextStyle(fontSize: 18),
                        ),
                        const Icon(
                          Icons.star,
                          color: Colors.orange,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 45,
                    height: 2,
                    child: Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(bottom: 5, left: 5, right: 5, top: 2.5),
                    child: Text(
                      index + 1 == 1
                          ? commentModel.biryildiz.toString()
                          : index + 1 == 2
                              ? commentModel.ikiyildiz.toString()
                              : index + 1 == 3
                                  ? commentModel.ucyildiz.toString()
                                  : index + 1 == 4
                                      ? commentModel.dortyildiz.toString()
                                      : index + 1 == 5
                                          ? commentModel.besyildiz.toString()
                                          : "",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
