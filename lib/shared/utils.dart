String numberValidator(String value) {
  if (value == null) {
    return null;
  }
  final n = num.tryParse(value);
  if (n == null) {
    return "Please enter a valid number";
    // return '"$value" is not a valid number';
  }
  return null;
}
