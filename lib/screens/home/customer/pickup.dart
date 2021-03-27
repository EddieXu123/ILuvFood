import 'package:flutter/material.dart';
import 'customer_page_style.dart';
import 'checkout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iluvfood/models/cart.dart';
import 'package:iluvfood/models/order.dart';
import 'package:iluvfood/screens/home/customer/order_summary.dart';
import 'package:iluvfood/services/database.dart';
import 'package:provider/provider.dart';
import 'package:iluvfood/models/business.dart';
import 'pickup.dart';

import 'package:flutter/material.dart';
import 'customer_page_style.dart';

// TODO: How do we track the most recent order
// to display? should pass in the order id into
// this widget
class PickUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Date & Time"),
        centerTitle: true,
      ),
      body: Container(
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
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    dateWidget("Wed", "07 Aug", true),
                    dateWidget("Thu", "08 Aug", false),
                    dateWidget("Fri", "09 Aug", false),
                    dateWidget("Sat", "10 Aug", false),
                    dateWidget("Mon", "12 Aug", false),
                    dateWidget("Tue", "13 Aug", false)
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 1,
                color: Colors.grey,
              ),
              SizedBox(
                height: 15,
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
                    timeWidget("10:00 AM to 12:00 PM", false),
                    timeWidget("12:00 PM to 02:00 PM", true),
                    timeWidget("02:00 PM to 04:00 PM", false),
                    timeWidget("04:00 PM to 06:00 PM", false),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // Text(
              //   "Delivery Date",
              //   style: headingStyle,
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: [
              //       dateWidget("Wed", "10 Aug", true),
              //       dateWidget("Thu", "11 Aug", false),
              //       dateWidget("Fri", "12 Aug", false),
              //       dateWidget("Sat", "13 Aug", false),
              //       dateWidget("Mon", "14 Aug", false),
              //       dateWidget("Tue", "15 Aug", false)
              //     ],
              //   ),
              // ),
              // SizedBox(
              //   height: 15,
              // ),
              // Container(
              //   height: 1,
              //   color: Colors.grey,
              // ),
              // SizedBox(
              //   height: 15,
              // ),
              // Text(
              //   "Delivery Time",
              //   style: headingStyle,
              // ),
              // SizedBox(
              //   height: 15,
              // ),
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: [
              //       timeWidget("10:00 AM to 12:00 PM", false),
              //       timeWidget("12:00 PM to 02:00 PM", true),
              //       timeWidget("02:00 PM to 04:00 PM", false),
              //       timeWidget("04:00 PM to 06:00 PM", false),
              //     ],
              //   ),
              // ),
              // Expanded(
              //   child: Container(),
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       "Total Amount Payable",
              //       style: headingStyle,
              //     ),
              //     Text(
              //       "\$225",
              //       style: headingStyle,
              //     )
              //   ],
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // InkWell(
              //   onTap: () {
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => Checkout()));
              //   },
              //   child: Container(
              //     width: MediaQuery.of(context).size.width,
              //     padding: EdgeInsets.symmetric(vertical: 20),
              //     decoration: BoxDecoration(gradient: gradientStyle),
              //     child: Center(
              //       child: Text(
              //         "PLACE ORDER",
              //         style: contentStyle.copyWith(
              //             color: Colors.white, fontSize: 22),
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}

Container dateWidget(String day, String date, bool isActive) {
  return Container(
    margin: EdgeInsets.only(right: 10),
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
        color: (isActive) ? Colors.orange : Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.all(Radius.circular(20))),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          day,
          style: contentStyle.copyWith(
              color: (isActive) ? Colors.white : Colors.black, fontSize: 23),
        ),
        Text(
          date,
          style: contentStyle.copyWith(
              color: (isActive) ? Colors.white : Colors.black, fontSize: 18),
        )
      ],
    ),
  );
}

Container timeWidget(String time, bool isActive) {
  return Container(
    margin: EdgeInsets.only(right: 10),
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
        color: (isActive) ? Colors.orange : Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.all(Radius.circular(20))),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          time,
          style: contentStyle.copyWith(
            color: (isActive) ? Colors.white : Colors.black,
          ),
        ),
      ],
    ),
  );
}

// showAlertDialog(BuildContext context) {
//   CartModel cart = Provider.of<CartModel>(context, listen: false);
//   var user = Provider.of<User>(context, listen: false);
//   // set up the buttons
//   Widget cancelButton = FlatButton(
//     child: Text("Cancel"),
//     onPressed: () {
//       Navigator.pop(context);
//     },
//   );
//   Widget continueButton = FlatButton(
//     child: Text("Confirm"),
//     onPressed: () async {
//       print("processing order!");
//       try {
//         await DatabaseService().initializePastOrder(Order(
//             orderId: "orderId", // TODO - determine how to generate an orderId
//             dateTime: DateTime.now(),
//             businessUid: cart.businessUid,
//             customerUid: user.uid,
//             businessName: cart.businessName,
//             customerName: "customerName",
//             items: cart.cartItems));
//         // on add, take them to a summary page
//         // Navigator.pop(context);
//         Navigator.of(context).popUntil((route) => route.isFirst);

//         Navigator.push(
//             context, MaterialPageRoute(builder: (context) => OrderSummary()));
//       } catch (e) {
//         print("Error adding to order history: $e");
//       }
//     },
//   );
//   // set up the AlertDialog
//   AlertDialog alert = AlertDialog(
//     title: Text("Confirmation"),
//     content: Text("Ready to place your order?"),
//     actions: [
//       cancelButton,
//       continueButton,
//     ],
//   );
//   // show the dialog
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return alert;
//     },
//   );
// }
