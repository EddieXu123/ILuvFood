import 'package:flutter/material.dart';

// TODO: How do we track the most recent order
// to display? should pass in the order id into
// this widget
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
