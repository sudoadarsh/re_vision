import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:re_vision/models/reqs_dm.dart';
import 'package:re_vision/utils/cloud/base_cloud.dart';
import 'package:re_vision/utils/cloud/cloud_constants.dart';

class TopicCloudProvider {
  Future<DocumentSnapshot?> fetchData(ReqsDm req) async {
    return BaseCloud.readD(
        collection: CloudC.topic,
        document: req.primaryId ?? ""
    );
  }
}