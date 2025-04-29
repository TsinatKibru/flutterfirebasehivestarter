import 'package:firebase_auth/firebase_auth.dart';
import 'package:stockpro/core/errors/exception.dart';

abstract class AuthRemoteDataSource {
  Future<void> signIn(String email, String password);
  Future<void> signUp(String email, String password);
  Future<void> signOut();
  Future<bool> isSignedIn();
  Future<String?> getUserId();
  Future<User?> getUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl(this.firebaseAuth);

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Authentication failed');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> signUp(String email, String password) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Authentication failed');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> isSignedIn() async {
    try {
      return firebaseAuth.currentUser != null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // @override
  // Future<bool> isSignedIn() async {
  //   try {
  //     final user = firebaseAuth.currentUser;
  //     if (user == null) {
  //       return false;
  //     }
  //     await user.reload(); // <-- Important: forces network call
  //     final refreshedUser = firebaseAuth.currentUser;
  //     return refreshedUser != null;
  //   } catch (e) {
  //     throw ServerException(e.toString());
  //   }
  // }

  @override
  Future<String?> getUserId() async {
    try {
      print("label: ${firebaseAuth.currentUser?.uid}");
      return firebaseAuth.currentUser?.uid;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<User?> getUser() async {
    try {
      print("currentUser: ${firebaseAuth.currentUser}");
      User? user = firebaseAuth.currentUser;
      return user;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
