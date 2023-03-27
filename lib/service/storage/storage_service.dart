import 'package:celebrating_us/model/celebration.dart';

abstract class StorageService {
  Future<void> open();
  Future<List<Celebration>> getCelebrationsDate(DateTime dateTime);
  Stream<List<Celebration>> getAllCelebrations();
  Future<void> saveCelebration(Celebration celebration);
  void clearAllCelebrations();
}