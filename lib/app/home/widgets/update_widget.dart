import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:gzip_compress_decompress/app/home/home_file_store.dart';
import 'package:gzip_compress_decompress/app/home/home_path_store.dart';

class UpdateWidget extends StatefulWidget {
  const UpdateWidget({Key? key}) : super(key: key);

  @override
  _UpdateWidgetState createState() => _UpdateWidgetState();
}

class _UpdateWidgetState extends ModularState<UpdateWidget, HomeFileStore> {
  @override
  Widget build(BuildContext context) {
    final HomePathStore pathStore = Modular.get();

    return ScopedBuilder<HomeFileStore, Exception, List<Map<String, dynamic>>>(
      onState: (_, value) {
        return ElevatedButton(
          onPressed: () {
            try {
              for (int file = 0; file < pathStore.state.length; file++) {
                Map<String, dynamic> fileString = {'labels': {}, 'messages': {}};

                for (int indexKey = 0; indexKey < store.labelsKeys[file].length; indexKey++) {
                  fileString['labels'].addAll({
                    store.labelsKeys[file][indexKey]: store.labelsValues[file][indexKey],
                  });
                }
                for (int indexKey = 0; indexKey < store.messagesKeys[file].length; indexKey++) {
                  fileString['messages'].addAll({
                    store.messagesKeys[file][indexKey]: store.messagesValues[file][indexKey],
                  });
                }

                store.updateFile(
                  pathStore.state[file].path,
                  jsonEncode(fileString),
                );
                // pathController.text = '';
                store.setLoading(true);
              }
            } on Exception catch (e) {
              store.setError(e);
            }
          },
          child: const Text('Update'),
        );
      },
    );
  }
}
