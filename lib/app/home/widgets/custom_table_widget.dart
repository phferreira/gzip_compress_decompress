import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:gzip_compress_decompress/app/home/home_file_store.dart';
import 'package:gzip_compress_decompress/app/home/home_path_store.dart';
import 'package:gzip_compress_decompress/app/home/widgets/scrollable_widget.dart';

class CustomTableWidget extends StatefulWidget {
  const CustomTableWidget({Key? key}) : super(key: key);

  @override
  _CustomTableWidgetState createState() => _CustomTableWidgetState();
}

class _CustomTableWidgetState extends ModularState<CustomTableWidget, HomeFileStore> {
  @override
  Widget build(BuildContext context) {
    var labelsKeys = [];
    List labelsValues = [];
    var messagesKeys = [];
    List messagesValues = [];
    final HomePathStore pathStore = Modular.get();

    return ScopedBuilder<HomeFileStore, Exception, List<Map<String, dynamic>>>(
      onLoading: (_) {
        return const Center(child: Text('Choice a directory.'));
      },
      onState: (_, value) {
        // if (value.isNotEmpty) {
        for (var element in store.state) {
          labelsKeys.add(element['labels'].keys.toList());
          labelsValues.add(element['labels'].values.toList());
          messagesKeys.add(element['messages'].keys.toList());
          messagesValues.add(element['messages'].values.toList());
        }

        return Expanded(
          child: Center(
            child: ScrollableWidget(
              child: Column(
                children: [
                  DataTable(
                    columns: List<DataColumn>.generate(
                      pathStore.state.length + 2,
                      (index) {
                        return DataColumn(
                          label: (index == 0)
                              ? const Text('Key')
                              : (index == pathStore.state.length + 1)
                                  ? IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.add),
                                    )
                                  : Text(
                                      pathStore.state[index - 1].path.replaceFirst(pathStore.state[index - 1].parent.path, ''),
                                    ),
                        );
                      },
                    ),
                    rows: List<DataRow>.generate(
                      labelsKeys[0].length,
                      (record) {
                        return DataRow(
                          color: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return Theme.of(context).colorScheme.primary.withOpacity(0.08);
                            }
                            if (record.isEven) {
                              return Colors.grey.withOpacity(0.3);
                            }
                            return null;
                          }),
                          cells: List<DataCell>.generate(
                            pathStore.state.length + 2,
                            (column) {
                              return DataCell(
                                (column == 0)
                                    ? TextFormField(
                                        initialValue: labelsKeys[column][record],
                                        onChanged: (value) => labelsKeys[column][record] = value,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                      )
                                    : (column == pathStore.state.length + 1)
                                        ? TextFormField()
                                        : TextFormField(
                                            initialValue: labelsValues[column - 1][record],
                                            onChanged: (value) => labelsValues[column - 1][record] = value,
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                          ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
          ),
        );
        // }
      },
    );
  }
}
