import 'package:flutter/material.dart';
import 'package:iluvfood/screens/authenticate/customer_authenticate/customer_register.dart';
import 'package:iluvfood/screens/authenticate/customer_authenticate/customer_sign_in.dart';

/*
Controller to display either sign in or register page
*/
class CustomerAuthenticate extends StatefulWidget {
  @override
  _CustomerAuthenticateState createState() => _CustomerAuthenticateState();
}

class _CustomerAuthenticateState extends State<CustomerAuthenticate> {
  bool showSignIn = true;

  void toggleView() {
    setState(() => {showSignIn = !showSignIn});
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return CustomerSignIn(toggleView: toggleView);
    } else {
      return CustomerRegister(toggleView: toggleView);
    }
  }
}
