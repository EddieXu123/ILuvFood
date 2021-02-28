import 'package:firebase_auth/firebase_auth.dart';
import 'package:iluvfood/models/user.dart';
import 'package:iluvfood/services/account_database.dart';

/*
This class handles the firebase auth and creating docs of customers/business
in firestore.
*/
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based on FirebaseUser
  AuthUser _authUserFromFirebaseUser(FirebaseUser firebaseUser) {
    return firebaseUser != null ? AuthUser(uid: firebaseUser.uid) : null;
  }

  // auth change user stream (if user signs in or out)
  Stream<AuthUser> get authuser {
    // notify provider with new authuser object with auth state changes
    return _auth.onAuthStateChanged.map(_authUserFromFirebaseUser);
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

  Future customerSignInWithEmailandPassword(
      String email, String password) async {
    try {
      // check if email and password combo is valid
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _authUserFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // customer register with email and password
  Future customerRegisterWithEmailandPassword(
      String email, String password, String firstName, String lastName) async {
    try {
      // tell firebase_auth to create new customer creds
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      // create a new firestore document for the user
      await AccountDatabaseService(uid: user.uid)
          .updateCustomerUserData(firstName, lastName);
      return _authUserFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  // sign out
  Future customerSignOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
