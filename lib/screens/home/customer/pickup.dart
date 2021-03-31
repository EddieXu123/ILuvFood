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
