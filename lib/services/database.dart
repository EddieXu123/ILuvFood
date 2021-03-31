import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iluvfood/models/business.dart';
import 'package:iluvfood/models/business_item.dart';
import 'package:iluvfood/models/cart_item.dart';
import 'package:iluvfood/models/customer.dart';
import 'package:iluvfood/models/order.dart';
import 'package:iluvfood/shared/enum.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  // customer account collection
  final CollectionReference userDetails =
      FirebaseFirestore.instance.collection('userdetails');

  final CollectionReference businessItems =
      FirebaseFirestore.instance.collection('businessitems');

  final CollectionReference pastOrders =
      FirebaseFirestore.instance.collection('pastOrders');

  Future<void> enterUserData(
      String name, Role role, String email, String phone) {
    return userDetails
        .doc(uid)
        .set({
          'name': name,
          'role': role.toShortString(),
          'email': email,
          'phone': phone
        })
        .then((value) => print("yay user added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> initializePastOrder(Order order) async {
    // create new collection (order1)
    var res = await pastOrders.add({
      'orderId': order.orderId,
      'dateTime': order.dateTime,
      'businessUid': order.businessUid,
      'customerUid': order.customerUid,
      'businessName': order.businessName,
      'orderDate': order.orderDate,
      'status': order.status
    });
    String orderUid = res.id;
    print("added");

    // create a cartitems subcollection within the order document
    // iterate through the cart items create a document for each item inside
    for (CartItem cartItem in order.items) {
      await pastOrders.doc(orderUid).collection("cartItems").add({
        "item": cartItem.item,
        "price": cartItem.price,
        "quantity": cartItem.quantity,
      });
    }

    // link orderuid to customer
    Map<String, dynamic> data;
    data = {
      'orderIds': FieldValue.arrayUnion([res.id])
    };
    await userDetails.doc(order.customerUid).update(data);
    print("order id linked to customer");

    // link orderuid to business
    await businessItems.doc(order.businessUid).update(data);
    print("order id linked to business");
  }

  Future<void> enterBusinessData(
      String name, String addressLine, String lat, String lng, String phone) {
    return businessItems.doc(uid).set({
      "address": addressLine,
      "image":
          "https://lh5.googleusercontent.com/p/AF1QipNCFpUBaUdjDYYBgtrT-HGY4sXRPSjYaIFCVwzW=w426-h240-k-no",
      "lat": lat,
      "lng": lng,
      "name": name,
      "phone": phone,
      "isOpen": false,
    });
  }

  Future<void> updateBusinessData(Business business) {
    return businessItems.doc(business.uid).update({
      "address": business.address,
      "lat": business.lat,
      "lng": business.lng,
      "name": business.businessName,
      "phone": business.phone
    });
  }

  Future<void> updateOrderStatus(String orderUid, String status) {
    return pastOrders.doc(orderUid).update({
      "status": status,
    });
  }

  static Future<void> updateCustomerData(
      String uid, String name, String phone) {
    final CollectionReference userDetails =
        FirebaseFirestore.instance.collection('userdetails');
    return userDetails.doc(uid).update({
      "name": name,
      "phone": phone,
    });
  }

  Future<List<Business>> getBusinesses(List businessesIDs) async {
    List<Business> businesses = [];
    for (var i = 0; i < businessesIDs.length; i++) {
      Business newBusiness = await readBusiness(businessesIDs[i]);
      if (newBusiness != null) {
        businesses.add(newBusiness);
      }
    }
    return businesses;
  }

  Future<void> enterBusinessItem(BusinessItem bizitem) async {
    // TODO: update flag if necessary
    await businessItems.doc(uid).update({
      "isOpen": true,
    });
    return businessItems.doc(uid).collection("items").add({
      "item": bizitem.item,
      "price": bizitem.price,
      "quantity": bizitem.quantity,
    });
  }

  BusinessItem _getBusinessItemFromSnapshot(DocumentSnapshot snapshot) {
    try {
      final dat = snapshot.data();
      return BusinessItem(
        uid: snapshot.id,
        item: dat["item"] ?? "<no item>",
        price: dat["price"] ?? "<no price>",
        quantity: dat["quantity"] ?? "0",
      );
    } catch (e) {
      print("error parsing item: $e");
      return BusinessItem();
    }
  }

  Future<Customer> readCustomer(String customerId) async {
    try {
      var snapshot = await userDetails.doc(customerId).get();
      return _customerDataFromSnapshot(snapshot);
    } catch (e) {
      print("error retrieving item from db: $e");
      return null;
    }
  }

  Future<Order> readOrder(String orderId) async {
    try {
      var snapshot = await pastOrders.doc(orderId).get();
      return _orderFromSnapshot(snapshot);
    } catch (e) {
      print("error retrieving item from db: $e");
      return null;
    }
  }

  Future<Order> getMostRecentOrder(String customerId) async {
    Customer customer = await readCustomer(customerId);
    List orderIds = customer.orderIds;
    String mostRecent = orderIds.last;
    return await readOrder(mostRecent);
  }

  Future<Business> readBusiness(String businessId) async {
    try {
      var snapshot = await businessItems.doc(businessId).get();
      return _businessDataFromSnapshot(snapshot);
    } catch (e) {
      print("error retrieving item from db: $e");
      return null;
    }
  }

  Future<BusinessItem> readBusinessItem(
      String businessId, String itemId) async {
    try {
      var snapshot = await businessItems
          .doc(businessId)
          .collection("items")
          .doc(itemId)
          .get();
      return _getBusinessItemFromSnapshot(snapshot);
    } catch (e) {
      print("error retrieving item from db: $e");
      return null;
    }
  }

  Future<bool> isBusinessOpen(String businessId) async {
    try {
      final int len = await businessItems
          .doc(businessId)
          .collection("items")
          .snapshots()
          .length;
      if (len > 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("could not verify business open/closed status: $e");
      return false;
    }
  }

////////////////////////////////////////////////////////////////////////
  List<BusinessItem> _itemsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final dat = doc.data();
      return BusinessItem(
        uid: doc.id,
        item: dat["item"],
        price: dat["price"],
        quantity: dat["quantity"],
      );
    }).toList();
  }

  List<CartItem> _cartItemsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final dat = doc.data();
      return CartItem(
          uid: doc.id,
          item: dat["item"],
          quantity: dat["quantity"],
          price: dat["price"]);
    }).toList();
  }

  Order _orderFromSnapshot(DocumentSnapshot snapshot) {
    try {
      print(snapshot.id);
      final dat = snapshot.data();
      return Order(
          uid: snapshot.id,
          orderId: dat['orderId'] ?? '<no orderId found>',
          dateTime: dat['dateTime'].toDate() ?? '<no dateTime found>',
          businessUid: dat['businessUid'] ?? '<no businessUid found>',
          customerUid: dat['customerUid'] ?? '<no customerUid found>',
          businessName: dat['businessName'] ?? '<no businessName found>',
          orderDate: dat['orderDate'] ?? '<no orderDate found>',
          status: dat['status'] ?? '<no status found>');
    } catch (e) {
      print(e);
      print('error returning order...');
      return Order();
    }
  }

  // get customer data from snapshot
  Customer _customerDataFromSnapshot(DocumentSnapshot snapshot) {
    try {
      final dat = snapshot.data();
      return Customer(
          uid: snapshot.id,
          name: dat['name'] ?? '<no name found>',
          email: dat['email'] ?? '<no email found>',
          phone: dat['phone'] ?? '<no phone found>',
          favorites: dat['favorites'] ?? [],
          orderIds: dat['orderIds'] ?? []);
    } catch (e) {
      print('error returning customer data...');
      return Customer();
    }
  }

  // Adds or removes a business from a user's list of favorites
  void customerUpdateFavorites(
      String customerUid, String businessUid, bool toAdd) async {
    try {
      Map<String, dynamic> data;
      if (toAdd) {
        data = {
          'favorites': FieldValue.arrayUnion([businessUid])
        };
      } else {
        data = {
          'favorites': FieldValue.arrayRemove([businessUid])
        };
      }
      await userDetails.doc(customerUid).update(data);
    } catch (e) {
      print("error retrieving item from db: $e");
      return null;
    }
  }

  // Removes an item from a business's menu
  void businessRemoveMenuItem(String businessUid, String menuItemUid) async {
    businessItems
        .doc(businessUid)
        .collection('items')
        .doc(menuItemUid)
        .delete();
  }

  // get business profile data from snapshot
  Business _businessDataFromSnapshot(DocumentSnapshot snapshot) {
    final dat = snapshot.data();
    try {
      return Business(
        uid: snapshot.id,
        address: dat["address"],
        image: dat["image"],
        lat: dat["lat"],
        lng: dat["lng"],
        businessName: dat["name"],
        phone: dat["phone"],
        orderIds: dat['orderIds'] ?? [],
        isOpen: dat["isOpen"] ?? false,
      );
    } catch (e) {
      // lmao be careful pls
      print("error getting business data from database: $e");
      return Business();
    }
  }

  // get user role
  Role _userRoleDataFromSnapshot(DocumentSnapshot snapshot) {
    try {
      switch (snapshot.data()['role'] ?? 'null') {
        case ('CUSTOMER'):
          return Role.CUSTOMER;
        case ('BUSINESS'):
          return Role.BUSINESS;
        default:
          print("lol role is messed up");
          return Role.UNDEFINED;
      }
    } catch (e) {
      print("error with user role: $e");
      return Role.UNDEFINED;
    }
  }

  // business list from snapshot
  List<Business> _businessListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final dat = doc.data();
      return Business(
        uid: doc.id,
        address: dat["address"],
        image: dat["image"],
        lat: dat["lat"],
        lng: dat["lng"],
        businessName: dat["name"],
        phone: dat["phone"],
        isOpen: dat["isOpen"] ?? false,
      );
    }).toList();
  }

  Stream<Customer> get customerData {
    return userDetails.doc(uid).snapshots().map(_customerDataFromSnapshot);
  }

  Stream<Business> get businessData {
    return businessItems.doc(uid).snapshots().map(_businessDataFromSnapshot);
  }

  Stream<Role> get userRole {
    return userDetails.doc(uid).snapshots().map(_userRoleDataFromSnapshot);
  }

  Stream<Order> get orders {
    return pastOrders.doc(uid).snapshots().map(_orderFromSnapshot);
  }

  Stream<List<CartItem>> getCartItems(String orderUid) {
    return pastOrders
        .doc(orderUid)
        .collection('cartItems')
        .snapshots()
        .map(_cartItemsFromSnapshot);
  }

  // get list of business stream
  Stream<List<Business>> get businesses {
    return businessItems.snapshots().map(_businessListFromSnapshot);
  }

  Stream<List<BusinessItem>> getBusinessItem(String businessId) {
    return businessItems
        .doc(businessId)
        .collection('items')
        .snapshots()
        .map(_itemsFromSnapshot);
  }

  Stream<Business> singleBusinessDataStream(String businessId) {
    return businessItems
        .doc(businessId)
        .snapshots()
        .map(_businessDataFromSnapshot);
  }
}
