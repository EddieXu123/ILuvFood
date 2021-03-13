import 'package:flutter/material.dart';
import 'package:iluvfood/screens/home/customer/customer_home.dart';
import 'package:iluvfood/screens/home/customer/customer_profile.dart';
import 'package:iluvfood/shared/constants.dart';
import 'package:iluvfood/shared/errorPage.dart';

/// This is the stateful widget that the main application instantiates.
class CustomerHomeController extends StatefulWidget {
  @override
  _CustomerHomeControllerState createState() => _CustomerHomeControllerState();
}

/// This is the private State class that goes with CustomerHomeControllert.
class _CustomerHomeControllerState extends State<CustomerHomeController> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    // maps page
    CustomerHome(),

    // account page
    CustomerProfile(),

    // favorites page
    ErrorPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: MyColors.myPurple,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: MyColors.myPink,
        onTap: _onItemTapped,
      ),
    );
  }
}
