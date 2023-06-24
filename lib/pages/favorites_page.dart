import 'package:flutter/material.dart';
import 'package:kitap_dagi/constants.dart';
import 'package:kitap_dagi/pages/profile_page.dart';
import 'package:kitap_dagi/widgets/appbar.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../widgets/drawer.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilPage()),
                    );
                  },
                  icon: Icon(Icons.person))
            ]),
        drawerEnableOpenDragGesture: true,
        drawer: const MyDrawer(),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
              const MyAppBar(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Text(
                  "Favorilerim",
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: const SizedBox(
                  width: 100,
                  child: Divider(
                    color: kPrimaryColor,
                    thickness: 2,
                  ),
                ),
              ),
              Favori(size, context),
              SizedBox(
                height: kDefaultPadding,
              ),
              Favori(size, context),
              SizedBox(
                height: kDefaultPadding,
              ),
              Favori(size, context),
            ]))));
  }

  Container Favori(Size size, BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color.fromARGB(255, 207, 207, 207)),
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
                    child: Image.asset(
                      "assets/harry.jpg",
                      fit: BoxFit.contain,
                    )),
                Expanded(
                  child: Container(
                    height: size.width < size.height
                        ? size.height / 4
                        : size.width / 4,
                    margin: EdgeInsets.only(top: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Harry Potter ve Ölüm Yadigârları",
                          style: const TextStyle(
                              color: kTextColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                        Wrap(
                          children: [
                            const Text(
                              "Yazar:",
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "J.K. Rowling",
                              style: const TextStyle(
                                  color: kTextColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Wrap(
                          children: [
                            const Text(
                              "Yayınevi:",
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Yapı Kredi Yayınları",
                              style: const TextStyle(
                                  color: kTextColor,
                                  fontSize: 10,
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
                              color: kPrimaryColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                          width: 80,
                          child: Divider(
                            color: kPrimaryColor,
                            thickness: 2,
                          ),
                        ),
                        yildizlar(0),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {},
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
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            )),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {},
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
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            )),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Visibility(
                    visible: size.width > size.height ? true : false,
                    child: satinAl(context)),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            Visibility(
              visible: size.height > size.width ? true : false,
              child: SizedBox(
                height: 10,
              ),
            ),
            Visibility(
                visible: size.height > size.width ? true : false,
                child: satinAl(context)),
            Visibility(
              visible: size.height > size.width ? true : false,
              child: SizedBox(
                height: 5,
              ),
            ),
          ],
        ));
  }

  satinAl(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width > size.height
          ? (size.width - ((size.height / 3) + 200))
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
                          color: Colors.black,
                        ),
                      ),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text(
                              "asd" +
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
                              "https://www.youtube.com/",
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
                        "asd",
                        style: TextStyle(fontSize: 10, color: kPrimaryColor),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "55" + " TL",
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
          }),
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
