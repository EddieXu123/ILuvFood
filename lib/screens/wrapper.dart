import 'package:flutter/material.dart';
import 'package:iluvfood/models/user.dart';
import 'package:iluvfood/screens/authenticate/authenticate.dart';
import 'package:iluvfood/screens/authenticate/sign_in.dart';
import 'package:iluvfood/screens/authenticate/welcome.dart';
import 'package:iluvfood/screens/home/home.dart';
import 'package:provider/provider.dart';

/*
Use provider to properly display either authentication screens or logged
in screen
*/
class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthUser>(context);
    if (user == null) {
      return Welcome();
      return Authenticate();
    } else {
      return Home();
    }
  }
}
