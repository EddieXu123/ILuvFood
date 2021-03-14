import 'package:iluvfood/models/cart_item.dart';

class Order {
  String orderId;
  DateTime dateTime;
  String businessUid;
  String customerUid;
  // String businessName;
  // String customerName;
  List<CartItem> items;
  Order(
      {this.orderId,
      this.dateTime,
      this.businessUid,
      this.customerUid,
      this.items});
}
