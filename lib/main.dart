import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iluvfood/screens/wrapper.dart';
import 'package:iluvfood/services/auth.dart';
import 'package:iluvfood/shared/errorPage.dart';
import 'package:iluvfood/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return ErrorPage();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamProvider<User>.value(
            value: AuthService().user,
            child: MaterialApp(
              initialRoute: '/wrapper',
              routes: {
                '/wrapper': (context) => Wrapper(),
              },
            ),
          );
        }
        // Otherwise, show something whilst waiting for initialization to complete
        return Loading();
      },
    );
  }
}

// class MyApp extends StatelessWidget {
//   final Future<FirebaseApp> _initialization = Firebase.initializeApp();
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return StreamProvider<AuthUser>.value(
//       value: AuthService().authuser,
//       child: MaterialApp(
//         home: Wrapper(),
//         routes: {
//           // When navigating to the "/" route, build the FirstScreen widget.
//           '/customer_auth': (context) => Authenticate(),
//           // When navigating to the "/second" route, build the SecondScreen widget.
//           // '/second': (context) => SecondScreen(),
//         },
//         // home: Wrapper(),
//       ),
//     );
//   }
// }
