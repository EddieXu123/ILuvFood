import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iluvfood/models/business.dart';
import 'package:iluvfood/services/database.dart';
import 'package:iluvfood/shared/loading.dart';
import 'package:provider/provider.dart';
import 'business_menu_add.dart';

class BusinessMenu extends StatefulWidget {
  @override
  _BusinessMenuState createState() => _BusinessMenuState();
}

class _BusinessMenuState extends State<BusinessMenu> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                appBar: AppBar(
                  title: Text(
                      '${business.businessName ?? "<no name found>"} Portal'),
                  elevation: 0.0,
                ),
                resizeToAvoidBottomInset: false,
                body: Card(
                  child: ListTile(
                    leading: Icon(Icons.add),
                    title: Text('Add Items'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BusinessAddMenu(),
                        ),
                      );
                    },
                  ),
                ));
          } else
            return Loading();
        });
  }
}
