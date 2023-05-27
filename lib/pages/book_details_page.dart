import 'package:flutter/material.dart';
import 'package:kitap_dagi/widgets/appbar.dart';
import 'package:kitap_dagi/widgets/drawer.dart';

import '../constants.dart';

class BookDetails extends StatelessWidget {
  final dynamic book;
  const BookDetails({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(backgroundColor: kPrimaryColor, elevation: 0, actions: [
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
                              child: Image.network(book["book_image"]),
                            ),
                          ),
                          const SizedBox(
                            height: kDefaultPadding,
                          ),
                          bilgiler(),
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
                                  child: Image.network(book["book_image"])),
                            )),
                        SizedBox(
                          width: size.width -
                              (2 * kDefaultPadding) -
                              (size.height / 1.5),
                          child: bilgiler(),
                        )
                      ],
                    ),
              const SizedBox(
                height: kDefaultPadding,
              ),
              yorumlar(size),
              const SizedBox(
                height: kDefaultPadding,
              ),
              yorumyap(size),
              const SizedBox(
                height: kDefaultPadding,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column bilgiler() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          book["title"],
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
                book["author"],
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
                book["publisher"],
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
        Row(
          children: [yildizlar(double.parse(book["rating"])), Text("(16)")],
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
                book["description"],
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
                book["book_image_height"] +
                    " x " +
                    book["book_image_width"] +
                    " mm",
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

  yorumlar(Size size) {
    return Padding(
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
                        itemCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(kDefaultPadding / 2),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 223, 223, 223),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: size.width -
                                          (2 * kDefaultPadding) -
                                          kDefaultPadding,
                                      child: Wrap(
                                        direction: Axis.horizontal,
                                        alignment: WrapAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Atahan Halıcı",
                                            style: TextStyle(
                                                color: kTextColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Expanded(child: SizedBox()),
                                          SizedBox(
                                              width: 120,
                                              child: yildizlar(double.parse(
                                                  book["rating"]))),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "Title",
                                      style: TextStyle(
                                          color: kTextColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                        "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quo fugiat dolore doloribus est officiis, nisi, maiores quisquam rem, rerum exercitationem non illo. Dicta reprehenderit maxime, iusto vitae ratione eos eligendi.")
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

  yorumyap(Size size) {
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
            validator: (deger) {},
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
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
            validator: (deger) {},
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.star,
                  size: 30,
                  color: Colors.grey,
                ),
                Icon(
                  Icons.star,
                  size: 30,
                  color: Colors.grey,
                ),
                Icon(
                  Icons.star,
                  size: 30,
                  color: Colors.grey,
                ),
                Icon(
                  Icons.star,
                  size: 30,
                  color: Colors.grey,
                ),
                Icon(
                  Icons.star,
                  size: 30,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextButton(
              onPressed: () {},
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
