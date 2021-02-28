import 'package:flutter/material.dart';
import 'package:iluvfood/services/auth.dart';
import 'package:iluvfood/shared/constants.dart';
import 'package:iluvfood/shared/loading.dart';

/*
Class that takes care of Sign In related things
*/
class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  // text field state
  String email = '';
  String password = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                    child: Text('Love',
                        style: TextStyle(
                            fontSize: 80.0, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        30.0, 175.0, 0.0, 0.0), // Change if prefer aligned
                    child: Text('Food',
                        style: TextStyle(
                            fontSize: 80.0, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(213.0, 175.0, 0.0, 0.0),
                    child: Text('?',
                        style: TextStyle(
                            fontSize: 80.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink)),
                  )
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                            decoration: textInputDecoration.copyWith(
                                labelText: "Email"),
                            validator: (val) =>
                                val.isEmpty ? 'Enter an email' : null,
                            onChanged: (val) {
                              email = val;
                            }),
                        SizedBox(height: 20.0),
                        TextFormField(
                            decoration: textInputDecoration.copyWith(
                                labelText: "Password"),
                            obscureText: true,
                            validator: (val) =>
                                val.isEmpty ? 'Enter a password' : null,
                            onChanged: (val) {
                              password = val;
                            }),
                        SizedBox(height: 5.0),
                        Container(
                          alignment: Alignment(1.0, 0.0),
                          padding: EdgeInsets.only(top: 15.0, left: 20.0),
                          child: InkWell(
                            child: Text(
                              'Forgot Password',
                              style: linkedPageTextStyle,
                            ),
                          ),
                        ),
                        SizedBox(height: 40.0),
                        Container(
                          height: 40.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.pinkAccent,
                            color: Colors.pink,
                            elevation: 7.0,
                            child: GestureDetector(
                              onTap: () async {
                                print(email);
                                if (_formKey.currentState.validate()) {
                                  dynamic result = await _auth
                                      .customerSignInWithEmailandPassword(
                                          email, password);
                                  if (result == null) {
                                    setState(() {
                                      error =
                                          'could not sign in with these credentials';
                                    });
                                  }
                                }
                              },
                              child: Center(
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          height: 40.0,
                          color: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black,
                                    style: BorderStyle.solid,
                                    width: 1.0),
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(width: 10.0),
                                Center(
                                  child: Text('Todo: Other Login Method',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat')),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ))),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'New to iLuvFood?',
                  style: TextStyle(fontFamily: 'Montserrat'),
                ),
                SizedBox(width: 5.0),
                InkWell(
                  onTap: () {
                    widget.toggleView();
                  },
                  child: Text(
                    'Register',
                    style: linkedPageTextStyle,
                  ),
                )
              ],
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Back',
                    style: linkedPageTextStyle,
                  ),
                )
              ],
            ),
          ],
        ));
  }
}

// import 'package:flutter/material.dart';
// import 'package:iluvfood/services/auth.dart';
// import 'package:iluvfood/shared/constants.dart';
// import 'package:iluvfood/shared/loading.dart';

// /*
// Class that takes care of Sign In related things
// */
// class SignIn extends StatefulWidget {
//   final Function toggleView;
//   SignIn({this.toggleView});
//   @override
//   _SignInState createState() => _SignInState();
// }

