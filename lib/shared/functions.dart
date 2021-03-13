String validateMobile(String value) {
  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return 'Enter a phone number';
  } else if (!regExp.hasMatch(value)) {
    return 'Enter a valid phone number without dashes';
  }
  return null;
}
