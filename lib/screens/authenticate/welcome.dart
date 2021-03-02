import 'package:flutter/material.dart';
import 'package:iluvfood/screens/authenticate/customer_authenticate/authenticate.dart';
import 'package:iluvfood/screens/authenticate/customer_authenticate/register.dart';
import 'package:iluvfood/screens/home/home.dart';
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
                    child: Text('Welcome',
                        style: TextStyle(
                            fontSize: 60.0, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        30.0, 175.0, 0.0, 0.0), // Change if prefer aligned
                    child: Text('to ',
                        style: TextStyle(
                            fontSize: 50.0, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(30.0, 225.0, 80.0, 100.0),
                    child: Text('iLuvFood',
                        style: TextStyle(
                            fontSize: 60.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink)),
                  )
                ],
              ),
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
                            builder: (context) => Authenticate()));
                  },
                  child: Text(
                    'Customer Login',
                    style: linkedPageTextStyle,
                  ),
                )
              ],
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () {},
                  child: Text(
                    'Business Login',
                    style: linkedPageTextStyle,
                  ),
                )
              ],
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
