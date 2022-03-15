import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gzip_compress_decompress/app/home/home_file_store.dart';
import 'package:gzip_compress_decompress/app/home/home_path_store.dart';

class SelectFolderWidget extends StatelessWidget {
  final pathController = TextEditingController();
  final HomePathStore pathStore = Modular.get();
  final HomeFileStore fileStore = Modular.get();

  SelectFolderWidget({Key? key}) : super(key: key);

  void _findFile() async {
    pathController.text = await pathStore.filePicker();
    fileStore.filesConvert(pathStore.state);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: pathController,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: 'Select a folder ... ',
        suffixIcon: IconButton(
          onPressed: pathController.text.isNotEmpty ? null : _findFile,
          icon: const Icon(Icons.search),
        ),
        suffix: IconButton(
          onPressed: pathController.text.isEmpty
              ? null
              : () {
                  pathController.text = '';
                },
          icon: const Icon(Icons.undo),
        ),
      ),
    );
  }
}
