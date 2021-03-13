import 'package:iluvfood/models/cart_item.dart';

class Order {
  String orderId;
  DateTime dateTime;
  String businessName;
  List<CartItem> items;
}
