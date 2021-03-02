import 'package:cloud_firestore/cloud_firestore.dart';
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
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

////////////////////////////////////////////////////////////////////////

  // get customer data from snapshot
  Customer _customerDataFromSnapshot(DocumentSnapshot snapshot) {
    return Customer(
        uid: uid, name: snapshot.data()['name'] ?? '<no name found>');
  }

  // // check if uid exists in customer db
  // bool isCustomer() {
  //   return customerAccountCollection.document(uid).get() == null ? false : true;
  // }

  Stream<Customer> get customerData {
    return userDetails.doc(uid).snapshots().map(_customerDataFromSnapshot);
  }
}
