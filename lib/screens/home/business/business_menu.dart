import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iluvfood/models/business.dart';
import 'package:iluvfood/models/business_item.dart';
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
            return StreamBuilder<List<BusinessItem>>(
                stream: DatabaseService().getBusinessItem(user.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<BusinessItem> businessItems = snapshot.data;
                    return new Scaffold(
                        key: _scaffoldKey,
                        appBar: AppBar(
                          title: Text('Listings'),
                          elevation: 0.0,
                          centerTitle: true,
                        ),
                        resizeToAvoidBottomInset: false,
                        body: Column(
                          children: [
                            Card(
                              child: ListTile(
                                leading: Icon(Icons.add),
                                title: Text('Add Items', style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17.0)),
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
                            SizedBox(
                              height: 600,
                              child: CustomScrollView(
                                slivers: [
                                  SliverList(
                                    delegate: SliverChildListDelegate([
                                      for (var i = businessItems.length - 1;
                                          i >= 0;
                                          i--)
                                        Card(
                                          elevation: 8.0,
                                          margin: new EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 6.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white24),
                                            child: ListTile(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 20.0,
                                                      vertical: 10.0),
                                              title: Text(businessItems[i].item,
                                                  style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17.0)),
                                              subtitle: Row(
                                                children: <Widget>[
                                                  Text(
                                                      "Quantity: ${businessItems[i].quantity}",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.grey[600],
                                                          fontSize: 17.0)),
                                                ],
                                              ),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.delete,
                                                      size: 25.0,
                                                    ),
                                                    onPressed: () {
                                                      DatabaseService().businessRemoveMenuItem(user.uid, businessItems[i].uid);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                    ]),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ));
                  } else {
                    return Loading();
                  }
                });
          } else
            return Loading();
        });
  }
}
