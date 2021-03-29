import 'package:iluvfood/models/cart_item.dart';
import 'package:iluvfood/shared/enum.dart';

class Order {
  final String uid;
  final String orderId;
  final DateTime dateTime;
  final String businessUid;
  final String customerUid;
  final String businessName;
  final String orderDate;
  final List<CartItem> items;
  String status;
  Order(
      {this.uid,
      this.orderId,
      this.dateTime,
      this.businessUid,
      this.customerUid,
      this.businessName,
      this.orderDate,
      this.items,
      this.status});
}
