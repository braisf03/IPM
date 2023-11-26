import 'dart:io';

import 'package:path_provider/path_provider.dart';


class ModeloFichero{

  final String _fileName = "Favoritos.txt";
  final String _defaultFrom = "EUR";
  final String _defaultTo = "USD";

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$_fileName');
  }

  Future<File> addCurrencyToFile(String contenido) async {


    final file = await _localFile;

    if (!await file.exists()) {
      // Realiza la modificación en el archivo
      await file.create();
    }
    if(await file.readAsString() == ""){
      return file.writeAsString(contenido);
    }
    else {
      return file.writeAsString('\n$contenido', mode: FileMode.append);
    }
  }

  Future<File> removeCurrencyFromFile(String contenido) async {

    File file = await _localFile;

    if (await file.exists()) {
      // Lee el contenido actual del archivo
      List<String> content = await file.readAsLines();
      file = await file.writeAsString("");
      for(String line in content){
        if (line != contenido){
          file = await addCurrencyToFile(line);
        }
      }
      return file;

    } else {
      return await file.create();
    }
  }

  Future<File> resetFile() async{
    File file = await _localFile;

    if (await file.exists()) {
      file = await file.writeAsString("");
    }
    else{
      file = await file.create();
    }
    return file;
  }

  Future<List<String>> getAllFromFile() async {
    File file = await _localFile;

    if (!await file.exists()) {
      file = await file.create();
    }

    List<String> content = await file.readAsLines();
    if (content.isEmpty){
      await addCurrencyToFile(_defaultFrom);
      file = await addCurrencyToFile(_defaultTo);
      print(file.readAsLines());
      return[_defaultFrom, _defaultTo];
    }
    else {
      print(content);
      return content;
    }
  }

}
