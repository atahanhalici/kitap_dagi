import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kitap_dagi/pages/home_page.dart';
import 'package:kitap_dagi/viewmodels/main_viewmodel.dart';
import 'package:provider/provider.dart';

import '../viewmodels/user_viewmodel.dart';

class NoConnectionPage extends StatefulWidget {
  const NoConnectionPage({Key? key}) : super(key: key);

  @override
  State<NoConnectionPage> createState() => _NoConnectionPageState();
}

class _NoConnectionPageState extends State<NoConnectionPage> {
  late StreamSubscription<InternetConnectionStatus> listener;
  @override
  void initState() {
    execute();
    super.initState();
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }

  Future<void> execute() async {
    listener = InternetConnectionChecker().onStatusChange.listen(
      (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            // ignore: no_leading_underscores_for_local_identifiers
            MainViewModel _mainModel =
                Provider.of<MainViewModel>(context, listen: true);
            // ignore: no_leading_underscores_for_local_identifiers
            UserViewModel _userModel =
                Provider.of<UserViewModel>(context, listen: true);
            _mainModel.kitaplariGetir();
            _userModel.beniHatirlaKontrol();
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
            break;
          case InternetConnectionStatus.disconnected:
            break;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(child: SizedBox()),
          Container(
            alignment: Alignment.center,
            width: 150,
            height: 150,
            child: Image.asset(
              "assets/nowifi.png",
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Bağlantınızda Problem Var Gibi Duruyor",
            style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Color.fromARGB(255, 0, 0, 0)),
          ),
          const Expanded(child: SizedBox()),
          Container(
            margin: const EdgeInsets.only(bottom: 25),
            alignment: Alignment.bottomCenter,
            child: const Text(
              "kitapdagi.com.tr",
              style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color.fromARGB(140, 0, 0, 0)),
            ),
          ),
        ],
      )),
    );
  }
}
