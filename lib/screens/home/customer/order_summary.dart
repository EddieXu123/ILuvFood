import 'package:flutter/material.dart';
import 'customer_page_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iluvfood/models/cart.dart';
import 'package:iluvfood/models/order.dart';
import 'package:iluvfood/screens/home/customer/order_summary.dart';
import 'package:iluvfood/services/database.dart';
import 'package:provider/provider.dart';
import 'package:iluvfood/models/business.dart';
import 'pickup.dart';
import 'customer_page_style.dart';
import 'track_order.dart';

// TODO: How do we track the most recent order
// to display? should pass in the order id into
// this widget
class OrderSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CartModel cart = context.watch<CartModel>();
    var itemNameStyle = Theme.of(context).textTheme.headline6;

    return Scaffold(
      appBar: AppBar(
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
                child: Image(image: AssetImage("assets/images/onBoard2.png"))
                // decoration: BoxDecoration(
                //     image: DecorationImage(
                //         image: AssetImage('assets/images/onBoard2.png'))),
                ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Thank you for choosing ILuvFood!",
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
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Text(
                    "<OrderIDHere>",
                    style: headingStyle.copyWith(color: Colors.white),
                  ),
                )
              ],
            ),
            divider(),
            // ListView.builder(
            //   itemCount: cart.cartItems.length,
            //   itemBuilder: (context, index) => ListTile(
            //     leading:
            //         Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            //       IconButton(
            //         icon: Icon(Icons.delete),
            //         onPressed: () {
            //           cart.delete(cart.cartItems[index].uid);
            //         },
            //       ),
            //     ]),
            //     trailing:
            //         Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
            //       IconButton(
            //         icon: Icon(Icons.remove_circle_outline),
            //         onPressed: () {
            //           cart.remove(cart.cartItems[index].uid);
            //         },
            //       ),
            //       IconButton(
            //         icon: Icon(Icons.add_circle_outline),
            //         onPressed: () {
            //           cart.add(cart.cartItems[index].uid);
            //         },
            //       ),
            //     ]),
            //     title: Text(
            //       "${cart.cartItems[index].item} (${cart.cartItems[index].quantity})",
            //       style: itemNameStyle,
            //     ),
            //   ),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order Information",
                  style: headingStyle,
                ),
                Text(
                  "He",
                  style: headingStyle.copyWith(color: Colors.grey),
                ),
                ListView.builder(
                  itemCount: cart.cartItems.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              cart.delete(cart.cartItems[index].uid);
                            },
                          ),
                        ]),
                    trailing:
                        Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          cart.remove(cart.cartItems[index].uid);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline),
                        onPressed: () {
                          cart.add(cart.cartItems[index].uid);
                        },
                      ),
                    ]),
                    title: Text(
                      "${cart.cartItems[index].item} (${cart.cartItems[index].quantity})",
                      style: itemNameStyle,
                    ),
                  ),
                ),
              ],
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
                  "Wednesday, 07 Aug, 2020. Between 10:00 AM & 12:00 PM",
                  style:
                      contentStyle.copyWith(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
            Expanded(
              child: Container(),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TrackOrderPage()));
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
