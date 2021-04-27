import 'dart:html';

import 'package:worker_stage/src/read_file.dart';

Future<void> main() async {
  final but = document.querySelector('#button');
  but.onClick.listen((ev) {
    final fil = document.querySelector('#workers') as FileUploadInputElement;
    final fr = FileReader();

    fr.onLoadEnd.listen((ev) {
      final workers = EmployeesDeal().workEmployees(fr.result);
      if (workers != null)
      document
        ..querySelector('#project_id_cell')
            .setInnerHtml(workers.ProjectId.toString())
        ..querySelector('#days_cell').setInnerHtml(workers.days.toString())
        ..querySelector('#dfrom_cell').setInnerHtml(workers.dfrom.toString())
        ..querySelector('#dto_cell').setInnerHtml(workers.dto.toString())
        ..querySelector('#emp1_cell').setInnerHtml(workers.emp1.EmpId.toString())
        ..querySelector('#emp2_cell')
            .setInnerHtml(workers.emp2.EmpId.toString());
       else window.alert('No worker overlap!');
    });

    fr.readAsText(fil.files.first);
  });
}
