// /home/paulo/projetos/flutter/market_manager/assets/lang/en_US.gzip

import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:gzip_compress_decompress/app/home/home_file_store.dart';
import 'package:flutter/material.dart';
import 'package:gzip_compress_decompress/app/home/home_path_store.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, this.title = 'HomePage'}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomePathStore pathStore = Modular.get();
  final HomeFileStore fileStore = Modular.get();
  final pathController = TextEditingController();
  final fileController = TextEditingController();

  @override
  void initState() {
    pathController.addListener(_pathListener);
    fileController.addListener(_fileListener);
    pathStore.observer(
      onState: (state) => debugPrint('PathStateChange: $state'),
    );
    fileStore.observer(
      onState: (state) => debugPrint('FileStateChange: $state'),
    );
    super.initState();
  }

  void _pathListener() {
    pathStore.validatePath(pathController.text);
  }

  void _fileListener() {
    fileStore.validateFile(fileController.text);
  }

  void _findFile() async {
    pathController.text = (await pathStore.filePlicker()).fold((l) => l.path, (r) => r);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: pathController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Select a file ... ',
                suffixIcon: IconButton(
                  onPressed: _findFile,
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
            ScopedBuilder<HomePathStore, Exception, String>(
              onState: (_, value) {
                return ElevatedButton(
                  onPressed: pathController.text == ''
                      ? null
                      : () async {
                          fileController.text = (await fileStore.fileConvert(pathController.text)).fold((l) => l, (r) => r);
                        },
                  child: const Text('Gzip to String'),
                );
              },
            ),
            TextField(
              controller: fileController,
              minLines: 10,
              maxLines: 100,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'File',
              ),
            ),
            ScopedBuilder<HomeFileStore, Exception, String>(
              onState: (_, value) {
                return ElevatedButton(
                  onPressed: fileController.text == ''
                      ? null
                      : () {
                          try {
                            fileStore.updateFile(pathController.text, fileController.text);
                            pathController.text = '';
                            fileController.text = '';
                          } on Exception catch (e) {
                            fileController.text = e.toString();
                          }
                        },
                  child: const Text('Update'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
