import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_triple/flutter_triple.dart';

class HomePathStore extends NotifierStore<Exception, List<FileSystemEntity>> {
  HomePathStore() : super([]);

  Future<String> filePicker() async {
    String? result = await FilePicker.platform.getDirectoryPath();

    if (result != null) {
      List<FileSystemEntity> listFiles = Directory(result).listSync(recursive: true);

      // String? path = result.files.single.path;
      // File file = File(path!);
      // update(path);
      // return Left(file);

      update(listFiles);
      return result;
    } else {
      update([]);
      return 'Error file not found!';
    }
  }
}
