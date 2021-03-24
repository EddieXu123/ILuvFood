import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iluvfood/models/customer.dart';
import 'package:iluvfood/models/order.dart';
import 'package:iluvfood/screens/home/customer/order_details.dart';
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
            List customerOrders = snapshot.data.orderIds;
            return Scaffold(
                resizeToAvoidBottomInset: false,
                key: _scaffoldKey,
                appBar: AppBar(
                  title: Text("Order History"),
                  centerTitle: true,
                ),
                body: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate([
                        for (var i = customerOrders.length - 1; i >= 0; i--)
                          StreamBuilder<Order>(
                            stream:
                                DatabaseService(uid: customerOrders[i]).customerOrder,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                Order order = snapshot.data;
                                DateTime dateTime = order.dateTime;
                                return Card(
                                  child: ListTile(
                                      title: Text(order.businessName +
                                          " : " +
                                          dateTime.month.toString() +
                                          "-" +
                                          dateTime.day.toString() +
                                          "-" +
                                          dateTime.year.toString()),
                                      subtitle: Text(order.orderId),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    OrderDetails(
                                                        order: order)));
                                      }),
                                );
                              } else {
                                return Loading();
                              }
                            },
                          ),
                      ]),
                    ),
                  ],
                ));
          } else {
            return Loading();
          }
        });
  }
}
