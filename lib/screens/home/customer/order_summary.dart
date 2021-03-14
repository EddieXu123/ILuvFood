import 'package:flutter/material.dart';

// TODO: How do we track the most recent order
// to display? Need to store the uid?
class OrderSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Confirmed!"),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Order Summary'),
      ),
    );
  }
}
