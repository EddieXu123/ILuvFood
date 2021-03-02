import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iluvfood/models/business.dart';
import 'package:iluvfood/models/customer.dart';
import 'package:iluvfood/shared/enum.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  // customer account collection
  final CollectionReference userDetails =
      FirebaseFirestore.instance.collection('userdetails');

  Future<void> enterUserData(String name, Role role) {
    return userDetails
        .doc(uid)
        .set({'name': name, 'role': role.toShortString()})
        .then((value) => print("yay user added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

////////////////////////////////////////////////////////////////////////

  // get customer data from snapshot
  Customer _customerDataFromSnapshot(DocumentSnapshot snapshot) {
    return Customer(
        uid: uid, name: snapshot.data()['name'] ?? '<no name found>');
  }

  // get customer data from snapshot
  Business _businessDataFromSnapshot(DocumentSnapshot snapshot) {
    return Business(
        uid: uid, restaurantName: snapshot.data()['name'] ?? '<no name found>');
  }

  // get user role
  Role _userRoleDataFromSnapshot(DocumentSnapshot snapshot) {
    switch (snapshot.data()['role'] ?? 'null') {
      case ('CUSTOMER'):
        return Role.CUSTOMER;
      case ('BUSINESS'):
        return Role.BUSINESS;
      default:
        print("Role is messed up");
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
    return userDetails.doc(uid).snapshots().map(_businessDataFromSnapshot);
  }

  Stream<Role> get userRole {
    return userDetails.doc(uid).snapshots().map(_userRoleDataFromSnapshot);
  }
}
