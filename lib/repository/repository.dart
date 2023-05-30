import 'package:kitap_dagi/locator.dart';
import 'package:kitap_dagi/models/comment.dart';
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

  yorumYap(String title, String desc, int verilenYildiz, String bookId) async {
    await _databaseService.yorumYap(title, desc, verilenYildiz, bookId);
  }

  Future<bool> kayit(Map<String, String> bilgiler) async {
    return await _databaseService.kayit(bilgiler);
  }
}
