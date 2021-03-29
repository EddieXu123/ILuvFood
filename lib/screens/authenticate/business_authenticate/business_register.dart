import 'package:flutter/material.dart';
import 'package:iluvfood/services/auth.dart';
import 'package:iluvfood/shared/constants.dart';
import 'package:iluvfood/shared/utils.dart';
import 'package:iluvfood/shared/loading.dart';
import 'package:geocoder/geocoder.dart';

/*
BusinessRegister page UI
*/

class BusinessRegister extends StatefulWidget {
  final Function toggleView;
  BusinessRegister({this.toggleView});
  @override
  _BusinessRegisterState createState() => _BusinessRegisterState();
}

class _BusinessRegisterState extends State<BusinessRegister> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  final AuthService _auth = AuthService();
  // text field state
  String email = '';
  String password = '';
  String error = '';
  String businessName = '';
  String phone = '';
  String zipCode = '';
  String streetAddress = '';
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
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                        child: Text(
                          'Register',
                          style: TextStyle(
                              fontSize: 80.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(320.0, 0.0, 0.0, 0.0),
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
                    padding: EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0),
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
                                    labelText: "Supplier Name"),
                                validator: (val) =>
                                    val.isEmpty ? 'Enter a name' : null,
                                onChanged: (val) {
                                  businessName = val;
                                }),
                            SizedBox(height: 10.0),
                            TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    labelText: " Number"),
                                validator: (val) => validateMobile(val),
                                onChanged: (val) {
                                  phone = val;
                                }),

                            SizedBox(height: 10.0),
                            TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    labelText: "Street Address",
                                    hintText: "eg: 1600 Amphiteatre Parkway "),
                                validator: (val) => val.isEmpty
                                    ? 'Enter a street address'
                                    : null,
                                onChanged: (val) {
                                  streetAddress = val;
                                }),
                            SizedBox(height: 10.0),
                            TextFormField(
                                decoration: textInputDecoration.copyWith(
                                  labelText: "Zip Code",
                                ),
                                // validator: (val) => validateMobile(val),
                                onChanged: (val) {
                                  zipCode = val;
                                }),
                            // Row(children: <Widget>[
                            //   Flexible(
                            //     flex: 1,
                            //     child: TextFormField(
                            //         decoration: textInputDecoration.copyWith(
                            //             labelText: "Street Address",
                            //             hintText:
                            //                 "eg: 1600 Amphiteatre Parkway "),
                            //         validator: (val) => validateMobile(val),
                            //         onChanged: (val) {
                            //           phone = val;
                            //         }),
                            //   ),
                            //   SizedBox(
                            //     width: 10,
                            //   ),
                            //   Flexible(
                            //     flex: 1,
                            //     child: TextFormField(
                            //         decoration: textInputDecoration.copyWith(
                            //             labelText: "Zip Code"),
                            //         validator: (val) => validateMobile(val),
                            //         onChanged: (val) {
                            //           phone = val;
                            //         }),
                            //   ),
                            // ]),
                            SizedBox(height: 10.0),
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
                                        try {
                                          // get address
                                          final query =
                                              "$streetAddress, $zipCode";
                                          var addresses = await Geocoder.local
                                              .findAddressesFromQuery(query);
                                          var first = addresses.first;
                                          var addressLine = first.addressLine;
                                          var coords = first.coordinates;
                                          var lat = coords.latitude.toString();
                                          var lng = coords.longitude.toString();
                                          await _auth
                                              .businessRegisterWithEmailandPassword(
                                                  email,
                                                  password,
                                                  businessName,
                                                  phone,
                                                  addressLine,
                                                  lat,
                                                  lng);
                                          setState(() => loading = false);
                                          Navigator.pop(context);
                                        } catch (e) {
                                          if (mounted) {
                                            setState(() {
                                              error = e.message;
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
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Montserrat'),
                                      ),
                                    ),
                                  ),
                                )),
                            SizedBox(height: 5.0),
                            Container(
                              height: 30,
                              child: Text(
                                error,
                                style: TextStyle(
                                    color: Colors.red, fontSize: 12.0),
                              ),
                            ),
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
