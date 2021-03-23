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
import 'package:toast/toast.dart';

// TODO: Add Restaurant information under the Cart

showAlertDialog(BuildContext context) {
  CartModel cart = Provider.of<CartModel>(context, listen: false);
  var user = Provider.of<User>(context, listen: false);
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Confirm"),
    onPressed: () async {
      print("processing order!");
      try {
        if (cart.priceInCart == 0) {
          Toast.show("Your Cart is Empty!", context,
              duration: 2, gravity: Toast.CENTER);
        } else {
          await DatabaseService().initializePastOrder(Order(
              orderId: "orderId", // TODO - determine how to generate an orderId
              dateTime: DateTime.now(),
              businessUid: cart.businessUid,
              customerUid: user.uid,
              businessName: cart.businessName,
              customerName: "customerName",
              items: cart.cartItems));
          // on add, take them to a summary page
          // Navigator.pop(context);
          Navigator.of(context).popUntil((route) => route.isFirst);

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => OrderSummary()));
          print("Resetting After Purchase");
          cart.reset();
        }
      } catch (e) {
        print("Error adding to order history: $e");
      }
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Confirmation"),
    content: Text("Ready to place your order?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class Checkout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: _CartList(),
              ),
            ),
            Divider(height: 4, color: Colors.black),
            _CartTotal(),
            _PurchaseNow()
          ],
        ),
      ),
    );
  }
}

class _CartList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var itemNameStyle = Theme.of(context).textTheme.headline6;
    bool selected_date = false;
    bool selected_time = false;
    // This gets the current state of CartModel and also tells Flutter
    // to rebuild this widget when CartModel notifies listeners (in other words,
    // when it changes).
    // var cart = context.watch<CartModel>();
    CartModel cart = context.watch<CartModel>();
    // var itemPrice = "-1";
    return new Scaffold(
        body: Column(children: <Widget>[
      Container(
        height: 250,
        child: Container(
          height: 250,
          child: ListView.builder(
            itemCount: cart.cartItems.length,
            itemBuilder: (context, index) => ListTile(
              leading:
                  Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Container(
                  width: 15,
                  child: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      cart.delete(cart.cartItems[index].uid);
                    },
                  ),
                ),
              ]),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                IconButton(
                  icon: Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    // itemPrice = "${cart.cartItems[index].price}";
                    cart.remove(cart.cartItems[index].uid);
                    // print(itemPrice);
                  },
                ),
                Container(
                  width: 30.0,
                  child: Text(
                    "(${cart.cartItems[index].quantity})",
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: 20,
                  child: IconButton(
                    icon: Icon(Icons.add_circle_outline),
                    onPressed: () {
                      cart.add(cart.cartItems[index].uid);
                    },
                  ),
                ),
              ]),
              title: Text(
                // itemPrice == "-1"
                "${cart.cartItems[index].item}", // LATER: (\$${cart.cartItems[index].price})",
                // : "${cart.cartItems[index].item} ($itemPrice)", //(${cart.cartItems[index].quantity})",
                style: itemNameStyle,
              ),
            ),
          ),
        ),
      ),
      Container(
        height: 1,
        color: Colors.grey,
      ),
      Container(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Pick up Date",
                style: headingStyle,
              ),
              SizedBox(
                height: 15,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // TODO: Make them into buttons and use This.Date + 3 days
                    // Need to talk with team to decide how long actually
                    dateWidget("Wed", "24 March", true), // ThisDate + 3
                    dateWidget("Thu", "25 March", false), // ThisDate + 4
                    dateWidget("Fri", "26 March", false), // etc
                    dateWidget("Sat", "27 March", false),
                    dateWidget("Mon", "28 March", false),
                    dateWidget("Tue", "29 March", false)
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 1,
                color: Colors.grey,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Pick up Time",
                style: headingStyle,
              ),
              SizedBox(
                height: 15,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // DITTO THE ABOVE
                    TextButton(
                      onPressed: () {
                        selected_time = true;
                      },
                      child: timeWidget("10:00 AM to 12:00 PM", selected_time),
                    ),
                    InkWell(
                      onTap: () {},
                      child: timeWidget("12:00 PM to 02:00 PM", true),
                    ),
                    timeWidget("02:00 PM to 04:00 PM", false),
                    timeWidget("04:00 PM to 06:00 PM", false),
                  ],
                ),
              ),
              // SizedBox(
              //   height: 20,
              // ),
            ],
          ),
        ),
      ),
    ]));
  }
}

class _CartTotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // CartModel cart = context.watch<CartModel>();
    var hugeStyle =
        Theme.of(context).textTheme.headline1.copyWith(fontSize: 48);

    return SizedBox(
      height: 50,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<CartModel>(
                builder: (context, cart, child) =>
                    Text('\$${cart.priceInCart}', style: hugeStyle)),
            SizedBox(width: 24),
          ],
        ),
      ),
    );
  }
}

class _PurchaseNow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CartModel cart = Provider.of<CartModel>(context, listen: false);
    var user = Provider.of<User>(context, listen: false);
    return SizedBox(
      height: 50,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                if (cart.priceInCart == 0) {
                  Toast.show("Your Cart is Empty!", context,
                      duration: 2, gravity: Toast.CENTER);
                } else {
                  print("processing order!");
                  showAlertDialog(context);
                }
              },
              child: Text(
                'Place Order',
                style: TextStyle(fontSize: 25),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Container dateWidget(String day, String date, bool isActive) {
  return Container(
    margin: EdgeInsets.only(right: 10),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
        color: (isActive) ? Colors.orange : Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.all(Radius.circular(20))),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          day,
          style: contentStyle.copyWith(
              color: (isActive) ? Colors.white : Colors.black, fontSize: 20),
        ),
        Text(
          date,
          style: contentStyle.copyWith(
              color: (isActive) ? Colors.white : Colors.black, fontSize: 13),
        )
      ],
    ),
  );
}

Container timeWidget(String time, bool isActive) {
  return Container(
    margin: EdgeInsets.only(right: 10),
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
        color: (isActive) ? Colors.orange : Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.all(Radius.circular(20))),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          time,
          style: contentStyle.copyWith(
              color: (isActive) ? Colors.white : Colors.black, fontSize: 15),
        ),
      ],
    ),
  );
}
