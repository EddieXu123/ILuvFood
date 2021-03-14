import 'package:flutter/material.dart';
import 'package:iluvfood/screens/home/customer/customer_home.dart';
import 'package:iluvfood/screens/home/customer/customer_profile.dart';
import 'package:iluvfood/shared/constants.dart';
import 'package:iluvfood/shared/errorPage.dart';

/// This is the stateful widget that the main application instantiates.
class CustomerHomeController extends StatefulWidget {
  final List<Widget> screens = <Widget>[
    // maps page
    CustomerHome(),

    // account page
    CustomerProfile(),

    // // favorites page
    // ErrorPage(),
  ];
  @override
  _CustomerHomeControllerState createState() => _CustomerHomeControllerState();
}

/// This is the private State class that goes with CustomerHomeControllert.
class _CustomerHomeControllerState extends State<CustomerHomeController> {
  int _currentIndex = 0;
<<<<<<< HEAD
  // static const TextStyle optionStyle =
  //     TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  // static

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _currentIndex = index;
  //   });
  // }
=======
>>>>>>> 59aaef2942a75fd3df8b6af274c23d26d2a83e79

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: widget.screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
          fixedColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(icon: new Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: new Icon(Icons.account_circle), label: "Account")
          ]),
    );
    // return Scaffold(
    //   body: Center(
    //     child: _widgetOptions.elementAt(_currentIndex),
    //   ),
    //   bottomNavigationBar: BottomNavigationBar(
    //     backgroundColor: MyColors.myPurple,
    //     items: const <BottomNavigationBarItem>[
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.home),
    //         label: 'Home',
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.account_circle),
    //         label: 'Account',
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.favorite),
    //         label: 'Favorites',
    //       ),
    //     ],
    //     currentIndex: _currentIndex,
    //     selectedItemColor: MyColors.myPink,
    //     onTap: _onItemTapped,
    //   ),
    // );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

// import 'package:flutter/material.dart';
// import 'package:iluvfood/screens/home/customer/customer_home.dart';
// import 'package:iluvfood/screens/home/customer/customer_profile.dart';
// import 'package:iluvfood/shared/constants.dart';
// import 'package:iluvfood/shared/errorPage.dart';

// /// This is the stateful widget that the main application instantiates.
// class CustomerHomeController extends StatefulWidget {
//   @override
//   _CustomerHomeControllerState createState() => _CustomerHomeControllerState();
// }

// /// This is the private State class that goes with CustomerHomeControllert.
// class _CustomerHomeControllerState extends State<CustomerHomeController> {
//   int _selectedIndex = 0;
//   static const TextStyle optionStyle =
//       TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
//   static List<Widget> _widgetOptions = <Widget>[
//     // maps page
//     CustomerHome(),

//     // account page
//     CustomerProfile(),

//     // favorites page
//     ErrorPage(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: _widgetOptions.elementAt(_selectedIndex),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: MyColors.myPurple,
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.account_circle),
//             label: 'Account',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.favorite),
//             label: 'Favorites',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: MyColors.myPink,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }
