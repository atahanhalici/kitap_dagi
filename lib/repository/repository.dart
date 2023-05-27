import 'package:kitap_dagi/locator.dart';
import 'package:kitap_dagi/services/db_services.dart';

import '../models/book.dart';

class Repository {
  final DbServices _databaseService = locator<DbServices>();
 Future<List<Book>> kitaplariGetir() async{
 return await _databaseService.kitaplariGetir();
  }
}
