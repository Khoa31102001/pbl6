import 'package:intl/intl.dart';

extension IntegerExtension on int{
  String get formatMoney {
    return '${NumberFormat("#,###", "en_US").format(this).replaceAll(",", ".")} đ';
  }
}