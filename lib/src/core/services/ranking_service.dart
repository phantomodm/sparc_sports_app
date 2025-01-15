import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sparc_sports_app/src/auth/auth_user.dart';

class RankingService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<UserRank>> getTopUsers(int limit) async {
    final snapshot = await _firestore
        .collection('userRanks')
        .orderBy('points', descending: true)
        .limit(limit)
        .get();
    return snapshot.docs.map((doc) => UserRank.fromMap(doc.data())).toList();
  }

  Future<UserRank> getUserRank(String userId) async {
    final doc = await _firestore.collection('userRanks').doc(userId).get();
    return UserRank.fromMap(doc.data()!);
  }

}