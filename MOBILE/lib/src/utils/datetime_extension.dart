
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime{

  String get dateTimeToDDMMYYYY {
    var formatter = DateFormat("dd/MM/yyyy");
    return formatter.format(this);
  }
}