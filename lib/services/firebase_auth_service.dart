
import 'package:firebase_auth/firebase_auth.dart';
import '../database/storage.dart';
import '../models/user_model.dart';

class FirebaseAuthService {

  final Storage storage = new Storage();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<UserModel> get authStateChanges => _firebaseAuth.authStateChanges().map(_userFromFirebaseUser);

  Future<dynamic> login({ String email, String password }) async{
    try{
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return _userFromFirebaseUser(result.user);
    } on FirebaseAuthException catch(error){
      return error.message;
    }
  }

  Future<dynamic> register({ String email, String password }) async{
    try{
      UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      storage.saveBool('verified', false);
      return _userFromFirebaseUser(result.user);
    } on FirebaseAuthException catch(error){
      return error.message;
    }
  }

  Future<dynamic> signInAnonymous() async{
    try{
      UserCredential result = await _firebaseAuth.signInAnonymously();
      return _userFromFirebaseUser(result.user);
    } on FirebaseAuthException catch(error){
      return error.message;
    }
  }

  Future<void> signOut() async{
    await _firebaseAuth.signOut();
  }

  UserModel _userFromFirebaseUser(user){
    return user != null ? UserModel(
      uID: user.uid,
    ) : null;
  }

}