import 'package:kitap_dagi/locator.dart';
import 'package:kitap_dagi/models/comment.dart';
import 'package:kitap_dagi/models/user.dart';
import 'package:kitap_dagi/services/db_services.dart';

import '../models/book.dart';

class Repository {
  final DbServices _databaseService = locator<DbServices>();
  Future<List<Book>> kitaplariGetir() async {
    var books = await _databaseService.kitaplariGetir();

    return books;
  }

  Future<Comments> yorumlariGetir(String id) async {
    return await _databaseService.yorumlariGetir(id);
  }

  yorumYap(String title, String desc, int verilenYildiz, String bookId,String adSoyad) async {
    await _databaseService.yorumYap(title, desc, verilenYildiz, bookId,adSoyad);
  }

  Future<bool> kayit(Map<String, String> bilgiler) async {
    return await _databaseService.kayit(bilgiler);
  }

 Future<Users> giris(Map<String, String> bilgiler) async{
  return await _databaseService.giris(bilgiler);
  }

  beniHatirlaKontrol() async{
     return await _databaseService.beniHatirlaKontrol();
  }

 Future<bool> cikisYap() async{
    return await _databaseService.cikisYap();
  }
}
