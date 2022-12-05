import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:re_vision/utils/cloud/base_cloud.dart';

class SearchProvider {
  Future<List<QueryDocumentSnapshot?>> fetch(String val) async {
    QuerySnapshot? snap =  await BaseCloud.db?.collection("users").where("email", isGreaterThanOrEqualTo: val.trim()).get();
    return snap?.docs ?? [];
  }
}