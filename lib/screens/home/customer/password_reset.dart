import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iluvfood/models/customer.dart';
import 'package:iluvfood/services/auth.dart';
import 'package:iluvfood/services/database.dart';
import 'package:iluvfood/shared/constants.dart';
import 'package:iluvfood/shared/loading.dart';
import 'package:provider/provider.dart';

class PasswordReset extends StatefulWidget {
  final Customer customer;
  final AuthService auth;
  PasswordReset({this.customer, this.auth});

  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String _oldPassword = '';
  String _password = '';
  final TextEditingController _controller0 = new TextEditingController();
  final TextEditingController _controller1 = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Reset Password"),
        centerTitle: true,
      ),
      body: Container(
          padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                    controller: _controller0,
                    decoration:
                        textInputDecoration.copyWith(labelText: "Old Password"),
                    obscureText: true,
                    validator: (val) =>
                        val.isEmpty ? 'Enter old password' : null,
                    onChanged: (val) {
                      _oldPassword = val;
                    }),
                SizedBox(height: 20.0),
                TextFormField(
                    controller: _controller1,
                    decoration:
                        textInputDecoration.copyWith(labelText: "New Password"),
                    obscureText: true,
                    validator: (val) => val.length < 6
                        ? 'Enter an password longer than 6 characters'
                        : null,
                    onChanged: (val) {
                      _password = val;
                    }),
                SizedBox(height: 20.0),
                Container(
                  height: 40.0,
                  child: FlatButton(
                    color: Theme.of(context).accentColor,
                    onPressed: () async {
                      print(_password);
                      try {
                        EmailAuthCredential credential =
                            EmailAuthProvider.credential(
                                email: user.email, password: _oldPassword);
                        await FirebaseAuth.instance.currentUser
                            .reauthenticateWithCredential(credential);
                        await user.updatePassword(_password);
                        _clearControllers();
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          backgroundColor: Colors.pink,
                          duration: Duration(seconds: 2),
                          content: Text(
                            "Password updated.",
                            textAlign: TextAlign.center,
                          ),
                        ));
                        print("password updated succesfully");
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Center(
                      child: Text(
                        'Update Password',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  void _clearControllers() {
    _controller0.clear();
    _controller1.clear();
  }
}