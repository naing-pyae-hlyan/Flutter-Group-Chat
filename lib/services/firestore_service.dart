import 'package:cloud_firestore/cloud_firestore.dart';

const COLLECTION = 'group_chat';
const ORDER_BY = 'timestamp';
const NAME = 'name';
const MESSAGE = 'message';

class FireStoreService {
  // Collection reference
  final CollectionReference _groupChatCollection =
      FirebaseFirestore.instance.collection(COLLECTION);

  // send message
  sendMessages(String message, String name) {
    if (message != null || message != '') {
      Map<String, dynamic> map = {
        MESSAGE: message,
        NAME: name,
        ORDER_BY: DateTime.now().millisecondsSinceEpoch,
      };

      var docRef = _groupChatCollection
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(docRef, map);
      });
    }
  }

  // get chat
  getChatsMessages() {
    return _groupChatCollection
        .orderBy(ORDER_BY, descending: false)
        .snapshots();
  }
}
