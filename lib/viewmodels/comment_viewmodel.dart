import 'package:flutter/material.dart';
import 'package:kitap_dagi/locator.dart';

import '../models/comment.dart';
import '../repository/repository.dart';

enum ViewStates { geliyor, geldi, hata }

class CommentViewModel with ChangeNotifier {
  final Repository _repository = locator<Repository>();
  ViewStates _state = ViewStates.geliyor;
  ViewStates get state => _state;
  int biryildiz = 0, ikiyildiz = 0, ucyildiz = 0, dortyildiz = 0, besyildiz = 0;
  int verilenYildiz = 0;
  Comments comments = Comments(yorumSayisi: 0, yorumlar: []);
  int baslama = 0;
  set state(ViewStates value) {
    _state = value;
    notifyListeners();
  }

  Future<Comments> yorumlariGetir(String id) async {
    state = ViewStates.geliyor;
    biryildiz = ikiyildiz = ucyildiz = dortyildiz = besyildiz = 0;
    try {
      comments = await _repository.yorumlariGetir(id);
      // await _repository.yorumlariGetir(asd[0].id);
      state = ViewStates.geldi;

      for (int i = 0; i < comments.yorumlar.length; i++) {
        print("as");
        if (comments.yorumlar[i]["rank"] == "1") {
          biryildiz++;
        } else if (comments.yorumlar[i]["rank"] == "2") {
          ikiyildiz++;
        } else if (comments.yorumlar[i]["rank"] == "3") {
          ucyildiz++;
        } else if (comments.yorumlar[i]["rank"] == "4") {
          dortyildiz++;
        } else if (comments.yorumlar[i]["rank"] == "5") {
          besyildiz++;
        }
      }
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
