String numberToString(
    {required double numberValue, required int decimalPlace}) {
  String stringValue = numberValue.toStringAsFixed(decimalPlace + 1);
  return stringValue.substring(0, stringValue.length - 1);
}
