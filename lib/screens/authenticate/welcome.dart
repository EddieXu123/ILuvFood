import 'package:flutter/material.dart';
import 'package:iluvfood/screens/authenticate/customer_authenticate/authenticate.dart';
import 'package:iluvfood/screens/authenticate/customer_authenticate/register.dart';

import 'package:iluvfood/shared/constants.dart';
import 'package:provider/provider.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                    child: Text('Eat',
                        style: TextStyle(
                            fontSize: 60.0, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        30.0, 175.0, 0.0, 0.0), // Change if prefer aligned
                    child: Text('Save',
                        style: TextStyle(
                            fontSize: 60.0, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(45.0, 240.0, 80.0, 100.0),
                    child: Text('<3_food',
                        style: TextStyle(
                            fontSize: 60.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink)),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 15.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          color: Colors.pink,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.red)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Authenticate()));
                          },
                          child: Text('Business Login',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat')),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          color: Colors.pink,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.red)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Authenticate()));
                          },
                          child: Text('Customer Login',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat')),
                        ),
                      ],
                    ),
                  ]),
            ),
          ],
        ));
  }
}

// import 'package:flutter/material.dart';
// import 'package:iluvfood/screens/home/home.dart';
// import 'package:iluvfood/shared/constants.dart';
// import 'package:provider/provider.dart';

// class Welcome extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final authuser = Provider.of<AuthUser>(context);
//     print(authuser == null);
//     return authuser != null
//         ? Home()
//         : new Scaffold(
//             resizeToAvoidBottomPadding: false,
//             body: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Container(
//                   child: Stack(
//                     children: <Widget>[
//                       Container(
//                         padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
//                         child: Text('Welcome',
//                             style: TextStyle(
//                                 fontSize: 60.0, fontWeight: FontWeight.bold)),
//                       ),
//                       Container(
//                         padding: EdgeInsets.fromLTRB(
//                             30.0, 175.0, 0.0, 0.0), // Change if prefer aligned
//                         child: Text('to ',
//                             style: TextStyle(
//                                 fontSize: 50.0, fontWeight: FontWeight.bold)),
//                       ),
//                       Container(
//                         padding: EdgeInsets.fromLTRB(30.0, 225.0, 80.0, 100.0),
//                         child: Text('iLuvFood',
//                             style: TextStyle(
//                                 fontSize: 60.0,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.pink)),
//                       )
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 15.0),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     InkWell(
//                       onTap: () {
//                         Navigator.pushNamed(context, '/customer_auth');
//                       },
//                       child: Text(
//                         'Customer Login',
//                         style: linkedPageTextStyle,
//                       ),
//                     )
//                   ],
//                 ),
//                 SizedBox(height: 15.0),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     InkWell(
//                       onTap: () {},
//                       child: Text(
//                         'Business Login',
//                         style: linkedPageTextStyle,
//                       ),
//                     )
//                   ],
//                 ),
//               ],
//             ));
//   }
// }
