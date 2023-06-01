import 'package:flutter/material.dart';
import 'package:kitap_dagi/constants.dart';
import 'package:kitap_dagi/widgets/drawer.dart';

class ForgotMyPassword extends StatefulWidget {
  const ForgotMyPassword({Key? key}) : super(key: key);

  @override
  State<ForgotMyPassword> createState() => _ForgotMyPasswordState();
}

class _ForgotMyPasswordState extends State<ForgotMyPassword> {
  bool uyari = false;
  @override
  Widget build(BuildContext context) {
    final _emailController = TextEditingController();
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: const Text("Kitap Dağı"),
          centerTitle: true,
          elevation: 0,
        ),
        drawerEnableOpenDragGesture: true,
        drawer: const MyDrawer(),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
              Container(
                padding: EdgeInsets.only(
                  left: kDefaultPadding,
                  right: kDefaultPadding,
                  bottom: 36 + kDefaultPadding,
                ),
                height: size.height > size.width
                    ? size.height * 0.1 - 27
                    : size.width * 0.1 - 27,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(36),
                    bottomRight: Radius.circular(36),
                  ),
                ),
              ),
              SizedBox(
                height: size.height > size.width
                    ? (size.height - (size.height * 0.1 - 27 + 80 + 225)) / 2
                    : (size.height - (size.width * 0.1 - 27 + 80 + 225)) / 2,
              ),
              Container(
                //height: 225,
                //width: 100,
                margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                padding: EdgeInsets.all(kDefaultPadding),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 236, 236, 236),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      ), //BoxShadow
                    ],
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Şifremi Unuttum",
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: kDefaultPadding,
                      ),
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          //  controller: _titleController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          cursorColor: Colors.black,
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: "E-Mail",
                            labelStyle: const TextStyle(color: Colors.black),
                            focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: kPrimaryColor)),
                            border: const UnderlineInputBorder(),
                            suffixIcon: Icon(Icons.person),
                          ),
                          validator: (deger) {
                            if (deger!.isEmpty) {
                              return "E-Mail Kısmı Boş Bırakılamaz!";
                            } else if (!deger.contains("@") ||
                                !deger.contains(".")) {
                              return "Geçersiz Mail Formatı. Lütfen Kontrol Ediniz";
                            } else {
                              _emailController.text = deger;
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextButton(
                          onPressed: () async {
                            if (_emailController.text.isNotEmpty) {
                              print("sa");
                            } else {
                              setState(() {
                                uyari = true;
                              });
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
                              "Şifremi Unuttum",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )),
                          )),
                      Visibility(
                        visible: uyari,
                        child: Text(
                          "Lütfen Hiçbir Alanı Boş Geçmeyiniz!",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: size.height > size.width
                    ? (size.height - (size.height * 0.1 - 27 + 80 + 225)) / 2
                    : (size.height - (size.width * 0.1 - 27 + 80 + 225)) / 2,
              ),
            ]))));
  }
}
