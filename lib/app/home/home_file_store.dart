import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_triple/flutter_triple.dart';

class HomeFileStore extends NotifierStore<Exception, List<Map<String, dynamic>>> {
  HomeFileStore() : super([]);

  final labelsKeys = [];
  final List labelsValues = [];
  final messagesKeys = [];
  final List messagesValues = [];

  Map<String, dynamic> fileConvert(String locale) {
    String decoded = '';
    File file = File(locale);
    Uint8List data = file.readAsBytesSync();

    List<int> decompress = gzip.decode(data);

    decoded = utf8.decode(decompress);
    return jsonDecode(decoded);
  }

  Future<void> filesConvert(List<FileSystemEntity> files) async {
    List<Map<String, dynamic>> result = [];
    for (var element in files) {
      Map<String, dynamic> fileConverted = fileConvert(element.path);
      result.add(fileConverted);
    }
    update(result);
    setLoading(false);

    labelsKeys.clear();
    labelsValues.clear();
    messagesKeys.clear();
    messagesValues.clear();

    for (var element in result) {
      labelsKeys.add(element['labels'].keys.toList());
      labelsValues.add(element['labels'].values.toList());
      messagesKeys.add(element['messages'].keys.toList());
      messagesValues.add(element['messages'].values.toList());
    }
    return;
  }

  void updateFile(String locale, String stringFile) {
    File(locale).writeAsBytesSync(gzip.encode(utf8.encode(stringFile)));
  }
}
