import 'package:flutter/material.dart';
import 'package:iluvfood/screens/authenticate/business_authenticate/business_auth_controller.dart';
import 'package:iluvfood/screens/authenticate/customer_authenticate/customer_auth_controller.dart';
import 'package:iluvfood/screens/authenticate/onboarding.dart';

import 'package:iluvfood/shared/constants.dart';
import 'package:provider/provider.dart';

class Welcome extends StatelessWidget {
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
                    child: Text('Rescue.',
                        style: TextStyle(
                            fontSize: 60.0, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        110.0, 175.0, 0.0, 0.0), // Change if prefer aligned
                    child: Text('Feed.',
                        style: TextStyle(
                            fontSize: 60.0, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(155.0, 240.0, 0, 100.0),
                    child: Text('<3 food',
                        style: TextStyle(
                            fontSize: 60.0,
                            fontWeight: FontWeight.bold,
                            color: MyColors.myPink)),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 200.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          color: Theme.of(context).accentColor,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CustomerAuthenticate()));
                          },
                          child: Text('Sign in as Rescuer',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat')),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BusinessAuthenticate()));
                          },
                          child: Text(
                            'I\'m a Supplier',
                            style: linkedPageTextStyle,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Onboarding()));
                          },
                          child: Text(
                            'How It Works',
                            style: thirdTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
          ],
        ));
  }
}
