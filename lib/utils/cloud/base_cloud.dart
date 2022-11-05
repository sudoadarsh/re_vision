import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class BaseCloud {
  // Initialise the cloud firestore.
  static FirebaseFirestore? db;

  /// Ensure this [BaseCloud.init] is called before using any of its methods.
  static FirebaseFirestore? init() {
    db = FirebaseFirestore.instance;
    return db;
  }

  /// To add data into a collection document.
  static Future<void> create({
    required String collection,
    required String document,
    required Map<String, dynamic> data,
  }) async {
    try {
      // Add the map data into specified collection.
      final docRef = db?.collection(collection).doc(document);
      // Set the data. Will create a document and collection if they does not exist otherwise
      // overwrites the existing data.
      await docRef?.set(data);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// To update data in a collection document.
  static Future<void> update({
    required String collection,
    required String document,
    required Map<String, dynamic> data,
  }) async {
    try {
      // Get the reference of the document.
      final docRef = db?.collection(collection).doc(document);
      // Update a field in the document.
      await docRef?.update(data);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// To read a document from a single document.
  static Future<DocumentSnapshot?> readD({
    required String collection,
    required String document,
  }) async {
    DocumentSnapshot? snap;
    try {
      snap = await db?.collection(collection).doc(document).get();
    } catch (e) {
      debugPrint(e.toString());
    }
    return snap;
  }

  /// Read the entire collection.
  static Future<QuerySnapshot<Map<String, dynamic>>?> readC(
      String collection) async {
    QuerySnapshot<Map<String, dynamic>>? snap;
    try {
      snap = await db?.collection(collection).get();
    } catch (e) {
      debugPrint(e.toString());
    }
    return snap;
  }

  /// To create a sub collection inside a document.
  static Future<void> createSC({
    required String collection,
    required String document,
    required String subCollection,
    required String subDocument,
    required Map<String, dynamic> data,
  }) async {
    try {
      // Getting a reference of the sub collection document.
      DocumentReference<Map<String, dynamic>>? ref =  db
          ?.collection(collection)
          .doc(document)
          .collection(subCollection)
          .doc(subCollection);

      // Add data into the sub collection document.
      ref?.set(data);

    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
