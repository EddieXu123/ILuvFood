import 'package:firebase_auth/firebase_auth.dart';
import 'package:iluvfood/models/business.dart';
import 'package:iluvfood/services/database.dart';
import 'package:iluvfood/shared/constants.dart';
import 'package:iluvfood/shared/errorPage.dart';
import 'package:iluvfood/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class BusinessProfileForm extends StatefulWidget {
  @override
  _BusinessProfileFormState createState() => _BusinessProfileFormState();
}

class _BusinessProfileFormState extends State<BusinessProfileForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  String error = '';
  final _formKey = GlobalKey<FormState>();
  String _businessName = '';
  String _address = '';
  String _lat = '';
  String _lng = '';
  String _phone = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<Business>(
        stream: DatabaseService(uid: user.uid).businessData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Business businessData = snapshot.data;
            _businessName = businessData.businessName;
            _address = businessData.address;
            _lat = businessData.lat;
            _lng = businessData.lng;
            _phone = businessData.phone;
            return new Scaffold(
                resizeToAvoidBottomPadding: false,
                key: _scaffoldKey,
                appBar: AppBar(
                  title: Text(
                    '${businessData.businessName ?? "<no name found>"} Profile',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
                  ),
                  elevation: 0.0,
                ),
                body: Container(
                    padding:
                        EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                                initialValue: businessData.businessName,
                                decoration: textInputDecoration.copyWith(
                                    labelText: "Business Name"),
                                validator: (val) =>
                                    val.isEmpty ? 'Enter an name' : null,
                                onChanged: (val) {
                                  _businessName = val;
                                }),
                            SizedBox(height: 10.0),
                            TextFormField(
                                initialValue:
                                    businessData.address.replaceAll("\n", ""),
                                decoration: textInputDecoration.copyWith(
                                    labelText: "Address"),
                                validator: (val) =>
                                    val.isEmpty ? 'Enter an address' : null,
                                onChanged: (val) {
                                  _address = val;
                                }),
                            SizedBox(height: 20.0),
                            TextFormField(
                                initialValue: businessData.phone,
                                decoration: textInputDecoration.copyWith(
                                    labelText: "Phone"),
                                validator: (val) => val.isEmpty
                                    ? 'Enter a a phone number'
                                    : null,
                                onChanged: (val) {
                                  _phone = val;
                                }),
                            SizedBox(height: 10.0),
                            TextFormField(
                                initialValue: businessData.lng,
                                decoration: textInputDecoration.copyWith(
                                    labelText: "GPS longitude"),
                                validator: (val) =>
                                    val.isEmpty ? 'Enter a longitude' : null,
                                onChanged: (val) {
                                  _lng = val;
                                }),
                            SizedBox(height: 10.0),
                            TextFormField(
                                initialValue: businessData.lat,
                                decoration: textInputDecoration.copyWith(
                                    labelText: "GPS latitude"),
                                validator: (val) =>
                                    val.isEmpty ? 'Enter a latitude' : null,
                                onChanged: (val) {
                                  _lat = val;
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
                                      print(_lng);
                                      await DatabaseService(uid: user.uid)
                                          .updateBusinessData(Business(
                                              uid: user.uid,
                                              address: _address,
                                              lat: _lat,
                                              lng: _lng,
                                              businessName: _businessName,
                                              phone: _phone));
                                      setState(() => loading = false);
                                      _scaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                        backgroundColor: Colors.pink,
                                        duration: Duration(seconds: 2),
                                        content: Text(
                                          "Profile successfully updated",
                                          textAlign: TextAlign.center,
                                        ),
                                      ));
                                    } catch (e) {
                                      if (mounted) {
                                        setState(() {
                                          loading = false;
                                          error = e.message();
                                        });
                                      }
                                    }
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
                        ))));
          } else {
            return Loading();
          }
        });
  }
}
