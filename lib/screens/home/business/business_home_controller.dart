import 'package:flutter/material.dart';
import 'package:iluvfood/screens/home/business/business_menu.dart';
import 'package:iluvfood/screens/home/business/business_orders.dart';
import 'package:iluvfood/screens/home/business/business_profile.dart';
import 'package:iluvfood/screens/home/business/business_home.dart';

/// This is the stateful widget that the main application instantiates.
class BusinessHomeController extends StatefulWidget {
  final List<Widget> screens = <Widget>[
    // Home Page
    BusinessHome(),

    // Orders Page
    BusinessOrders(),

    // Menu Page
    BusinessMenu(),

    // Account page
    BusinessProfile(),
  ];
  @override
  _BusinessHomeControllerState createState() => _BusinessHomeControllerState();
}

/// This is the private State class that goes with CustomerHomeController
class _BusinessHomeControllerState extends State<BusinessHomeController> {
  int _currentIndex = 0;

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
                icon: new Icon(Icons.list), label: "Orders"),
            BottomNavigationBarItem(icon: new Icon(Icons.add), label: "Menu"),
            BottomNavigationBarItem(
                icon: new Icon(Icons.account_circle), label: "Account")
          ]),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      print(_currentIndex);
    });
  }
}
