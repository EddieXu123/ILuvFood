import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iluvfood/models/cart.dart';
import 'package:iluvfood/models/cart_item.dart';
import 'package:iluvfood/models/order.dart';
import 'package:iluvfood/screens/home/customer/order_summary.dart';
import 'package:iluvfood/services/database.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:toast/toast.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:table_calendar/table_calendar.dart';

String pickDay = "";
final _calendarController = CalendarController();

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
              orderDate: pickDay,
              status: "CONFIRMED"));
          Order order = await DatabaseService().getMostRecentOrder(user.uid);
          String message = content(cart);
          // String dateMessage = dayOfWeek(pick)
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
        'Order Confirmation from ${order.businessName}. OrderID: ${order.uid}' //${DateTime.now()}'
    ..text = 'This is the plain text.\nThis is line 2 of the text part.'
    ..html = "<div style=\"text-align: center;\"><h2>Thank you for using FoodRescue!</h2>\n<p>${order.businessName} has received your request" +
        " and will be packaging your order for pickup. Your order will be ready on $pickDay at 10:00 am."
            " Here is the list of items you ordered: <br> <br> $messageBody </div>";

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
        title: Text('Cart + Select Pickup Date'),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
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
        body: Column(children: [
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
                  width: 30,
                  child: FloatingActionButton(
                    heroTag: null,
                    elevation: 0,
                    backgroundColor: Color(0xFFe4b4ec),
                    child: Icon(Icons.delete),
                    onPressed: () {
                      cart.delete(cart.cartItems[index].uid);
                    },
                  ),
                ),
              ]),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Container(
                    width: 30,
                    child: FloatingActionButton(
                      heroTag: null,
                      elevation: 0,
                      backgroundColor: Color(0xFFe4b4ec),
                      child: Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        // itemPrice = "${cart.cartItems[index].price}";
                        cart.remove(cart.cartItems[index].uid);
                      },
                    )),
                Container(
                  width: 30.0,
                  child: Text(
                    "(${cart.cartItems[index].quantity})",
                    style: new TextStyle(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: 30,
                  child: FloatingActionButton(
                    heroTag: null,
                    elevation: 0,
                    child: Icon(Icons.add_circle_outline),
                    backgroundColor: Color(0xFFe4b4ec),
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
          child: TableCalendar(
            calendarStyle: CalendarStyle(
                canEventMarkersOverflow: true,
                todayColor: Colors.orange,
                selectedColor: Colors.blue[300],
                todayStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.white)),
            headerStyle: HeaderStyle(
              centerHeaderTitle: true,
              formatButtonDecoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(20.0),
              ),
              formatButtonTextStyle: TextStyle(color: Colors.white),
              formatButtonShowsNext: false,
            ),
            startingDayOfWeek: StartingDayOfWeek.monday,
            builders: CalendarBuilders(
              selectedDayBuilder: (context, date, events) {
                var isValidSelectedDay = true;
                DateTime now = new DateTime.now();

                var dayDiff = date.difference(now).inDays;
                if (dayDiff <= 0 ||
                    dayDiff > 14 ||
                    date.weekday == 6 ||
                    date.weekday == 7) {
                  print("chooose a valid date");
                  isValidSelectedDay = false;
                }

                if (isValidSelectedDay) {
                  pickDay = dayOfWeek(date.weekday) +
                      ', ' +
                      getMonth(date.month) +
                      ' ' +
                      date.day.toString() +
                      'th, ' +
                      date.year.toString();
                  return new Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.blue[300],
                          borderRadius: BorderRadius.circular(10.0)),
                      child: TextButton(
                        onPressed: () {
                          pickDay = date.day.toString();
                          (context as Element).markNeedsBuild();
                        },
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                        //
                      ));
                } else {
                  pickDay = '';
                  return new Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: TextButton(
                        onPressed: () {
                          pickDay = date.day.toString();
                          (context as Element).markNeedsBuild();
                        },
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                        //
                      ));
                }
              },
              todayDayBuilder: (context, date, events) => Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            calendarController: _calendarController,
          ),
        ),
      ),
    ]));
  }
}

String getMonth(int month) {
  switch (month) {
    case 1:
      return "January";
    case 2:
      return "February";
    case 3:
      return "March";
    case 4:
      return "April";
    case 5:
      return "May";
    case 6:
      return "June";
    case 7:
      return "July";
    case 8:
      return "August";
    case 9:
      return "September";
    case 10:
      return "October";
    case 11:
      return "November";
    case 12:
      return "December";
  }

  return "";
}

String dayOfWeek(int day) {
  switch (day) {
    case 1:
      return "Monday";
    case 2:
      return "Tuesday";
    case 3:
      return "Wednesday";
    case 4:
      return "Thursday";
    case 5:
      return "Friday";
    case 6:
      return "Saturday";
    case 7:
      return "Sunday";
  }

  return "";
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
                } else if (pickDay.length == 0) {
                  Toast.show(
                      "Pickup date must be a weekday within next 2 weeks",
                      context,
                      duration: 2,
                      gravity: Toast.BOTTOM);
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
