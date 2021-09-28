import 'package:flutter_modular/flutter_modular.dart';
import 'package:gzip_compress_decompress/app/home/home_path_store.dart';
import 'home_page.dart';
import 'home_file_store.dart';

class HomeModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => HomeFileStore()),
    Bind.lazySingleton((i) => HomePathStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const HomePage()),
  ];
}
