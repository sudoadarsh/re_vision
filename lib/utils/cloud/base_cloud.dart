import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

typedef JSON = Map<String, dynamic>;

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
    required JSON data,
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
    required JSON data,
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

  /// To update data in the sub-collection.
  static Future<void> updateSC({
    required String collection,
    required String document,
    required String subCollection,
    required String subDocument,
    required JSON data,
  }) async {
    try {
      // Getting a reference of the sub collection document.
      DocumentReference<JSON>? ref = db
          ?.collection(collection)
          .doc(document)
          .collection(subCollection)
          .doc(subCollection);

      // Update the data in the sub collection.
      ref?.update(data);
    } catch (e) {
      debugPrint("Error while updating data in the sub collection");
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
  static Future<QuerySnapshot<JSON>?> readC(String collection) async {
    QuerySnapshot<JSON>? snap;
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
    required JSON data,
  }) async {
    try {
      // Getting a reference of the sub collection document.
      DocumentReference<JSON>? ref = db
          ?.collection(collection)
          .doc(document)
          .collection(subCollection)
          .doc(subDocument);

      // Add data into the sub collection document.
      ref?.set(data);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// To read ids of documents from a sub-collection.
  static Future<List<String>> readSCIDs({
    required String collection,
    required String document,
    required String subCollection,
  }) async {
    // The list of sub collection document ids.
    List<String> ids = [];
    try {
      CollectionReference<JSON>? ref =
          db?.collection(collection).doc(document).collection(subCollection);

      QuerySnapshot<JSON>? qSnap = await ref?.get();

      // Guard the query snapshot.
      if (qSnap == null || qSnap.docs.isEmpty) return ids;

      List<QueryDocumentSnapshot> snaps = qSnap.docs;

      ids = snaps.map((e) => e.id).toList();

      return ids;
    } catch (e) {
      debugPrint(e.toString());
    }
    return ids;
  }

  /// To read all the documents in the sub collection.
  static Future<List<QueryDocumentSnapshot<JSON>>> readSC({
    required String collection,
    required String document,
    required String subCollection,
  }) async {
    try {
      CollectionReference<JSON>? ref =
          db?.collection(collection).doc(document).collection(subCollection);

      QuerySnapshot<JSON>? qSnap = await ref?.get();

      if (qSnap == null) return [];

      return qSnap.docs;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }
}
