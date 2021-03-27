import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iluvfood/models/business.dart';
import 'package:iluvfood/models/business_item.dart';
import 'package:iluvfood/screens/home/business/business_drawer.dart';
import 'package:iluvfood/services/auth.dart';
import 'package:iluvfood/services/database.dart';
import 'package:iluvfood/shared/constants.dart';

import 'package:iluvfood/shared/loading.dart';
import 'package:iluvfood/shared/utils.dart';
import 'package:provider/provider.dart';

/*
Customer landing page after they log in
*/
class BusinessAddMenu extends StatefulWidget {
  @override
  _BusinessAddMenuState createState() => _BusinessAddMenuState();
}

class _BusinessAddMenuState extends State<BusinessAddMenu> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  // text field state
  String item = '';
  String price = '';
  String quantity = '';
  String error = '';
  final TextEditingController _controller0 = new TextEditingController();
  final TextEditingController _controller1 = new TextEditingController();
  final TextEditingController _controller2 = new TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<Business>(
        stream: DatabaseService(uid: user.uid).businessData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Business business = snapshot.data;
            return new Scaffold(
                key: _scaffoldKey,
                drawer: BusinessDrawer(),
                appBar: AppBar(
                  title: Text(
                      '${business.businessName ?? "<no name found>"} Portal'),
                  elevation: 0.0,
                  // actions: <Widget>[
                  //   FlatButton.icon(
                  //     icon: Icon(Icons.logout),
                  //     onPressed: () async {
                  //       await _auth.signOut();
                  //     },
                  //     label: Text(''),
                  //   )
                  // ]
                ),
                resizeToAvoidBottomInset: false,
                body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Stack(
                          children: <Widget>[
                            Container(
                              padding:
                                  EdgeInsets.fromLTRB(15.0, 20.0, 0.0, 0.0),
                              child: Text(
                                "add food",
                                style: TextStyle(
                                    fontSize: 80.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding:
                                  EdgeInsets.fromLTRB(330.0, 20.0, 0.0, 0.0),
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
                          padding: EdgeInsets.only(
                              top: 35.0, left: 20.0, right: 20.0),
                          child: Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                      controller: _controller0,
                                      decoration: textInputDecoration.copyWith(
                                          labelText: "Entree"),
                                      validator: (val) => val.isEmpty
                                          ? 'Enter an entree'
                                          : null,
                                      onChanged: (val) {
                                        item = val;
                                      }),
                                  SizedBox(height: 10.0),
                                  TextFormField(
                                      controller: _controller1,
                                      keyboardType: TextInputType.number,
                                      decoration: textInputDecoration.copyWith(
                                          labelText: "Price"),
                                      validator: numberValidator,
                                      onChanged: (val) {
                                        price = val;
                                      }),
                                  SizedBox(height: 10.0),
                                  TextFormField(
                                      controller: _controller2,
                                      keyboardType: TextInputType.number,
                                      decoration: textInputDecoration.copyWith(
                                          labelText: "Quantity"),
                                      validator: numberValidator,
                                      onChanged: (val) {
                                        quantity = val;
                                      }),
                                  SizedBox(height: 20.0),
                                  Container(
                                    height: 40.0,
                                    child: RaisedButton(
                                      color: Theme.of(context).accentColor,
                                      onPressed: () async {
                                        _formKey.currentState.validate();
                                        if (_formKey.currentState.validate()) {
                                          setState(() => loading = true);
                                          try {
                                            print(item + price + quantity);
                                            await DatabaseService(uid: user.uid)
                                                .enterBusinessItem(BusinessItem(
                                                    item: item,
                                                    price: price,
                                                    quantity: quantity));
                                            setState(() => loading = false);
                                            _clearControllers();
                                            _scaffoldKey.currentState
                                                .showSnackBar(SnackBar(
                                              backgroundColor: Colors.pink,
                                              duration: Duration(seconds: 2),
                                              content: Text(
                                                "Item successfully added",
                                                textAlign: TextAlign.center,
                                              ),
                                            ));
                                          } catch (e) {
                                            if (mounted) {
                                              setState(() {
                                                loading = false;
                                                error = e.message;
                                              });
                                            }
                                          }
                                        }
                                      },
                                      child: Center(
                                        child: Text(
                                          'SUBMIT',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Montserrat'),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 12.0),
                                  Text(error,
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 14.0)),
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
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                      child: InkWell(
                                        onTap: () {
                                          _clearControllers();
                                        },
                                        child: Center(
                                          child: Text('CLEAR',
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
          } else {
            print("LOADING BUSINESS HOME");
            return Loading();
          }
        });
  }

  void _clearControllers() {
    _controller0.clear();
    _controller1.clear();
    _controller2.clear();
  }
}

void showSnackBar(GlobalKey<ScaffoldState> _scaffoldKey, String message) {
  final snackBar = SnackBar(
    duration: Duration(seconds: 2),
    backgroundColor: MyColors.myGreen,
    content: Text(message),
  );
  _scaffoldKey.currentState.showSnackBar(snackBar);
}
