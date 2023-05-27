import 'package:flutter/material.dart';
import 'package:kitap_dagi/locator.dart';
import 'package:kitap_dagi/pages/home_page.dart';
import 'package:kitap_dagi/viewmodels/main_viewmodel.dart';
import 'package:provider/provider.dart';

import 'constants.dart';

void main() {
  setupLocator();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => MainViewModel()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    MainViewModel _mainModel =
        Provider.of<MainViewModel>(context, listen: true);
    _mainModel.kitaplariGetir();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Kitap Dağı',
        theme: ThemeData(
          scaffoldBackgroundColor: kBackgroundColor,
          primaryColor: kPrimaryColor,
          textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage());
  }
}
