import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String quantityValidator(String value) {
  String pattern = r'(^[1-9][0-9]*$)';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return 'Enter a valid quantity > 0';
  } else if (!regExp.hasMatch(value)) {
    return 'Enter a valid quantity > 0';
  }
  return null;
}

String priceValidator(String value) {
  String pattern = r'(^\$?(([1-9]\d{0,2}(,\d{3})*)|0)?\.\d{2}$)';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return 'Enter a price';
  } else if (!regExp.hasMatch(value)) {
    return 'Enter a valid price (eg. 3.45)';
  }
  return null;
}

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

Icon getStatus(String status) {
    if (status == "DELIVERED") {
      return Icon(Icons.check);
    }
    return Icon(Icons.history);
  }