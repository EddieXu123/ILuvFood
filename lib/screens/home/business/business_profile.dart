import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoder/geocoder.dart';
import 'package:iluvfood/models/business.dart';
import 'package:iluvfood/services/database.dart';
import 'package:iluvfood/shared/constants.dart';
import 'package:iluvfood/shared/utils.dart';
import 'package:iluvfood/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class BusinessProfile extends StatefulWidget {
  @override
  _BusinessProfileState createState() => _BusinessProfileState();
}

class _BusinessProfileState extends State<BusinessProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  String error = '';
  final _formKey = GlobalKey<FormState>();
  String _businessName = '';
  String _address = '';
  String _lat = '';
  String _lng = '';
  String _phone = '';
  bool changed = false;
  final TextEditingController _controller0 = new TextEditingController();
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
            _controller0.text = _address;
            print("NEW ADDRESS: $_address");
            return new Scaffold(
                resizeToAvoidBottomInset: false,
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
                                    labelText: "Supplier Name"),
                                validator: (val) =>
                                    val.isEmpty ? 'Enter a name' : null,
                                onChanged: (val) {
                                  changed = true;
                                  _businessName = val;
                                }),
                            SizedBox(height: 10.0),
                            TextFormField(
                                key: Key(_address),
                                controller: _controller0,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                // initialValue:
                                //     businessData.address.replaceAll("\n", ""),
                                decoration: textInputDecoration.copyWith(
                                    labelText: "Address"),
                                validator: (val) =>
                                    val.isEmpty ? 'Enter an address' : null,
                                onChanged: (val) {
                                  changed = true;
                                  _address = val;
                                }),
                            SizedBox(height: 20.0),
                            TextFormField(
                                initialValue: businessData.phone,
                                decoration: textInputDecoration.copyWith(
                                    labelText: "Phone"),
                                validator: (val) => validateMobile(val),
                                onChanged: (val) {
                                  changed = true;
                                  _phone = val;
                                }),
                            SizedBox(height: 10.0),
                            TextFormField(
                                key: Key(_lng),
                                enabled: false,
                                initialValue: _lng,
                                decoration: textInputDecoration.copyWith(
                                    labelText: "GPS longitude"),
                                validator: (val) =>
                                    val.isEmpty ? 'Enter a longitude' : null,
                                onChanged: (val) {
                                  // changed = true;
                                  // _lng = val;
                                }),
                            SizedBox(height: 10.0),
                            TextFormField(
                                enabled: false,
                                key: Key(_lat),
                                initialValue: _lat,
                                decoration: textInputDecoration.copyWith(
                                    labelText: "GPS latitude"),
                                validator: (val) =>
                                    val.isEmpty ? 'Enter a latitude' : null,
                                onChanged: (val) {
                                  // changed = true;
                                  // _lat = val;
                                }),
                            SizedBox(height: 20.0),
                            Container(
                              height: 40.0,
                              child: FlatButton(
                                color: Theme.of(context).accentColor,
                                onPressed: () async {
                                  FocusScope.of(context).unfocus();
                                  if (_formKey.currentState.validate()) {
                                    setState(() => loading = true);
                                    try {
                                      if (changed) {
                                        _controller0.clear();
                                        final query = "$_address";
                                        var addresses = await Geocoder.local
                                            .findAddressesFromQuery(query);
                                        var first = addresses.first;
                                        var addressLine = first.addressLine;
                                        var coords = first.coordinates;
                                        var lat = coords.latitude.toString();
                                        var lng = coords.longitude.toString();
                                        print(
                                            "geocoder addresline: $addressLine");
                                        await DatabaseService(uid: user.uid)
                                            .updateBusinessData(Business(
                                                uid: user.uid,
                                                address: addressLine,
                                                lat: lat,
                                                lng: lng,
                                                businessName: _businessName,
                                                phone: _phone));
                                        setState(() {
                                          loading = false;
                                        });
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
                                      if (mounted) {
                                        setState(() {
                                          _scaffoldKey.currentState
                                              .showSnackBar(SnackBar(
                                            backgroundColor: Colors.pink,
                                            duration: Duration(seconds: 2),
                                            content: Text(
                                              "Error Updating Profile",
                                              textAlign: TextAlign.center,
                                            ),
                                          ));
                                          loading = false;
                                          error = e.message;
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
