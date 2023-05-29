import 'package:flutter/material.dart';
import 'package:kitap_dagi/locator.dart';

import '../models/comment.dart';
import '../repository/repository.dart';

enum ViewStates { geliyor, geldi, hata }

class CommentViewModel with ChangeNotifier {
  final Repository _repository = locator<Repository>();
  ViewStates _state = ViewStates.geliyor;
  ViewStates get state => _state;
  int a = 0;
  int verilenYildiz = 0;
  Comments comments = Comments(yorumSayisi: 0, yorumlar: []);
  set state(ViewStates value) {
    _state = value;
    notifyListeners();
  }

  Future<Comments> yorumlariGetir(String id) async {
    state = ViewStates.geliyor;
    try {
      comments = await _repository.yorumlariGetir(id);

      // await _repository.yorumlariGetir(asd[0].id);
      state = ViewStates.geldi;

      return comments;
    } catch (e) {
      state = ViewStates.hata;
      return comments;
    }
  }

  yildizPuanla(int sayi) {
    verilenYildiz = sayi;
  }

  yorumYap(String title, String desc, String bookId) async {
    state = ViewStates.geliyor;
    try {
      _repository.yorumYap(title, desc, verilenYildiz, bookId);
      yorumlariGetir(bookId);
    } catch (e) {}
  }
}
