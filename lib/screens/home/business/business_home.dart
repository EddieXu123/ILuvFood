import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iluvfood/models/business.dart';
import 'package:iluvfood/screens/home/business/business_add_menu.dart';
import 'package:iluvfood/screens/home/business/business_menu.dart';
import 'package:iluvfood/screens/home/business/business_profile.dart';
import 'package:iluvfood/services/database.dart';
import 'package:provider/provider.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<Business>(
        stream: DatabaseService(uid: user.uid).businessData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Business business = snapshot.data;
            return new Scaffold(
              appBar: AppBar(
                title: Text(
                    '${business.businessName ?? "<no name found>"} Portal'),
                elevation: 0.0,
              ),
              resizeToAvoidBottomInset: false,
              body: ListView(
                children: <Widget>[
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.add),
                      title: Text('Add/View Items'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BusinessAddMenu(),
                          ),
                        );
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.list),
                      title: Text('Current Orders'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BusinessMenu(),
                          ),
                        );
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.list),
                      title: Text('Order History'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BusinessProfile(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }
}
