import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kitap_dagi/models/book.dart';
import 'package:kitap_dagi/pages/comments_details_page.dart';
import 'package:kitap_dagi/pages/favorites_page.dart';
import 'package:kitap_dagi/pages/login_page.dart';
import 'package:kitap_dagi/pages/profile_page.dart';
import 'package:kitap_dagi/viewmodels/comment_viewmodel.dart';
import 'package:kitap_dagi/viewmodels/favorites_viewmodel.dart';
import 'package:kitap_dagi/widgets/appbar.dart';
import 'package:kitap_dagi/widgets/drawer.dart';
import 'package:kitap_dagi/widgets/kitap_slider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../constants.dart';
import '../viewmodels/main_viewmodel.dart';
import '../viewmodels/user_viewmodel.dart';

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
  double ortalama = 0;

  @override
  Widget build(BuildContext context) {
    CommentViewModel _commentModel =
        Provider.of<CommentViewModel>(context, listen: true);
    UserViewModel _userModel =
        Provider.of<UserViewModel>(context, listen: true);
    MainViewModel _mainModel =
        Provider.of<MainViewModel>(context, listen: true);
    FavoritesViewModel _favModel =
        Provider.of<FavoritesViewModel>(context, listen: true);
    Size size = MediaQuery.of(context).size;
    ortalamaHesapla(_commentModel);
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
      drawer: const MyDrawer(sayi: 0, gidilecek: "",),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const MyAppBar(sayfa: 0,),
            _mainModel.state == ViewState.geldi
                ? kitap()
                : Center(
                    child: CircularProgressIndicator(),
                  )
          ],
        ),
      )),
    );
  }

  Widget kitap() {
    CommentViewModel _commentModel =
        Provider.of<CommentViewModel>(context, listen: true);
    UserViewModel _userModel =
        Provider.of<UserViewModel>(context, listen: true);
    MainViewModel _mainModel =
        Provider.of<MainViewModel>(context, listen: true);
    FavoritesViewModel _favModel =
        Provider.of<FavoritesViewModel>(context, listen: true);
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
                        child: Image.network(
                          widget.book.bookImage,
                          fit: BoxFit.contain,
                        ),
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
                      padding: const EdgeInsets.only(
                          left: kDefaultPadding, right: kDefaultPadding / 2),
                      child: SizedBox(
                          width: (size.height / 1.5) - 10,
                          height: (size.width / 2) - 10,
                          child: Image.network(
                            widget.book.bookImage,
                            fit: BoxFit.contain,
                          ))),
                  Padding(
                    padding: const EdgeInsets.only(right: kDefaultPadding),
                    child: SizedBox(
                      width: size.width -
                          (2 * kDefaultPadding) -
                          (size.height / 1.5),
                      child: bilgiler(_commentModel),
                    ),
                  )
                ],
              ),
        const SizedBox(
          height: kDefaultPadding,
        ),
        _commentModel.state == ViewStates.geldi
            ? KitapSlider(
                size: size,
                asd: _commentModel.onerilenKitap,
                baslik: "Öneriler",
                cizgiUzunluk: 75,
              )
            : CircularProgressIndicator(),
        const SizedBox(
          height: kDefaultPadding,
        ),
        _commentModel.state == ViewStates.geldi
            ? _commentModel.comments.yorumSayisi > 0
                ? yorumlar(size, _commentModel)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: kDefaultPadding),
                        child: Text(
                          "Yorumlar",
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: kDefaultPadding),
                        child: SizedBox(
                          width: 65,
                          child: Divider(
                            color: kPrimaryColor,
                            thickness: 2,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
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
                      ),
                    ],
                  )
            : Container(),
        const SizedBox(
          height: kDefaultPadding,
        ),
        _userModel.users.durum == true
            ? yorumyap(size, _commentModel, widget.book, _userModel)
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: Text(
                      "Yorum Yap",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: const SizedBox(
                      width: 75,
                      child: Divider(
                        color: kPrimaryColor,
                        thickness: 2,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 214, 214, 214),
                        borderRadius: BorderRadius.circular(10)),
                    height: size.height / 4,
                    child: Center(
                      child: Text(
                        "Yorum Yapabilmek İçin Oturum Açmanız Gerekmektedir!",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
        const SizedBox(
          height: kDefaultPadding,
        ),
      ],
    );
  }

  Column bilgiler(CommentViewModel commentModel) {
    FavoritesViewModel _favModel =
        Provider.of<FavoritesViewModel>(context, listen: true);
    UserViewModel _userModel =
        Provider.of<UserViewModel>(context, listen: true);
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
                widget.book.publisher,
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
                  yildizlar(ortalama != null ? ortalama : 0.0
                      /* widget.book.rating != "NaN"
                      ? double.parse(widget.book.rating)
                      : 0.0*/
                      ),
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
        const SizedBox(
          height: kDefaultPadding,
        ),
        satinAl(widget.book),
        const SizedBox(
          height: kDefaultPadding - 5,
        ),
        TextButton(
            onPressed: () async {
              var sonuc = await _favModel.favoriEkle(
                  _userModel.users.user["_id"], widget.book.id);
              if (context.mounted) {
                sonuc["durum"] == true
                    ? aDialog(
                        "Favorilere Ekle",
                        "${widget.book.title} İsimli Kitap Favorilere Eklendi",
                        context)
                    : aDialog("Favorilere Ekle", "${sonuc["mesaj"]}", context);
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width - (2 * kDefaultPadding),
              height: 50,
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                  child: Text(
                "Favorilere Ekle",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )),
            )),
      ],
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
              color: Colors.black,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  icerik,
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
                  Navigator.pop(context);
                }),
          ],
        );
      },
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
                              GestureDetector(
                                onTap: () {
                                  commentModel.baslama = 0;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CommentsDetails(
                                              book: widget.book,
                                              comments: commentModel.comments,
                                              ortalama: ortalama,
                                            )),
                                  );
                                },
                                child: Row(
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
                                ),
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
                              itemCount: commentModel.comments.yorumSayisi >= 4
                                  ? 4
                                  : commentModel.comments.yorumSayisi,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                DateTime dt = DateTime.parse(commentModel
                                    .comments.yorumlar[index]["createdAt"]);
                                Intl.defaultLocale = 'tr';
                                String formattedDate =
                                    DateFormat("dd MMMM yyyy").format(dt);
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
                                                  commentModel.comments
                                                              .yorumlar[index]
                                                          ["nameSurname"] ??
                                                      "",
                                                  style: TextStyle(
                                                      color: kTextColor,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(child: SizedBox()),
                                                SizedBox(
                                                  width: 120,
                                                  child: yildizlar(commentModel
                                                                  .comments
                                                                  .yorumlar[
                                                              index]["rank"] !=
                                                          ""
                                                      ? double.parse(
                                                          commentModel.comments
                                                                  .yorumlar[
                                                              index]["rank"])
                                                      : 0.0),
                                                ),
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
                                          Text(commentModel.comments
                                              .yorumlar[index]["desc"]),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                formattedDate,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
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

  yorumyap(Size size, CommentViewModel commentModel, Book book,
      UserViewModel userModel) {
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
                  String adSoyad = userModel.users.user["name"] +
                      " " +
                      userModel.users.user["surname"];
                  commentModel.yorumYap(title, desc, book.id, adSoyad);
                  ortalamaHesapla(commentModel);
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

  satinAl(
    Book book,
  ) {
    Size size = MediaQuery.of(context).size;
    return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: book.buyLinks.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: size.width < size.height
              ? (size.width -
                      (2 * kDefaultPadding) -
                      ((book.buyLinks.length - 1) * 5)) /
                  book.buyLinks.length
              : (size.width -
                      (size.height / 1.5) -
                      (2 * kDefaultPadding) -
                      ((book.buyLinks.length - 1) * 5)) /
                  book.buyLinks.length,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          mainAxisExtent: size.width < size.height
              ? (size.width -
                      (2 * kDefaultPadding) -
                      ((book.buyLinks.length - 1) * 5)) /
                  book.buyLinks.length
              : (size.width -
                      (size.height / 1.5) -
                      (2 * kDefaultPadding) -
                      ((book.buyLinks.length - 1) * 5)) /
                  book.buyLinks.length,
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
                        color: Colors.black,
                      ),
                    ),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text(
                            book.buyLinks[index]["name"] +
                                " Web Sitesi Açılacak. Onaylıyor musunuz?",
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
                          "Hayır",
                          style: TextStyle(
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
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () async {
                          await launchUrlString(
                            widget.book.buyLinks[index]["url"],
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
                      width: 1.5, color: Color.fromARGB(255, 112, 112, 112))),
              child: Padding(
                padding: const EdgeInsets.all(1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      book.buyLinks[index]["name"],
                      style: TextStyle(fontSize: 10, color: kPrimaryColor),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      book.buyLinks[index]["linkPrice"] + " TL",
                      style: TextStyle(
                          fontSize: 12,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void ortalamaHesapla(CommentViewModel commentViewModel) {
    ortalama = 0;
    if (commentViewModel.comments.yorumlar.isNotEmpty) {
      for (int i = 0; i < commentViewModel.comments.yorumlar.length; i++) {
        ortalama =
            ortalama + int.parse(commentViewModel.comments.yorumlar[i]["rank"]);
      }
      ortalama = ortalama / commentViewModel.comments.yorumlar.length;
    }
  }
}
