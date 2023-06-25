import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kitap_dagi/locator.dart';
import 'package:kitap_dagi/pages/home_page.dart';
import 'package:kitap_dagi/viewmodels/category_viewmodel.dart';
import 'package:kitap_dagi/viewmodels/comment_viewmodel.dart';
import 'package:kitap_dagi/viewmodels/favorites_viewmodel.dart';
import 'package:kitap_dagi/viewmodels/main_viewmodel.dart';
import 'package:kitap_dagi/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';

import 'constants.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox("informations");
  initializeDateFormatting();
  setupLocator();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => MainViewModel()),
    ChangeNotifierProvider(create: (_) => CommentViewModel()),
    ChangeNotifierProvider(create: (_) => UserViewModel()),
    ChangeNotifierProvider(create: (_) => CategoryViewModel()),
    ChangeNotifierProvider(create: (_) => FavoritesViewModel()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    MainViewModel _mainModel =
        Provider.of<MainViewModel>(context, listen: true);
    UserViewModel _userModel =
        Provider.of<UserViewModel>(context, listen: true);
    _mainModel.kitaplariGetir();
    _userModel.beniHatirlaKontrol();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Kitap Dağı',
        theme: ThemeData(
          scaffoldBackgroundColor: kBackgroundColor,
          primaryColor: kPrimaryColor,
          colorScheme:
              ColorScheme.fromSwatch().copyWith(primary: kPrimaryColor),
          textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage());
  }
}
