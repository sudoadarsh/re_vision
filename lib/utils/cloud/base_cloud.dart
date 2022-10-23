import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class BaseCloud {
  // Initialise the cloud firestore.
  static FirebaseFirestore? _db;

  /// Ensure this [BaseCloud.init] is called before using any of its methods.
  static FirebaseFirestore? init() {
    _db = FirebaseFirestore.instance;
    return _db;
  }

  /// To add data into a collection.
  static Future<void> create({
    required String collection,
    required String document,
    required Map<String, dynamic> data,
  }) async {
    try {
      // Add the map data into specified collection.
      final docRef = _db?.collection(collection).doc(document);
      // Set the data. Will create a document and collection if they does not exist otherwise
      // overwrites the existing data.
      await docRef?.set(data);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// To read the document from a single collection.
  Future<DocumentSnapshot?> readC({
    required String collection,
    required String document,
  }) async {
    DocumentSnapshot? snap;
    try {
      snap = await _db?.collection(collection).doc().get();
    } catch (e) {
      debugPrint(e.toString());
    }
    return snap;
  }
}
