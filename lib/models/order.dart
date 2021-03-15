import 'package:iluvfood/models/cart_item.dart';

class Order {
  final String uid;
  final String orderId;
  final DateTime dateTime;
  final String businessUid;
  final String customerUid;
  // String businessName;
  // String customerName;
  final List<CartItem> items;
  Order(
      {this.uid, 
      this.orderId,
      this.dateTime,
      this.businessUid,
      this.customerUid,
      this.items});
}
