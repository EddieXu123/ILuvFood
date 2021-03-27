import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iluvfood/models/business.dart';
import 'package:iluvfood/services/database.dart';
import 'package:iluvfood/shared/loading.dart';
import 'package:provider/provider.dart';

class BusinessOrderHistory extends StatefulWidget {
  @override
  _BusinessOrderHistoryState createState() => _BusinessOrderHistoryState();
}

class _BusinessOrderHistoryState extends State<BusinessOrderHistory> {
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
                  child: Text('Orders'),
                ));
          } else
            return Loading();
        });
  }
}
