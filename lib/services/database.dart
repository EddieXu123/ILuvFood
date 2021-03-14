import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iluvfood/models/business.dart';
import 'package:iluvfood/models/business_item.dart';
import 'package:iluvfood/models/customer.dart';
import 'package:iluvfood/shared/enum.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  // customer account collection
  final CollectionReference userDetails =
      FirebaseFirestore.instance.collection('userdetails');

  final CollectionReference businessItems =
      FirebaseFirestore.instance.collection('businessitems');

  Future<void> enterUserData(String name, Role role) {
    return userDetails
        .doc(uid)
        .set({'name': name, 'role': role.toShortString()})
        .then((value) => print("yay user added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> enterBusinessData(String name) {
    return businessItems.doc(uid).set({
      "address": "12200 Mayfield Rd \nCleveland, OH 44106",
      "image":
          "https://lh5.googleusercontent.com/p/AF1QipNCFpUBaUdjDYYBgtrT-HGY4sXRPSjYaIFCVwzW=w426-h240-k-no",
      "lat": "41.50869",
      "lng": "-81.59784",
      "name": name,
      "phone": "+1 216-795-2355"
    });
    // .then((value) => print("yay user added"))
    // .catchError((error) => print("Failed to add user: $error"));
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

  Future<void> enterBusinessItem(BusinessItem bizitem) {
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
        item: dat["item"],
        price: dat["price"],
        quantity: dat["quantity"],
      );
    } catch (e) {
      print("error parsing item: $e");
      return BusinessItem();
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

  // get customer data from snapshot
  Customer _customerDataFromSnapshot(DocumentSnapshot snapshot) {
    try {
      print(snapshot.id);
      return Customer(
        uid: snapshot.id,
        name: snapshot.data()['name'] ?? '<no name found>',
        favorites: snapshot.data()['favorites'] ?? [],
      );
    } catch (e) {
      print('error returning customer data...');
      return Customer();
    }
  }

/*
  Future<List> readCustomerFavorites(String customerUid) async {
    try {
      DocumentSnapshot snapshot = await userDetails.doc(customerUid).get();
      List favorites = snapshot.get('favorites');

      return favorites;
    } catch (e) {
      print("error retrieving item from db: $e");
      return null;
    }
  }
  */

  void customerUpdateFavorites(
      Customer customer, String businessUid, bool toAdd) async {
    try {
      //List favorites = customer.favorites;
      Map<String, dynamic> data;
      if (toAdd) {
        //favorites.add(businessUid);
        data = {
          'favorites': FieldValue.arrayUnion([businessUid])
        };
      } else {
        //favorites.remove(businessUid);
        data = {
          'favorites': FieldValue.arrayRemove([businessUid])
        };
      }
      await userDetails.doc(customer.uid).update(data);
    } catch (e) {
      print("error retrieving item from db: $e");
      return null;
    }
  }

/*
  void customerUpdateFavorites(
      String customerUid, List<String> favorites) async {
    try {
      Map<String, List<String>> data = {'favorites': favorites};
      await userDetails.doc(customerUid).update(data);
    } catch (e) {
      print("error retrieving item from db: $e");
      return null;
    }
  }
*/

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
      );
    }).toList();
  }

  // // check if uid exists in customer db
  // bool isCustomer() {
  //   return customerAccountCollection.document(uid).get() == null ? false : true;
  // }

  Stream<Customer> get customerData {
    return userDetails.doc(uid).snapshots().map(_customerDataFromSnapshot);
  }

  Stream<Business> get businessData {
    return businessItems.doc(uid).snapshots().map(_businessDataFromSnapshot);
  }

  Stream<Role> get userRole {
    return userDetails.doc(uid).snapshots().map(_userRoleDataFromSnapshot);
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
