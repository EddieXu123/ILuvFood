import 'package:flutter/material.dart';
import 'package:iluvfood/models/cart_item.dart';
import 'package:iluvfood/models/order.dart';
import 'package:iluvfood/services/database.dart';
import 'package:iluvfood/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class OrderDetails extends StatefulWidget {
  final Order order;
  OrderDetails({this.order});

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<CartItem>>.value(
        value: DatabaseService().getCartItems(widget.order.uid),
        child: LayoutWidget(order: widget.order));
  }
}

class LayoutWidget extends StatefulWidget {
  final Order order;
  LayoutWidget({this.order});

  @override
  _LayoutWidgetState createState() => _LayoutWidgetState();
}

class _LayoutWidgetState extends State<LayoutWidget> {
  DateFormat dateFormat;
  DateFormat timeFormat;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    dateFormat = new DateFormat.yMMMMd('en_US');
    timeFormat = DateFormat.jm();
  }

  @override
  Widget build(BuildContext context) {
    Order order = widget.order;
    final cartItemList = Provider.of<List<CartItem>>(context);
    return cartItemList == null
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text("Order " + order.orderId),
              centerTitle: true,
            ),
            body: Column(
              children: <Widget>[
                SizedBox(height: 40),
                Container(
                    child: Text(order.businessName,
                        style: TextStyle(fontSize: 20))),
                SizedBox(height: 20),
                Container(
                    child: Text(
                        dateFormat.format(order.dateTime) +
                            " " +
                            timeFormat.format(order.dateTime),
                        style: TextStyle(fontSize: 20))),
                SizedBox(height: 20),
                SizedBox(
                  height: 500,
                  child: CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildListDelegate([
                          for (CartItem item in cartItemList)
                            Card(
                                child: ListTile(
                              title: Text(item.item),
                              subtitle: Text("Quantity: " +
                                  item.quantity.toString() +
                                  "          Price: \$" +
                                  item.price.toString()),
                            )),
                        ]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
