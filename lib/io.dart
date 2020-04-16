import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

Future<File> _getFile() async {
  final directory = await getApplicationDocumentsDirectory();
  return File("${directory.path}/data.json");
}

Future<File> saveData(List data) async {
  String temp = json.encode(data);
  final file = await _getFile();
  return file.writeAsString(temp);
}

Future<String> getData() async {
  try {
    final file = await _getFile();
    return file.readAsString();
  } catch (e) {
    return null;
  }
}