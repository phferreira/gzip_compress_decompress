import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gzip_compress_decompress/app/home/home_file_store.dart';
import 'package:gzip_compress_decompress/app/home/home_path_store.dart';
import 'package:gzip_compress_decompress/app/home/widgets/custom_table_widget.dart';
import 'package:gzip_compress_decompress/app/home/widgets/select_folder_widget.dart';
import 'package:gzip_compress_decompress/app/home/widgets/update_widget.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, this.title = 'HomePage'}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomePathStore pathStore = Modular.get();
  final HomeFileStore fileStore = Modular.get();

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
            SelectFolderWidget(),
            const CustomTableWidget(),
            const UpdateWidget(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    fileStore.setLoading(true);

    pathStore.observer(
      onState: (state) => debugPrint('PathStateChange: $state'),
    );
    fileStore.observer(
      onState: (state) => debugPrint('FileStateChange: $state'),
      onLoading: (loading) => debugPrint('FileLoadingChange: $loading'),
    );

    super.initState();
  }
}
