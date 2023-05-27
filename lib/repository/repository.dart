import 'package:kitap_dagi/locator.dart';
import 'package:kitap_dagi/services/db_services.dart';

class Repository {
  final DbServices _databaseService = locator<DbServices>();
  kitaplariGetir() async{
 return await _databaseService.kitaplariGetir();
  }
}
