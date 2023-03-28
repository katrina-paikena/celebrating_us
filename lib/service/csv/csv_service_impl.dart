import 'csv_service.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

class CsvServiceImpl extends CsvService {
  List<List<dynamic>> rowsAsListOfValues = [];

  @override
  void init() async {
    String csvString = await loadAsset();
    rowsAsListOfValues = const CsvToListConverter().convert(csvString);
  }

  @override
  List<List<dynamic>> getData() {
    return rowsAsListOfValues;
  }

  Future<String> loadAsset() async {
    final assetString = await rootBundle.loadString('assets/varda_dienas.csv');
    print(assetString);
    return assetString;
  }
}