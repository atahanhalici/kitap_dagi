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

  yorumYap(String title, String desc, int verilenYildiz, String bookId,
      String adSoyad) async {
    await _databaseService.yorumYap(
        title, desc, verilenYildiz, bookId, adSoyad);
  }

  Future<bool> kayit(Map<String, String> bilgiler) async {
    return await _databaseService.kayit(bilgiler);
  }

  Future<Users> giris(Map<String, String> bilgiler) async {
    return await _databaseService.giris(bilgiler);
  }

  beniHatirlaKontrol() async {
    return await _databaseService.beniHatirlaKontrol();
  }

  Future<bool> cikisYap() async {
    return await _databaseService.cikisYap();
  }
 Future<Map> sifremiUnuttum(String email) async {
    return await _databaseService.sifremiUnuttum(email);
  }

  Future<String>userKontrol(Users users) async {
    return await _databaseService.userKontrol(users);
  }
  Future<Users> googleGiris() async {
    return await _databaseService.googleGiris();
  }

  twitterGiris() async{
 return await _databaseService.twitterGiris();
  }

  kategoriKitapGetir(String id) async{
     return await _databaseService.kategoriKitapGetir(id);
  }

  Future<List<Book>>favoriGetir(String id) async{
    return await _databaseService.favoriGetir(id);
  }

  favoriKaldir(String id, String bookid)async {
     return await _databaseService.favoriKaldir(id,bookid);
  }

  favoriEkle(String userId, String bookId) async{
     return await _databaseService.favoriEkle(userId,bookId);
  }

  guncelle(String text, String text2, String user) async{
     return await _databaseService.guncelle(text,text2,user);
  }

  gununKitabi() async{
return await _databaseService.gununKitabi();
  }

  sifreGuncelle(String isim, String soyisim, String user) async{
     return await _databaseService.sifreGuncelle(isim,soyisim,user);
  }

  aramaKitapGetir(String isim) async{
     return await _databaseService.aramaKitapGetir(isim);
  }
}
