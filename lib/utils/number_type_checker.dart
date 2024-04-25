bool isNumeric(String value) {
  try {
    int age = int.parse(value);
    if (age > 0) {
      return true; // Age is a positive integer
    }
  } catch (e) {
    return false;
  }
  return false;
}
