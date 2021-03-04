import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iluvfood/models/cart.dart';
import 'package:iluvfood/screens/home/customer/checkout.dart';
import 'package:iluvfood/screens/wrapper.dart';
import 'package:iluvfood/services/auth.dart';
import 'package:iluvfood/shared/constants.dart';
import 'package:iluvfood/shared/errorPage.dart';
import 'package:iluvfood/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeData _themeData;
  bool _darkModeOn = true;
  ThemeNotifier(this._themeData, this._darkModeOn);

  ThemeData getTheme() => _themeData;
  bool darkModeIsOn() => _darkModeOn;

  void setTheme(ThemeData themeData) async {
    _themeData = themeData;
    notifyListeners();
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  var darkModeOn = false;
  runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(
          getThemeData(Colors.cyanAccent, darkModeOn), darkModeOn),
      child: MyApp(),
    ),
  );
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
        final themeNotifier = Provider.of<ThemeNotifier>(context);
        // Check for errors
        if (snapshot.hasError) {
          return ErrorPage();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return ChangeNotifierProvider(
              create: (context) => CartModel(),
              child: StreamProvider<User>.value(
                value: AuthService().user,
                child: MaterialApp(
                  theme: themeNotifier.getTheme(),
                  initialRoute: '/wrapper',
                  routes: {
                    '/wrapper': (context) => Wrapper(),
                    '/cart': (context) => Checkout()
                  },
                ),
              ));
        }
        // Otherwise, show something whilst waiting for initialization to complete
        return Loading();
      },
    );
  }
}

ThemeData getThemeData(Color accentColor, bool darkTheme) {
  //print('dark theme is $darkTheme');
  return ThemeData(
      // brightness: Brightness.light,
      // primarySwatch: Colors.pink,
      primaryColor: MyColors.myGreen,
      scaffoldBackgroundColor: MyColors.myPurple,
      // primaryColorBrightness: Brightness.light,
      accentColor: MyColors.myGreen,
      // accentColorBrightness: Brightness.light);
      textTheme: TextTheme(
        bodyText1: TextStyle(fontSize: 18.0),
        bodyText2: TextStyle(fontSize: 16.0),
      ),
      buttonTheme: ButtonThemeData(
          buttonColor: MyColors.myGreen,
          splashColor: MyColors.myPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          )));
}
