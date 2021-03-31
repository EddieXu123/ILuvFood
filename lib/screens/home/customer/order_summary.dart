import 'package:flutter/material.dart';
import 'package:iluvfood/models/cart_item.dart';
import 'package:iluvfood/services/database.dart';
import 'package:iluvfood/shared/loading.dart';
import 'customer_page_style.dart';
import 'package:iluvfood/models/order.dart';
import 'package:provider/provider.dart';
import 'track_order.dart';

class OrderSummary extends StatefulWidget {
  final Order order;
  OrderSummary({this.order});

  @override
  _OrderSummaryState createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<CartItem>>.value(
        value: DatabaseService().getCartItems(widget.order.uid),
        child: LayoutWidget(
          order: widget.order,
        ));
  }
}

class LayoutWidget extends StatefulWidget {
  final Order order;
  LayoutWidget({this.order});

  @override
  _LayoutWidgetState createState() => _LayoutWidgetState();
}

class _LayoutWidgetState extends State<LayoutWidget> {
  @override
  Widget build(BuildContext context) {
    Order order = widget.order;
    final cartItemList = Provider.of<List<CartItem>>(context);
    var itemNameStyle = Theme.of(context).textTheme.headline6;
    return cartItemList == null
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.home, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text("Your Order is Complete!"),
              centerTitle: true,
            ),
            body: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      child: Image(
                          image: AssetImage("assets/images/onBoard2.png"))),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Thank you for choosing FoodRescue!",
                    style: headingStyle,
                  ),
                  Text(
                    "Your order has been placed and a confirmation email has been sent!",
                    style: contentStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Order ID",
                        style: headingStyle,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            gradient: gradientStyle,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Text(
                          order == null ? "<orderId>" : order.orderId,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Items Ordered",
                      style: headingStyle,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                      child: Column(
                        children: cartItemList
                            .map((i) => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      i.item,
                                      style: contentStyle.copyWith(
                                          color: Colors.black54, fontSize: 16),
                                    ),
                                    Text("Quantity: " + i.quantity.toString(),
                                        style: contentStyle.copyWith(
                                            color: Colors.black54,
                                            fontSize: 16))
                                  ],
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  divider(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pick up Date & Time",
                        style: headingStyle,
                      ),
                      Text(
                        "Your order will be ready to pick up at 10:00 am on ${order.orderDate}",
                        textAlign: TextAlign.center,
                        style: contentStyle.copyWith(
                            color: Colors.black54, fontSize: 16),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TrackOrderPage(order.uid)));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(gradient: gradientStyle),
                      child: Center(
                        child: Text(
                          "TRACK ORDER",
                          style: contentStyle.copyWith(
                              color: Colors.white, fontSize: 22),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}

Container divider() {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 15),
    height: 1,
    color: Colors.grey,
  );
}
