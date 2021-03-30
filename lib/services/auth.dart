import 'package:firebase_auth/firebase_auth.dart';
import 'package:iluvfood/services/database.dart';
import 'package:iluvfood/shared/enum.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
      String email, String password, String name, String phone) async {
    // attempt to registe ruser
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    // add user document with customer information
    final uid = _auth.currentUser.uid;
    await DatabaseService(uid: uid)
        .enterUserData(name, Role.CUSTOMER, email, phone);
  }

  Future businessRegisterWithEmailandPassword(
      String email,
      String password,
      String businessName,
      String phone,
      String addressLine,
      String lat,
      String lng) async {
    // attempt to register ruser
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    // add user document with customer information
    final uid = _auth.currentUser.uid;
    await DatabaseService(uid: uid)
        .enterUserData(businessName, Role.BUSINESS, email, phone);
    await DatabaseService(uid: uid)
        .enterBusinessData(businessName, addressLine, lat, lng, phone);
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser =
        await GoogleSignIn().signIn().catchError((onError) {
      print("Error $onError");
      return null;
    });

    // Bug: clicking out of the google login portal triggers an uncatchable
    // exception. see: https://stackoverflow.com/a/62141551
    // Ignoring for now..

    if (googleUser == null) return null;

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    // add user document with customer information

    print("Google signing in...$userCredential");
    final uid = _auth.currentUser.uid;
    await DatabaseService(uid: uid).enterUserData(
        userCredential.user.displayName, Role.CUSTOMER, googleUser.email, null);

    return userCredential;
  }

  // sign out
  Future signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
}
