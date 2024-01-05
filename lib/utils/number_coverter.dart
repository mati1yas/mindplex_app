import 'package:intl/intl.dart';

/// Formats an integer into a compact string representation.
/// 
/// Uses the `NumberFormat.compact()` method from the `intl` package to format the number.
/// For example, 1000 will be formatted as '1K', 1000000 as '1M', etc.
/// 
/// Parameters:
/// - `number`: The integer to be formatted.
/// 
/// Returns:
/// - A string representing the compact form of the input number.
String formatNumber(int number) {
  return NumberFormat.compact().format(number);
}

