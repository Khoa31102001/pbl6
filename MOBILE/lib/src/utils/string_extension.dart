
extension StringExtension on String{

  String get stringSplitZero{
    final strSplit = split(".");
    return strSplit.first;
  }
}