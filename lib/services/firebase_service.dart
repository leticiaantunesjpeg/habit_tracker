import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createHabit(Map<String, dynamic> habitData) async {
    try {
      await _firestore.collection('habits').add(habitData);
    } catch (e) {
      throw Exception('Failed to create habit: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getHabits() async {
    try {
      final querySnapshot = await _firestore.collection('habits').get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          ...data,
          'id': doc.id,
        };
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch habits: $e');
    }
  }

  Future<void> updateHabit(String id, Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection('habits').doc(id).update(updatedData);
    } catch (e) {
      throw Exception('Failed to update habit: $e');
    }
  }

  Future<void> deleteHabit(String id) async {
    try {
      await _firestore.collection('habits').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete habit: $e');
    }
  }
}
