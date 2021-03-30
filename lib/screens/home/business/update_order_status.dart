import 'package:flutter/material.dart';
import 'package:iluvfood/models/order.dart';
import 'package:iluvfood/screens/home/customer/customer_page_style.dart';
import 'package:iluvfood/services/database.dart';
import 'package:iluvfood/shared/loading.dart';
import 'package:provider/provider.dart';

class UpdateOrderStatusPage extends StatefulWidget {
  Order order;
  UpdateOrderStatusPage(this.order);

  @override
  _UpdateOrderStatusPageState createState() => _UpdateOrderStatusPageState();
}

class _UpdateOrderStatusPageState extends State<UpdateOrderStatusPage> {
  @override
  Widget build(BuildContext context) {
    Order streamedOrder = widget.order;
    String status = streamedOrder == null ? "DELIVERED" : streamedOrder.status;
    bool isDelivered = status == "DELIVERED";
    bool isReady = (isDelivered || status == "READY");
    bool isPacking = (isReady || status == "PACKING");
    bool isConfirmed = (isPacking || status == "CONFIRMED");
    print(status);
    return streamedOrder == null
        ? Loading()
        : Scaffold(
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
                          statusWidget('confirmed', "Confirmed", isConfirmed,
                              streamedOrder.uid),
                          statusWidget('packing', "  Packing", isPacking,
                              streamedOrder.uid),
                          statusWidget(
                              'ready', "  Ready", isReady, streamedOrder.uid),
                          statusWidget('delivered', "Delivered", isDelivered,
                              streamedOrder.uid),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
  }

  Container statusWidget(String img, String status, bool isActive, String uid) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: GestureDetector(
        onTap: () {
          updateStatus(img.toUpperCase(), uid);
          setState(() {
            widget.order.status = img.toUpperCase();
          });
        },
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
      ),
    );
  }

  void updateStatus(String status, String uid) async {
    await DatabaseService().updateOrderStatus(uid, status);
  }
}
