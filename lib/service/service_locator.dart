import 'csv/csv_service.dart';
import 'csv/csv_service_impl.dart';
import 'storage/storage_service.dart';
import 'storage/sqlite_storage_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

setupServiceLocator() {
  getIt.registerLazySingleton<StorageService>(() => SqliteStorageService());
  getIt.registerLazySingleton<CsvService>(() => CsvServiceImpl());
}