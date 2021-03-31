import 'package:flutter/material.dart';
import 'package:iluvfood/services/auth.dart';
import 'package:iluvfood/shared/constants.dart';

/*
Class that takes care of Sign In related things
*/
class BusinessSignIn extends StatefulWidget {
  final Function toggleView;
  BusinessSignIn({this.toggleView});
  @override
  _BusinessSignInState createState() => _BusinessSignInState();
}

class _BusinessSignInState extends State<BusinessSignIn> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  // text field state
  String email = '';
  String password = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                    child: Text('Supplier',
                        style: TextStyle(
                            fontSize: 80.0, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        80.0, 190.0, 0.0, 0.0), // Change if prefer aligned
                    child: Text('Sign In',
                        style: TextStyle(
                            fontSize: 80.0, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(330.0, 190.0, 0.0, 0.0),
                    child: Text(
                      '.',
                      style: TextStyle(
                          fontSize: 80.0,
                          fontWeight: FontWeight.bold,
                          // Change color if needed
                          color: Colors.pink),
                    ),
                  ),
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
                            keyboardType: TextInputType.emailAddress,
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
                        SizedBox(height: 20.0),
                        Container(
                          height: 40.0,
                          child: FlatButton(
                            color: Theme.of(context).accentColor,
                            onPressed: () async {
                              print(email);
                              if (_formKey.currentState.validate()) {
                                try {
                                  email = email;
                                  print(email);
                                  await _auth.signInWithEmailandPassword(
                                      email, password);
                                  Navigator.pop(context);
                                } catch (e) {
                                  if (mounted) {
                                    setState(() => {error = e.message});
                                  }
                                }
                              }
                            },
                            child: Center(
                              child: Text(
                                'LOGIN',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          height: 30,
                          child: Text(
                            error,
                            style: TextStyle(color: Colors.red, fontSize: 12.0),
                          ),
                        ),
                      ],
                    ))),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Create your supplier account:',
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
