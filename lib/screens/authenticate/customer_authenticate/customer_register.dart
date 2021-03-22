import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iluvfood/services/auth.dart';
import 'package:iluvfood/shared/constants.dart';
import 'package:iluvfood/shared/loading.dart';
import 'package:iluvfood/shared/functions.dart';

/*
CustomerRegister page UI
*/

class CustomerRegister extends StatefulWidget {
  final Function toggleView;
  CustomerRegister({this.toggleView});
  @override
  _CustomerRegisterState createState() => _CustomerRegisterState();
}

class _CustomerRegisterState extends State<CustomerRegister> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  final AuthService _auth = AuthService();
  // text field state
  String email = '';
  String password = '';
  String error = '';
  String name = '';
  String phone = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : new Scaffold(
            body: Center(
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(15.0, 40.0, 0.0, 0.0),
                        child: Text(
                          'Customer Sign Up',
                          style: TextStyle(
                              fontSize: 80.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(300.0, 135.0, 0.0, 0.0),
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
                    padding:
                        EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
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
                                decoration: textInputDecoration.copyWith(
                                    labelText: "Name"),
                                validator: (val) =>
                                    val.isEmpty ? 'Enter a name' : null,
                                onChanged: (val) {
                                  name = val;
                                }),
                            SizedBox(height: 20.0),
                            TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    labelText: "Phone Number"),
                                validator: (val) => validateMobile(val),
                                onChanged: (val) {
                                  phone = val;
                                }),
                            SizedBox(height: 20.0),
                            Container(
                              height: 40.0,
                              child: FlatButton(
                                color: Theme.of(context).accentColor,
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() => loading = true);
                                    try {
                                      await _auth
                                          .customerRegisterWithEmailandPassword(
                                              email, password, name, phone);
                                      setState(() => loading = false);
                                      Navigator.pop(context);
                                    } catch (e) {
                                      if (mounted) {
                                        setState(() {
                                          error = e.message;
                                          print(error);
                                          loading = false;
                                        });
                                      }
                                    }
                                  }
                                },
                                child: Center(
                                  child: Text(
                                    'SIGNUP',
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
                                style: TextStyle(
                                    color: Colors.red, fontSize: 12.0),
                              ),
                            ),
                            SizedBox(height: 10.0),
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
                                    child: Text('Already have an account?',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Montserrat')),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ))),
              ]))));
  }
}
