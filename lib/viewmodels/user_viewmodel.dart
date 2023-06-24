import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kitap_dagi/models/user.dart';

import '../locator.dart';
import '../repository/repository.dart';

enum ViewStatee { geliyor, geldi, hata }

class UserViewModel with ChangeNotifier {
  final Repository _repository = locator<Repository>();
  ViewStatee _statee = ViewStatee.geliyor;
  ViewStatee get statee => _statee;
  bool deger = false;
  bool girisState = false;
  bool sifreKontrol = false;
  int a = 0;
  Users users = Users(mesaj: "", user: {}, durum: false);
  set statee(ViewStatee value) {
    _statee = value;
    notifyListeners();
  }

  Future<bool> kayit(Map<String, String> bilgiler) async {
    await Future.delayed(const Duration(milliseconds: 100));
    statee = ViewStatee.geliyor;
    try {
      deger = await _repository.kayit(bilgiler);
      statee = ViewStatee.geldi;
      return deger;
    } catch (e) {
      statee = ViewStatee.hata;
      return deger;
    }
  }

  Future<Users> giris(Map<String, String> bilgiler) async {
    await Future.delayed(const Duration(milliseconds: 100));
    statee = ViewStatee.geliyor;
    try {
      users = await _repository.giris(bilgiler);
      statee = ViewStatee.geldi;
      return users;
    } catch (e) {
      statee = ViewStatee.hata;
      return users;
    }
  }

  beniHatirlaKontrol() async {
    if (a == 0) {
      a++;
      try {
        users = await _repository.beniHatirlaKontrol();
        String sifre = await _repository.userKontrol(users);
        if (sifre == users.user["password"]) {
        } else {
          users = Users(mesaj: "", user: {}, durum: false);
          var box = await Hive.openBox("informations");
          box.clear();
          sifreKontrol = true;
          await Future.delayed(const Duration(seconds: 5));
          sifreKontrol = false;
        }
      } catch (e) {
        return users;
      }
    }
  }

  Future<Map> sifremiUnuttum(String email) async {
    Map sonuc = await _repository.sifremiUnuttum(email);
    return sonuc;
  }

  Future<bool> cikisYap() async {
    bool sonuc = await _repository.cikisYap();
    if (sonuc == true) {
      users = Users(mesaj: "", user: {}, durum: false);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> googleGiris() async {
    var sonuc = await _repository.googleGiris();
    if (sonuc.durum) {
      users = sonuc;
    }
    return sonuc.durum;
  }

  twitterGiris() async {
    var sonuc = await _repository.twitterGiris();
    if (sonuc.durum) {
      users = sonuc;
    }
    return sonuc.durum;
  }
}
