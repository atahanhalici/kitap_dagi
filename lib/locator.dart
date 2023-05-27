import 'package:get_it/get_it.dart';
import 'package:kitap_dagi/repository/repository.dart';
import 'package:kitap_dagi/services/db_services.dart';

final locator = GetIt.instance;
void setupLocator() {
  locator.registerLazySingleton(() => Repository());
  locator.registerLazySingleton(() => DbServices());
}