// class _SignInState extends State<SignIn> {
//   final _formKey = GlobalKey<FormState>();
//   bool loading = false;
//   final AuthService _auth = AuthService();
//   // text field state
//   String email = '';
//   String password = '';
//   String error = '';
//   @override
//   Widget build(BuildContext context) {
//     return loading
//         ? Loading()
//         : new Scaffold(
//             resizeToAvoidBottomPadding: false,
//             body: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Container(
//                   child: Stack(
//                     children: <Widget>[
//                       Container(
//                         padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
//                         child: Text('Love',
//                             style: TextStyle(
//                                 fontSize: 80.0, fontWeight: FontWeight.bold)),
//                       ),
//                       Container(
//                         padding: EdgeInsets.fromLTRB(
//                             30.0, 175.0, 0.0, 0.0), // Change if prefer aligned
//                         child: Text('Food',
//                             style: TextStyle(
//                                 fontSize: 80.0, fontWeight: FontWeight.bold)),
//                       ),
//                       Container(
//                         padding: EdgeInsets.fromLTRB(213.0, 175.0, 0.0, 0.0),
//                         child: Text('?',
//                             style: TextStyle(
//                                 fontSize: 80.0,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.pink)),
//                       )
//                     ],
//                   ),
//                 ),
//                 Container(
//                     padding:
//                         EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
//                     child: Form(
//                         key: _formKey,
//                         child: Column(
//                           children: <Widget>[
//                             TextFormField(
//                                 decoration: textInputDecoration.copyWith(
//                                     labelText: "Email"),
//                                 validator: (val) =>
//                                     val.isEmpty ? 'Enter an email' : null,
//                                 onChanged: (val) {
//                                   email = val;
//                                 }),
//                             SizedBox(height: 20.0),
//                             TextFormField(
//                                 decoration: textInputDecoration.copyWith(
//                                     labelText: "Password"),
//                                 obscureText: true,
//                                 validator: (val) =>
//                                     val.isEmpty ? 'Enter a password' : null,
//                                 onChanged: (val) {
//                                   password = val;
//                                 }),
//                             SizedBox(height: 5.0),
//                             Container(
//                               alignment: Alignment(1.0, 0.0),
//                               padding: EdgeInsets.only(top: 15.0, left: 20.0),
//                               child: InkWell(
//                                 child: Text(
//                                   'Forgot Password',
//                                   style: linkedPageTextStyle,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: 40.0),
//                             Container(
//                               height: 40.0,
//                               child: Material(
//                                 borderRadius: BorderRadius.circular(20.0),
//                                 shadowColor: Colors.pinkAccent,
//                                 color: Colors.pink,
//                                 elevation: 7.0,
//                                 child: GestureDetector(
//                                   onTap: () async {
//                                     print(email);
//                                     if (_formKey.currentState.validate()) {
//                                       setState(() => loading = true);
//                                       dynamic result = await _auth
//                                           .customerSignInWithEmailandPassword(
//                                               email, password);
//                                       if (result == null) {
//                                         setState(() {
//                                           error =
//                                               'could not sign in with these credentials';
//                                           loading = false;
//                                         });
//                                       }
//                                     }
//                                   },
//                                   child: Center(
//                                     child: Text(
//                                       'LOGIN',
//                                       style: TextStyle(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold,
//                                           fontFamily: 'Montserrat'),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: 12.0),
//                             Text(
//                               error,
//                               style:
//                                   TextStyle(color: Colors.red, fontSize: 14.0),
//                             ),
//                             SizedBox(height: 20.0),
//                             Container(
//                               height: 40.0,
//                               color: Colors.transparent,
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                     border: Border.all(
//                                         color: Colors.black,
//                                         style: BorderStyle.solid,
//                                         width: 1.0),
//                                     color: Colors.transparent,
//                                     borderRadius: BorderRadius.circular(20.0)),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: <Widget>[
//                                     SizedBox(width: 10.0),
//                                     Center(
//                                       child: Text('Todo: Other Login Method',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontFamily: 'Montserrat')),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             )
//                           ],
//                         ))),
//                 SizedBox(height: 15.0),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Text(
//                       'New to iLuvFood?',
//                       style: TextStyle(fontFamily: 'Montserrat'),
//                     ),
//                     SizedBox(width: 5.0),
//                     InkWell(
//                       onTap: () {
//                         widget.toggleView();
//                       },
//                       child: Text(
//                         'Register',
//                         style: linkedPageTextStyle,
//                       ),
//                     )
//                   ],
//                 ),
//                 SizedBox(height: 15.0),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     InkWell(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: Text(
//                         'Back',
//                         style: linkedPageTextStyle,
//                       ),
//                     )
//                   ],
//                 ),
//               ],
//             ));
//   }
// }
