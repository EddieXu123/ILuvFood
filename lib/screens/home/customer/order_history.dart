import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iluvfood/models/customer.dart';
import 'package:iluvfood/models/order.dart';
import 'package:iluvfood/services/auth.dart';
import 'package:iluvfood/services/database.dart';
import 'package:iluvfood/shared/loading.dart';
import 'package:provider/provider.dart';

class OrderHistory extends StatefulWidget {
  final Customer customer;
  final AuthService auth;
  OrderHistory({this.customer, this.auth});

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    const Key centerKey = ValueKey<String>('bottom-sliver-list');
    return StreamBuilder<Customer>(
        stream: DatabaseService(uid: user.uid).customerData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // TODO set customer orders variable
            return Scaffold(
              resizeToAvoidBottomInset: false,
              key: _scaffoldKey,
              appBar: AppBar(
                title: Text("Order History"),
                centerTitle: true,
              ),
              body: StreamBuilder<List>(
                stream: DatabaseService(uid: user.uid).customerOrderUids,
                builder: (context, snapshot) {
                  print("snapshot" + snapshot.data.toString());
                  return CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildListDelegate([
                          // TODO - stream in a stream in a stream AHHH
                          for (String orderUid in snapshot.data)
                            StreamBuilder<Order>(
                              stream:
                                  DatabaseService(uid: orderUid).customerOrder,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  Order order = snapshot.data;
                                  return Card(
                                    child: ListTile(
                                      title:
                                          Text(order.orderId + " : " + order.dateTime.toString()),
                                      // TODO - display business name (must get form Uid)
                                    ),
                                  );
                                } else {
                                  return Loading();
                                }
                              },
                            ),
                        ]),
                      ),
                    ],
                  );
                },
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
