import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fpdart/fpdart.dart';

class HomeFileStore extends NotifierStore<Exception, String> {
  HomeFileStore() : super('');

  Future<Either<String, String>> fileConvert(String locale) async {
    String decoded = '';
    try {
      File file = File(locale);
      Uint8List data = file.readAsBytesSync();

      List<int> decompress = gzip.decode(data);

      decoded = utf8.decode(decompress);
      update(decoded);
    } catch (e) {
      update('');
    }
    return left(decoded);
  }

  void updateFile(String locale, String stringFile) {
    File(locale).writeAsBytesSync(gzip.encode(utf8.encode(stringFile)));
  }

  void validateFile(String file) {
    update(file);
  }
}
