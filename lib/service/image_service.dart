import 'package:cloud_firestore/cloud_firestore.dart';

class ImageFireStoreService {
  static FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  static Future addImage(
    String uid,
    String image,
  ) async {
    try {
      await _firebaseFirestore.collection("images").add({
        'uid': uid,
        'timestamp': Timestamp.now(),
        'image': image,
        'name': 'imageViwer',
        'email': 'image@viewr.2021'
      });
    } catch (e) {
      print(e);
    }
  }

  static Future deleteImage(String id) async {
    await _firebaseFirestore.collection('images').doc(id).delete();
  }
}
