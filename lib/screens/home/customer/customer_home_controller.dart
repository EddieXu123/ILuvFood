import 'package:flutter/material.dart';
import 'package:iluvfood/screens/home/customer/customer_favorites.dart';
import 'package:iluvfood/screens/home/customer/customer_home.dart';
import 'package:iluvfood/screens/home/customer/customer_profile.dart';

/// This is the stateful widget that the main application instantiates.
class CustomerHomeController extends StatefulWidget {
  final List<Widget> screens = <Widget>[
    // maps page
    CustomerHome(),

    //favorites page
    CustomerFavorites(),

    // account page
    CustomerProfile(),

    // ErrorPage(),
  ];
  @override
  _CustomerHomeControllerState createState() => _CustomerHomeControllerState();
}

/// This is the private State class that goes with CustomerHomeControllert.
class _CustomerHomeControllerState extends State<CustomerHomeController> {
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
                icon: Icon(Icons.favorite), label: 'Favorites'),
            BottomNavigationBarItem(
                icon: new Icon(Icons.account_circle), label: "Account")
          ]),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      print(index);
    });
  }
}
