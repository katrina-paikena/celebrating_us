import 'storage/storage_service.dart';
import 'storage/sqlite_storage_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

setupServiceLocator() {
  getIt.registerLazySingleton<StorageService>(() => SqliteStorageService());
}