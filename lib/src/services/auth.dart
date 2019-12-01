import 'package:firebase_auth/firebase_auth.dart';
import 'package:jackshub/src/models/user.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
 
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged
      .map(_userFromFirebaseUser);
  }
 
  // Sign in anonymously
  Future signInAnonymously() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
  

  // sign in with email & password
    Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // register with email link
  Future registerWithEmailLink(String email) async {    
    try {
      return await _auth.sendSignInWithEmailLink(
        email: email,
        url: 'https://devstate.page.link/sign-in-after-confirmation',
        handleCodeInApp: true,
        iOSBundleID: 'com.example.jackshub',
        androidPackageName: 'com.example.jackshub',
        androidInstallIfNotAvailable: false,
        androidMinimumVersion: '12',
        );
    } catch(e) {
      print(e.toString());
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}  
