import 'package:flutter/material.dart';
import 'package:kitap_dagi/locator.dart';
import 'package:kitap_dagi/models/book.dart';

import '../repository/repository.dart';

enum ViewState { geliyor, geldi, hata }

class MainViewModel with ChangeNotifier {
  final Repository _repository = locator<Repository>();
  ViewState _state = ViewState.geliyor;
  ViewState get state => _state;
  List<Book> asd = [];
  List<Book> sizinicin = [];
  List<Book> coksatan = [];
  List<Book> yenicikan = [];
  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  Future<List<Book>> kitaplariGetir() async {
    await Future.delayed(const Duration(milliseconds: 100));
    // try {
    asd = await _repository.kitaplariGetir();
    for (int i = 0; i < asd.length; i++) {
      i < 8
          ? sizinicin.add(asd[i])
          : i < 16
              ? coksatan.add(asd[i])
              : yenicikan.add(asd[i]);
    }
    state = ViewState.geldi;
    return asd;
    /*} catch (e) {
      state = ViewState.hata;
      return asd;
    }*/
  }
}
