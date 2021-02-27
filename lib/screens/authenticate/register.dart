import 'package:flutter/material.dart';
import 'package:iluvfood/services/auth.dart';
import 'package:iluvfood/shared/constants.dart';
import 'package:iluvfood/shared/loading.dart';
/*
Register page UI
*/

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  final AuthService _auth = AuthService();
  // text field state
  String email = '';
  String password = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : new Scaffold(
            resizeToAvoidBottomPadding: false,
            body:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                      child: Text(
                        'Register',
                        style: TextStyle(
                            fontSize: 80.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(308.0, 113.0, 0.0, 0.0),
                      child: Text(
                        '.',
                        style: TextStyle(
                            fontSize: 80.0,
                            fontWeight: FontWeight.bold,
                            // Change color if needed
                            color: Colors.pink),
                      ),
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
                          SizedBox(height: 10.0),
                          TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  labelText: "Password"),
                              obscureText: true,
                              validator: (val) => val.length < 6
                                  ? 'Enter an password longer than 6 characters'
                                  : null,
                              onChanged: (val) {
                                password = val;
                              }),
                          SizedBox(height: 10.0),
                          TextFormField(
                            decoration:
                                textInputDecoration.copyWith(labelText: "Name"),
                          ),
                          SizedBox(height: 50.0),
                          Container(
                              height: 40.0,
                              child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                shadowColor: Colors.pinkAccent,
                                color: Colors.pink,
                                elevation: 7.0,
                                child: GestureDetector(
                                  onTap: () async {
                                    if (_formKey.currentState.validate()) {
                                      setState(() => loading = true);
                                      dynamic result = await _auth
                                          .registerWithEmailandPassword(
                                              email, password);
                                      if (result == null) {
                                        setState(() {
                                          error = 'please supply a valid email';
                                          loading = false;
                                        });
                                      }
                                    }
                                  },
                                  child: Center(
                                    child: Text(
                                      'SIGNUP',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat'),
                                    ),
                                  ),
                                ),
                              )),
                          SizedBox(height: 12.0),
                          Text(error,
                              style:
                                  TextStyle(color: Colors.red, fontSize: 14.0)),
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
                              child: InkWell(
                                onTap: () {
                                  widget.toggleView();
                                },
                                child: Center(
                                  child: Text('LOG IN',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat')),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ))),
            ]));
  }
}