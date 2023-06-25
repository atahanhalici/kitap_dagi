import 'package:flutter/material.dart';
import 'package:kitap_dagi/locator.dart';
import 'package:kitap_dagi/models/book.dart';
import 'package:kitap_dagi/repository/repository.dart';

enum ViewStatex { geliyor, geldi, hata }

class FavoritesViewModel with ChangeNotifier {
  final Repository _repository = locator<Repository>();
  ViewStatex _state = ViewStatex.geliyor;
  ViewStatex get state => _state;
  List<Book> kitaplar = [];
  set state(ViewStatex value) {
    _state = value;
    notifyListeners();
  }

  favoriGetir(String id) async {
    state = ViewStatex.geliyor;
    kitaplar.clear();
    try {
      kitaplar = await _repository.favoriGetir(id);

      state = ViewStatex.geldi;
    } catch (e) {
      state = ViewStatex.hata;
    }
  }

  favoriKaldir(String id, String bookid) async {
    try {
      var sonuc = await _repository.favoriKaldir(id, bookid);

      return sonuc;
    } catch (e) {
      return false;
    }
  }

  favoriEkle(String userId, String bookId) async {
    try {
      var sonuc = await _repository.favoriEkle(userId, bookId);
      return sonuc;
    } catch (e) {
      return {"durum": false, "mesaj": "HATA"};
    }
  }
}
