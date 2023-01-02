import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:re_vision/utils/cloud/base_cloud.dart';
import 'package:re_vision/utils/cloud/cloud_constants.dart';
import 'package:re_vision/utils/social_auth/base_auth.dart';

class NotificationStream {

  //region Singleton pattern.
  NotificationStream._();

  static final NotificationStream instance = NotificationStream._();

  //endregion

  Stream<QuerySnapshot<Map<String, dynamic>>> getNotifications() async* {
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>>? data = BaseCloud.db
          ?.collection(CloudC.users)
          .doc(BaseAuth.currentUser()?.uid ?? "")
          .collection(CloudC.requests)
          .snapshots();

      if (data != null) {
        await for (QuerySnapshot<Map<String, dynamic>> snap in data) {
          yield snap;
        }
      }
    } on Exception catch (_) {
      // todo: handle notification failure
    }
  }
}
