import 'package:flutter/material.dart';

import '../locator.dart';
import '../repository/repository.dart';

enum ViewStatee { geliyor, geldi, hata }

class UserViewModel with ChangeNotifier {
  final Repository _repository = locator<Repository>();
  ViewStatee _statee = ViewStatee.geliyor;
  ViewStatee get statee => _statee;
  bool deger = false;
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
}
