import 'package:flutter/material.dart';
import 'customer_page_style.dart';

// TODO: How do we track the most recent order
// to display? should pass in the order id into
// this widget
class TrackOrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Confirmed!"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order Number 1001",
              style: headingStyle,
            ),
            Text(
              "Order confirmed. Ready to pick",
              style: contentStyle.copyWith(color: Colors.grey, fontSize: 16),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              height: 1,
              color: Colors.grey,
            ),
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 13, top: 50),
                  width: 4,
                  height: 400,
                  color: Colors.grey,
                ),
                Column(
                  children: [
                    statusWidget('confirmed', "Confirmed", true),
                    statusWidget('onBoard2', "Picked Up", false),
                    statusWidget('servicesImg', "In Pricess", false),
                    statusWidget('shipped', "Shipped", false),
                    statusWidget('Delivery', "Delivered", false),
                  ],
                )
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              height: 1,
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                        color: Colors.orange,
                      )),
                  child: Text(
                    "Cancel Order",
                    style: contentStyle.copyWith(color: Colors.orange),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.orange,
                  ),
                  child: Text(
                    "My Orders",
                    style: contentStyle.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.orange,
        iconSize: 30,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.track_changes), title: Text("Track Order")),
          BottomNavigationBarItem(
              icon: Icon(Icons.view_list), title: Text("My Orders")),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes),
            title: Text("Profile"),
          ),
        ],
      ),
    );
  }

  Container statusWidget(String img, String status, bool isActive) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isActive) ? Colors.orange : Colors.white,
                border: Border.all(
                    color: (isActive) ? Colors.transparent : Colors.orange,
                    width: 3)),
          ),
          SizedBox(
            width: 50,
          ),
          Column(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/$img.png"),
                        fit: BoxFit.contain)),
              ),
              Text(
                status,
                style: contentStyle.copyWith(
                    color: (isActive) ? Colors.orange : Colors.black),
              )
            ],
          )
        ],
      ),
    );
  }
}
