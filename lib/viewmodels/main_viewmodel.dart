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
  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  Future<List<Book>> kitaplariGetir() async {
    await Future.delayed(const Duration(milliseconds: 100));
    // try {
    asd = await _repository.kitaplariGetir();
    state = ViewState.geldi;
    return asd;
    /*} catch (e) {
      state = ViewState.hata;
      return asd;
    }*/
  }
}
