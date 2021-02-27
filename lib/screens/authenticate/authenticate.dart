import 'package:flutter/material.dart';
import 'package:iluvfood/screens/authenticate/register.dart';
import 'package:iluvfood/screens/authenticate/sign_in.dart';

/*
Controller to display either sign in or register page
*/
class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleView() {
    setState(() => {showSignIn = !showSignIn});
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}
