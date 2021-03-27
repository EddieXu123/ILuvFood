import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iluvfood/models/business.dart';
import 'package:iluvfood/models/order.dart';
import 'package:iluvfood/screens/home/business/business_order_details.dart';
import 'package:iluvfood/services/database.dart';
import 'package:iluvfood/shared/loading.dart';
import 'package:provider/provider.dart';

class BusinessOrderHistory extends StatefulWidget {
  BusinessOrderHistory();

  @override
  _BusinessOrderHistoryState createState() => _BusinessOrderHistoryState();
}

class _BusinessOrderHistoryState extends State<BusinessOrderHistory> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  Icon getStatus(Order order) {
    // TODO - change this to if the status is complete
    if (order.orderId == "orderId") {
      return Icon(Icons.check, color: Colors.purple[300], size: 30.0);
    }
    return Icon(Icons.sync, color: Colors.purple[300], size: 30.0);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    const Key centerKey = ValueKey<String>('bottom-sliver-list');
    return StreamBuilder<Business>(
        stream: DatabaseService(uid: user.uid).businessData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List businessOrders = snapshot.data.orderIds;
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
                        delegate: SliverChildListDelegate(
                          [
                            for (var i = businessOrders.length - 1; i >= 0; i--)
                              StreamBuilder<Order>(
                                stream: DatabaseService(uid: businessOrders[i])
                                    .orders,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    Order order = snapshot.data;
                                    DateTime dateTime = order.dateTime;
                                    return Card(
                                      elevation: 8.0,
                                      margin: new EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 6.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white24),
                                        child: ListTile(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 10.0),
                                          leading: Container(
                                            padding:
                                                EdgeInsets.only(right: 12.0),
                                            decoration: new BoxDecoration(
                                              border: new Border(
                                                right: new BorderSide(
                                                    width: 1.0,
                                                    color: Colors.purple[300]),
                                              ),
                                            ),
                                            child: getStatus(order),
                                          ),
                                          title: Text(
                                            order.businessName +
                                                " : " +
                                                dateTime.month.toString() +
                                                "-" +
                                                dateTime.day.toString() +
                                                "-" +
                                                dateTime.year.toString(),
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17.0),
                                          ),
                                          subtitle: Row(
                                            children: <Widget>[
                                              Text("Order Id: " + order.orderId,
                                                  style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 17.0))
                                            ],
                                          ),
                                          trailing: Icon(
                                              Icons.keyboard_arrow_right,
                                              color: Colors.purple[300],
                                              size: 30.0),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                    // TODO - could go to its own order details page with the reciept used for getting tax deduction
                                                        BusinessOrderDetails(
                                                            order: order)));
                                          },
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Loading();
                                  }
                                },
                              ),
                          ],
                        ),
                      ),
                    ],
                  ));
          } else {
            return Loading();
          }
        });
  }
}
