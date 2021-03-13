import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iluvfood/models/customer.dart';
import 'package:iluvfood/services/auth.dart';
import 'package:iluvfood/services/database.dart';
import 'package:iluvfood/shared/constants.dart';
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
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String _customerName = '';
  String _customerEmail = '';
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
            return Scaffold(
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
                          decoration: textInputDecoration.copyWith(
                              labelText: "Customer Email"),
                          validator: (val) =>
                              val.isEmpty ? 'No email found' : null,
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                            initialValue: _customerName,
                            decoration: textInputDecoration.copyWith(
                                labelText: "Customer Name"),
                            onChanged: (val) {
                              _customerName = val;
                            }),
                        SizedBox(height: 20.0),
                        TextFormField(
                          initialValue: "************",
                          readOnly: true,
                          decoration: textInputDecoration.copyWith(
                              labelText: "Password"),
                        ),
                        InkWell(
                          onTap: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             BusinessAuthenticate()));
                            print('Reset Password');
                          },
                          child: Text(
                            'Reset Password',
                            style: linkedPageTextStyle,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          height: 40.0,
                          child: FlatButton(
                            color: Theme.of(context).accentColor,
                            onPressed: () {
                              print(_customerName);
                              try {
                                DatabaseService(uid: user.uid)
                                    .updateCustomerData(_customerName);
                              } catch (e) {
                                print(e);
                              }
                            },
                            child: Center(
                              child: Text(
                                'Update Profile',
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
          } else {
            return Loading();
          }
        });
  }
  // return Container(
  //   Text("MY CUSTOMER PROFILE"),
  // );
}
