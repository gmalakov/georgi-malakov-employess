import 'dart:io';

import '../lib/src/read_file.dart';

Future<void> main(List<String> argc) async {
  if (argc.length == 0) {
    print('No file specified!');
    return;
  }

  final str = argc[0];
  final f = File(str);
  if (f.existsSync()) {
    final contents = await f.readAsString();
    EmployeesDeal().showResults(contents);
  } else print('File doesn\'t exist!');
}

