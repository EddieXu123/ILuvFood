import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<void> enterBusinessItem(BusinessItem bizitem) {
    return businessItems.doc(uid).collection("items").add({
      "item": bizitem.item,
      "price": bizitem.price,
      "quantity": bizitem.quantity,
    });
  }

////////////////////////////////////////////////////////////////////////

  // get customer data from snapshot
  Customer _customerDataFromSnapshot(DocumentSnapshot snapshot) {
    try {
      return Customer(
          uid: uid, name: snapshot.data()['name'] ?? '<no name found>');
    } catch (e) {
      print('error returning customer data...');
      return Customer();
    }
  }

  // get customer data from snapshot
  Business _businessDataFromSnapshot(DocumentSnapshot snapshot) {
    final dat = snapshot.data();
    try {
      return Business(
        uid: uid,
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

  // // check if uid exists in customer db
  // bool isCustomer() {
  //   return customerAccountCollection.document(uid).get() == null ? false : true;
  // }

  Stream<Customer> get customerData {
    return userDetails.doc(uid).snapshots().map(_customerDataFromSnapshot);
  }

  Stream<Business> get businessData {
    return businessItems.doc(uid).snapshots().map(_businessDataFromSnapshot);
    return businessItems.doc(uid).snapshots().map(_businessDataFromSnapshot);
  }

  Stream<Role> get userRole {
    return userDetails.doc(uid).snapshots().map(_userRoleDataFromSnapshot);
  }
}
