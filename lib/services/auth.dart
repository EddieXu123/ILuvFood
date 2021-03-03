import 'package:firebase_auth/firebase_auth.dart';
import 'package:iluvfood/services/database.dart';
import 'package:iluvfood/shared/enum.dart';

/*
This class handles the firebase auth and creating docs of customers/business
in firestore.
*/
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User> get user {
    return _auth.authStateChanges();
  }

  // // sign in anon
  // Future signInAnon() async {
  //   try {
  //     AuthResult result = await _auth.signInAnonymously();
  //     FirebaseUser user = result.user;
  //     return _userFromFirebaseUser(user);
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  // sign in with email & password
  Future signInWithEmailandPassword(String email, String password) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future customerRegisterWithEmailandPassword(
      String email, String password, String name) async {
    // attempt to registe ruser
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    // add user document with customer information
    final uid = _auth.currentUser.uid;
    await DatabaseService(uid: uid).enterUserData(name, Role.CUSTOMER);
  }

  Future businessRegisterWithEmailandPassword(
      String email, String password, String businessName) async {
    // attempt to registe ruser
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    // add user document with customer information
    final uid = _auth.currentUser.uid;
    await DatabaseService(uid: uid).enterUserData(businessName, Role.BUSINESS);
    await DatabaseService(uid: uid).enterBusinessData(businessName);
  }

  // sign out
  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
