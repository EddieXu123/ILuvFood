import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iluvfood/models/customer.dart';
import 'package:iluvfood/screens/home/customer/order_history.dart';
import 'package:iluvfood/screens/home/customer/password_reset.dart';
import 'package:iluvfood/services/auth.dart';
import 'package:iluvfood/services/database.dart';
import 'package:iluvfood/shared/constants.dart';
import 'package:iluvfood/shared/utils.dart';
import 'package:iluvfood/shared/loading.dart';
import 'package:provider/provider.dart';

class CustomerProfile extends StatefulWidget {
  final Customer customer;
  final AuthService auth;
  CustomerProfile({this.customer, this.auth});

  @override
  _CustomerProfileState createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String _customerName = '';
  String _customerEmail = '';
  String _customerPhone = '';
  bool changed = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<Customer>(
        stream: DatabaseService(uid: user.uid).customerData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Customer customer = snapshot.data;
            _customerName = customer.name;
            _customerEmail = customer.email;
            _customerPhone = customer.phone;
            return Scaffold(
              resizeToAvoidBottomInset: false,
              key: _scaffoldKey,
              appBar: AppBar(
                title: Text("Profile Page"),
                centerTitle: true,
              ),
              body: Container(
                  padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          initialValue: _customerEmail,
                          readOnly: true,
                          decoration:
                              textInputDecoration.copyWith(labelText: "Email"),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                            initialValue: _customerName,
                            decoration:
                                textInputDecoration.copyWith(labelText: "Name"),
                            validator: (val) =>
                                val.isEmpty ? 'Enter a name' : null,
                            onChanged: (val) {
                              changed = true;
                              _customerName = val;
                            }),
                        SizedBox(height: 20.0),
                        TextFormField(
                            initialValue: _customerPhone,
                            decoration: textInputDecoration.copyWith(
                                labelText: "Phone Number"),
                            validator: (val) => validateMobile(val),
                            onChanged: (val) {
                              changed = true;
                              _customerPhone = val;
                            }),
                        SizedBox(height: 20.0),
                        Container(
                          height: 40.0,
                          child: FlatButton(
                            color: Theme.of(context).accentColor,
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                print(_customerName);
                                try {
                                  if (changed) {
                                    await DatabaseService.updateCustomerData(
                                        user.uid,
                                        _customerName,
                                        _customerPhone);
                                    print("Updated profile");
                                    _scaffoldKey.currentState
                                        .showSnackBar(SnackBar(
                                      backgroundColor: Colors.pink,
                                      duration: Duration(seconds: 2),
                                      content: Text(
                                        "Profile successfully updated",
                                        textAlign: TextAlign.center,
                                      ),
                                    ));
                                    changed = false;
                                  } else {
                                    _scaffoldKey.currentState
                                        .showSnackBar(SnackBar(
                                      backgroundColor: Colors.pink,
                                      duration: Duration(seconds: 2),
                                      content: Text(
                                        "No changes made",
                                        textAlign: TextAlign.center,
                                      ),
                                    ));
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              }
                            },
                            child: Center(
                              child: Text(
                                'Update Profile',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 140.0),
                        Container(
                          height: 40.0,
                          child: FlatButton(
                            color: Theme.of(context).accentColor,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OrderHistory()));
                              print('Order History');
                            },
                            child: Center(
                              child: Text(
                                'Order History',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          height: 40.0,
                          child: FlatButton(
                            color: Theme.of(context).accentColor,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PasswordReset()));
                              print('Reset Password');
                            },
                            child: Center(
                              child: Text(
                                'Reset Password',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            );
          } else {
            return Loading();
          }
        });
  }
}
