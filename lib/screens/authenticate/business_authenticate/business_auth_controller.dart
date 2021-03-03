import 'package:flutter/material.dart';
import 'package:iluvfood/screens/authenticate/business_authenticate/business_register.dart';
import 'package:iluvfood/screens/authenticate/business_authenticate/business_sign_in.dart';

/*
Controller to display either sign in or register page
*/
class BusinessAuthenticate extends StatefulWidget {
  @override
  _BusinessAuthenticateState createState() => _BusinessAuthenticateState();
}

class _BusinessAuthenticateState extends State<BusinessAuthenticate> {
  bool showSignIn = true;

  void toggleView() {
    setState(() => {showSignIn = !showSignIn});
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return BusinessSignIn(toggleView: toggleView);
    } else {
      return BusinessRegister(toggleView: toggleView);
    }
  }
}
