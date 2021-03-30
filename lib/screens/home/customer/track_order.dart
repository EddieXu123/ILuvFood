import 'package:flutter/material.dart';
import 'package:iluvfood/models/order.dart';
import 'package:iluvfood/services/database.dart';
import 'package:iluvfood/shared/loading.dart';
import 'customer_page_style.dart';

class TrackOrderPage extends StatelessWidget {
  final String uid;
  TrackOrderPage(this.uid);

  @override
  Widget build(BuildContext context) {
    print("UID: $uid");
    return StreamBuilder<Order>(
        stream: DatabaseService(uid: uid).orders,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Order streamedOrder = snapshot.data;
            String status = streamedOrder.status;
            bool isDelivered = status == "DELIVERED";
            bool isReady = (isDelivered || status == "READY");
            bool isPacking = (isReady || status == "PACKING");
            bool isConfirmed = (isPacking || status == "CONFIRMED");
            print("status: $status");

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
                                  statusWidget(
                                      'confirmed', "Confirmed", isConfirmed),
                                  statusWidget(
                                      'packing', "  Packing", isPacking),
                                  statusWidget('ready', "  Ready", isReady),
                                  statusWidget(
                                      'delivered', "Delivered", isDelivered),
                                ],
                              )
                            ],
                          ),
                        ])));
          } else {
            return Loading();
          }
        });
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
