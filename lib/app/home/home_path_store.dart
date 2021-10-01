import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fpdart/fpdart.dart';

class HomePathStore extends NotifierStore<Exception, String> {
  HomePathStore() : super('');

  Future<Either<File, String>> filePlicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowedExtensions: ['gzip']);

    if (result != null) {
      String? path = result.files.single.path;
      File file = File(path!);
      update(path);
      return Left(file);
    } else {
      update('');
      return right('Error file not found!');
    }
  }

  void validatePath(String displayValue) {
    update(displayValue);
  }
}
