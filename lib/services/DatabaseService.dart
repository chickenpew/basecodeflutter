import 'package:basecode/services/AuthService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  static CollectionReference users = FirebaseFirestore.instance.collection("users");

  static AuthService _authService = AuthService();

  // ignore: missing_return
  Future<UserCredential> registerUser(user) async {
    try {
      var checkEmail = await users.where("email", isEqualTo: user.email).get();

      if(checkEmail.docs.length > 0 ){
        return null;
      }

      UserCredential userCredential =
          await _authService.createUser(user.email, user.password);

      // PLacing in the DB
      await users.doc(userCredential.user.uid).set({
        "firstName": user.firstName,
        "lastName": user.lastName,
        "email": user.email,
      });

      return userCredential;
    }catch(e){
      return null;
    }
  }
}