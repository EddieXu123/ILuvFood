import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iluvfood/models/cart.dart';
import 'package:iluvfood/models/cart_item.dart';
import 'package:iluvfood/models/order.dart';
import 'package:iluvfood/screens/home/customer/order_summary.dart';
import 'package:iluvfood/services/database.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'customer_page_style.dart';
import 'package:toast/toast.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

showAlertDialog(BuildContext context) {
  CartModel cart = Provider.of<CartModel>(context, listen: false);
  var user = Provider.of<User>(context, listen: false);
  var uuid = Uuid();
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
        if (cart.cartItems.length == 0) {
          Toast.show("Your Cart is Empty!", context,
              duration: 2, gravity: Toast.CENTER);
        } else {
          await DatabaseService().initializePastOrder(Order(
              orderId: uuid.v1().substring(0, 8),
              dateTime: DateTime.now(),
              businessUid: cart.businessUid,
              customerUid: user.uid,
              businessName: cart.businessName,
              items: cart.cartItems,
              status: "CONFIRMED"));
          Order order = await DatabaseService().getMostRecentOrder(user.uid);
          String message = content(cart);
          await sendMail(user.email, user.displayName, order, message);
          Navigator.of(context).popUntil((route) => route.isFirst);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OrderSummary(order: order)));
          cart.reset();
        }

        cart.reset();
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

String content(CartModel cart) {
  String output = "";

  for (CartItem item in cart.cartItems) {
    output += (item.item + ' x' + item.quantity.toString() + '<br>');
  }

  return output;
}

sendMail(String emailAddress, String userName, Order order,
    String messageBody) async {
  String username = 'iluvfood64@gmail.com'; // EMAIL HERE
  String password = 'foodlover123'; // PASSWORD HERE

  final smtpServer = gmail(username, password);

  // Create our message.
  final message = Message()
    ..from = Address(username, 'ILuvFood')
    ..recipients.add(emailAddress)
    ..subject =
        'Order Confirmation from ${order.businessName}. Confirmation #: ${order.uid}' //${DateTime.now()}'
    ..text = 'This is the plain text.\nThis is line 2 of the text part.'
    ..html =
        "<div style=\"text-align: center;\"><h2>Thank you for using FoodRescuer!</h2>\n<p>${order.businessName} has received your request" +
            " and will be packaging your order for pickup. Here is the list of items you ordered: <br> <br> $messageBody </div>";

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
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
        height: 225,
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
                    timeWidget("10:00 AM to 12:00 PM", false),
                    timeWidget("12:00 PM to 02:00 PM", true),
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
                builder: (context, cart, child) => Text(
                    '\$${cart.priceInCart.toStringAsFixed(2)}',
                    style: hugeStyle)),
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

    return SizedBox(
      height: 50,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                if (cart.cartItems.length == 0) {
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
        TextButton(
          onPressed: () {
            print("Hello");
          },
          child: Text(
            day + '\n' + date,
            style: contentStyle.copyWith(
                color: (isActive) ? Colors.white : Colors.black, fontSize: 20),
          ),
        ),
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
        TextButton(
          onPressed: () {
            print("Pressed Button");
          },
          child: Text(
            time,
            style: contentStyle.copyWith(
                color: (isActive) ? Colors.white : Colors.black, fontSize: 15),
          ),
        )
      ],
    ),
  );
}
