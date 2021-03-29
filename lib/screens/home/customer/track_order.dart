import 'package:flutter/material.dart';
import 'customer_page_style.dart';
import 'package:flutter/material.dart';
import 'package:iluvfood/screens/home/customer/customer_home.dart';
import 'package:iluvfood/screens/home/customer/customer_profile.dart';
import 'package:iluvfood/screens/home/customer/customer_favorites_list.dart';
import 'package:iluvfood/shared/constants.dart';
import 'package:iluvfood/shared/errorPage.dart';

class TrackOrderPage extends StatelessWidget {
  final String status;
  TrackOrderPage(this.status);


  @override
  Widget build(BuildContext context) {
    bool isDelivered = status == "DELIVERED";
    bool isReady = (isDelivered || status == "READY");
    bool isPacking = (isReady || status == "PACKING");
    bool isConfirmed = (isPacking || status == "CONFIRMED");
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Status"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(110, 100, 50, 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(height: 400),
                Container(
                  margin: EdgeInsets.only(left: 13, top: 50),
                  width: 4,
                  height: 300,
                  color: Colors.grey,
                ),
                Column(
                  children: [
                    statusWidget('confirmed', "Confirmed", isConfirmed),
                    statusWidget('packing', "  Packing", isPacking),
                    statusWidget('ready', "  Ready", isReady),
                    statusWidget('delivered', "Delivered", isDelivered),
                  ],
                )
              ],
            ),]))
            // Container(
            //   height: 20,
            // ),
            // Container(
            //   margin: EdgeInsets.symmetric(vertical: 15),
            //   height: 1,
            //   color: Colors.grey,
            // ),
            // Container(
            //   height: 50,
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Container(
            //       padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            //       decoration: BoxDecoration(
            //           borderRadius: BorderRadius.all(Radius.circular(10)),
            //           border: Border.all(
            //             color: Colors.white,
            //           )),
            //       child: Text(
            //         "Cancel Order",
            //         style: contentStyle.copyWith(color: Colors.white),
            //       ),
            //     ),
                // Container(
                //   padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.all(Radius.circular(10)),
                //     color: Colors.orange,
                //   ),
                //   child: Text(
                //     "My Orders",
                //     style: contentStyle.copyWith(color: Colors.white),
                //   ),
                //),
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   selectedItemColor: Colors.orange,
      //   iconSize: 30,
      //   items: [
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.track_changes), title: Text("Track Order")),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       title: Text("Home"),
      //     ),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.view_list),
      //         title: Text("My Orders")), // OrderHistory()
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.track_changes),
      //       title: Text("Profile"),
      //     ),
      //   ],
      // ),
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
                width: 70,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/$img.png"),
                        fit: BoxFit.contain)),
              ),
              Text(
                status,
                style: contentStyle.copyWith(
                    color: (isActive) ? Colors.white : Colors.black),
              )
            ],
          )
        ],
      ),
    );
  }
}
