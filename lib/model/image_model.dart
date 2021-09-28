import 'package:cloud_firestore/cloud_firestore.dart';

class ImageModel {
  String? id;
  String? uid;
  Timestamp? timestamp;
  String? image;
  String? name;
  String? email;
  ImageModel(
      {this.id, this.uid, this.timestamp, this.image, this.email, this.name});

  factory ImageModel.fromJson(DocumentSnapshot snapshot) {
    return ImageModel(
        id: snapshot.id,
        uid: snapshot['uid'],
        image: snapshot['image'],
        timestamp: snapshot['timestamp'],
        email: snapshot['email'],
        name: snapshot['name']);
  }
}
