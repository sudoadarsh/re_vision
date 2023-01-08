import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

abstract class FBStorage {
  // One and only instance of the firebase storage.
  static FirebaseStorage? firebaseStorage;

  FirebaseStorage? init();

  Future<String?> upload({
    required String bucketPath,
    required String contentPath,
    required File file,
  });
}

class FBStorageSingleton implements FBStorage {
  //region Singleton Pattern.
  FBStorageSingleton._();

  static final FBStorageSingleton instance = FBStorageSingleton._();

  //endregion

  @override
  FirebaseStorage? init() {
    FBStorage.firebaseStorage = FirebaseStorage.instance;
    return FBStorage.firebaseStorage;
  }

  @override
  Future<String?> upload({
    required String bucketPath,
    required String contentPath,
    required File file,
  }) async {
    // Create a storage reference.
    final Reference? storageRef = FBStorage.firebaseStorage?.ref();

    // Create a pointer to the bucket.
    final Reference? bucketRef = storageRef?.child("$bucketPath/$contentPath");

    // Upload the file.
    UploadTask? uploadTask = bucketRef?.putFile(file);
    
    return uploadTask?.snapshot.ref.getDownloadURL();
  }
}
