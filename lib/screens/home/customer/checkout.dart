import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iluvfood/models/cart.dart';
import 'package:iluvfood/models/order.dart';
import 'package:iluvfood/screens/home/customer/order_summary.dart';
import 'package:iluvfood/services/database.dart';
import 'package:provider/provider.dart';
import 'package:iluvfood/models/business.dart';
import 'package:toast/toast.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

// TODO: Add Restaurant information under the Cart

showAlertDialog(BuildContext context) {
  // CartModel cart = context.watch<CartModel>();
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
        await DatabaseService().initializePastOrder(Order(
            orderId: "orderId",
            dateTime: DateTime.now(),
            businessUid: cart.businessUid,
            customerUid: user.uid,
            items: cart.cartItems));
        // on add, take them to a summary page
        // Navigator.pop(context);
        Navigator.of(context).popUntil((route) => route.isFirst);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => OrderSummary()));
        sendMail();
        Toast.show("Order Placed! Check your inbox for your receipt!", context,
            duration: 3, gravity: Toast.CENTER);
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

sendMail() async {
  String username = 'email'; // EMAIL HERE
  String password = 'test'; // PASSWORD HERE

  final smtpServer = gmail(username, password);
  // Use the SmtpServer class to configure an SMTP server:
  // final smtpServer = SmtpServer('smtp.domain.com');
  // See the named arguments of SmtpServer for further configuration
  // options.

  // Create our message.
  final message = Message()
    ..from = Address(username, 'Your name')
    ..recipients.add('xutopiajohnson@gmail.com') // Customer email here
    // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
    // ..bccRecipients.add(Address('bccAddress@example.com'))
    ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
    ..text = 'This is the plain text.\nThis is line 2 of the text part.'
    ..html =
        "<h1>Your order has been placed</h1>\n<p>Hey! Here's some HTML content</p>";

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
    // This gets the current state of CartModel and also tells Flutter
    // to rebuild this widget when CartModel notifies listeners (in other words,
    // when it changes).
    // var cart = context.watch<CartModel>();
    CartModel cart = context.watch<CartModel>();
    return new Scaffold(
      body: ListView.builder(
        itemCount: cart.cartItems.length,
        itemBuilder: (context, index) => ListTile(
          leading: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                cart.delete(cart.cartItems[index].uid);
              },
            ),
          ]),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
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
    );
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
                print("processing order!");
                showAlertDialog(context);
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
