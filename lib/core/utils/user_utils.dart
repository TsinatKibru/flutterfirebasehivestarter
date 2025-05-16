import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Fetches the current user's companyId from Firestore.
Future<String?> getCurrentUserCompanyId() async {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    print('❌ No authenticated user found.');
    return null;
  }

  final uid = currentUser.uid;
  print('👤 Current Firebase UID: $uid');

  try {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (!userDoc.exists) {
      print('❌ No user document found for UID: $uid');
      return null;
    }

    final data = userDoc.data();
    final companyId = data?['companyId'] as String?;

    print('🏢 Retrieved companyId: $companyId');
    return companyId;
  } catch (e) {
    print('🔥 Error fetching companyId: $e');
    return null;
  }
}
