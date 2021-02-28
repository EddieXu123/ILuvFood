import 'package:flutter/material.dart';
import 'package:iluvfood/screens/authenticate/customer_authenticate/authenticate.dart';
import 'package:iluvfood/screens/wrapper.dart';
import 'package:iluvfood/services/auth.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AuthUser>.value(
      value: AuthService().authuser,
      child: MaterialApp(
        home: Wrapper(),
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/customer_auth': (context) => Authenticate(),
          // When navigating to the "/second" route, build the SecondScreen widget.
          // '/second': (context) => SecondScreen(),
        },
        // home: Wrapper(),
      ),
    );
  }
}
