import 'package:flutter/material.dart';
import 'package:kitap_dagi/locator.dart';
import 'package:kitap_dagi/repository/repository.dart';

import '../models/book.dart';

enum ViewStatees { geliyor, geldi, hata }

class CategoryViewModel with ChangeNotifier {
  final Repository _repository = locator<Repository>();
  ViewStatees _state = ViewStatees.geliyor;
  ViewStatees get state => _state;
  List<Book> kitaplar = [];
  String title = "";
  set state(ViewStatees value) {
    _state = value;
    notifyListeners();
  }

  kategoriKitapGetir(String isim) async {
    state = ViewStatees.geliyor;
    kitaplar.clear();
    try {
      var sonuc = await _repository.kategoriKitapGetir(isim);
      title = sonuc["title"];
      kitaplar = sonuc["book"];

      state = ViewStatees.geldi;
    } catch (e) {
      state = ViewStatees.hata;
    }
  }
}
