import 'package:intl/intl.dart';

class Employee {
  static DateTime parseDate(String date) {
    var dtp = date == 'NULL' ? DateTime.now() : DateTime.tryParse(date);
    dtp ??= DateFormat('dd.MM.YYYY').parse(date);
    dtp ??= DateFormat("EEE, dd MMM yyyy hh:mm a zzz").parse(date);
    //.... can add other syntaxes too
    return dtp;
  }

  static const String $EmpId = 'EmpId';
  static const String $ProjectId = 'ProjectId';
  static const String $DateFrom = 'DateFrom';
  static const String $DateTo = 'DateTo';

  static const List<String> Identifiers = [
    $EmpId,
    $ProjectId,
    $DateFrom,
    $DateTo
  ];

  int EmpId;
  int ProjectId;
  DateTime DateFrom;
  DateTime DateTo;

  Employee();

  factory Employee.fromMap(Map m) => Employee()
    ..EmpId = int.tryParse(m[$EmpId])
    ..ProjectId = int.tryParse(m[$ProjectId])
    ..DateFrom = parseDate(m[$DateFrom])
    ..DateTo = parseDate(m[$DateTo]);

  Map<String, dynamic> toMap() => {
    $EmpId: EmpId,
    $ProjectId: ProjectId,
    $DateFrom: DateFrom,
    $DateTo: DateTo
  };

  String toString() => '$runtimeType / ${toMap()}';
}

class EmployeeResults {
  Employee emp1, emp2;
  int days;
  int ProjectId;
  DateTime dfrom, dto;
}

class EmployeesDeal {
  List<Employee> _readFile(String contents) {
    final l = contents.replaceAll('\r\n', '\n').trim().split('\n');

    final List<Employee> empl = [];
    for (final line in l) {
      final lsplit = line.trim().split(',');
      if (lsplit.length >= 4) {
        final Map m = {};
        for (int i = 0; i < Employee.Identifiers.length; i++)
          m[Employee.Identifiers[i]] = lsplit[i].trim().toUpperCase();
        empl.add(Employee.fromMap(m));
      }
    }
    return empl;
  }

  EmployeeResults workEmployees(String contents) {
    ///Read file
    final employeeList = _readFile(contents);

    ///Split but project
    final Map<int, List<Employee>> projectMap = {};
    for (final emp in employeeList) {
      projectMap[emp.ProjectId] ??= [];
      projectMap[emp.ProjectId].add(emp);
    }

    ///Init values
    int lastKey = -1;
    Duration lastDiff = Duration(milliseconds: -1);
    int lastI, lastJ;
    DateTime dfrom, dto;

    for (final k in projectMap.keys) {
      ///Sort by date arrived
      projectMap[k].sort((a, b) => a.DateFrom.compareTo(b.DateFrom));
      // print(projectMap[k]);
      for (int i = 0; i < projectMap[k].length; i++) {
        final dt = projectMap[k][i].DateTo;
        for (int j = i + 1; j < projectMap[k].length; j++) {
          if (dt.isAfter(projectMap[k][j].DateFrom)) {
            final dif = dt.difference(projectMap[k][j].DateFrom);
            if (dif > lastDiff) {
              dfrom = projectMap[k][j].DateFrom;
              dto = dt;
              lastKey = k;
              lastDiff = dif;
              lastI = i;
              lastJ = j;
            }
          }
        }
      }
    }

    if (lastI == null || lastJ == null) return null;
    final emp1 = projectMap[lastKey][lastI];
    final emp2 = projectMap[lastKey][lastJ];
    final days = lastDiff.inDays;

    return EmployeeResults()
        ..emp1 = emp1
        ..emp2 = emp2
        ..days = days
        ..ProjectId = lastKey
        ..dfrom = dfrom
        ..dto = dto;
  }

  void showResults(String contents) {
    final res = workEmployees(contents);
    if (res == null) {
      print('Not found!');
      return;
    }

      print('Longest project shared by two workers: ${res.ProjectId}');
      print('TimeSpan: ${res.days} days ${res.dfrom} - ${res.dto}');
      print('Worker1: ${res.emp1.EmpId}, '
          'Worker2: ${res.emp2.EmpId}');

  }
}
