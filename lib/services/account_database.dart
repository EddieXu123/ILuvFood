import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iluvfood/models/customer.dart';

class AccountDatabaseService {
  final String uid;
  AccountDatabaseService({this.uid});
  // customer account collection
  final CollectionReference customerAccountCollection =
      Firestore.instance.collection('customerAccounts');

  Future updateCustomerUserData(String firstName, String lastName) async {
    return await customerAccountCollection.document(uid).setData({
      'firstName': firstName,
      'lastName': lastName,
    });
  }

  // get customer data from snapshot
  Customer _customerDataFromSnapshot(DocumentSnapshot snapshot) {
    return Customer(
        uid: uid,
        firstName: snapshot.data['firstName'],
        lastName: snapshot.data['lastName']);
  }

  Stream<Customer> get customerData {
    return customerAccountCollection
        .document(uid)
        .snapshots()
        .map(_customerDataFromSnapshot);
  }
}
