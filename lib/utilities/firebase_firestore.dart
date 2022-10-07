import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/utilities/firebase_auth.dart';
import 'package:todo_app/utilities/todo_item.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<void> addItem({
  required String title,
  required String information,
}) async {
  String currentUserUid = getLoggedInUserId();
  if (currentUserUid.isNotEmpty) {
    String ts = DateTime.now().millisecondsSinceEpoch.toString();
    final db = firestore.collection(currentUserUid).doc(ts);

    await db.set({
      "id": ts,
      "title": title,
      "information": information,
      "complete": false
    });
  }
}

Future<void> updateItem({
  required String id,
  required ToDoItem newData,
}) async {
  String currentUserUid = getLoggedInUserId();
  if (currentUserUid.isNotEmpty) {
    final db = firestore.collection(currentUserUid).doc(id);

    await db.update({
      "title": newData.title,
      "information": newData.information,
      "complete": newData.complete
    });
  }
}

Future<void> deleteItem({
  required String id,
}) async {
  String currentUserUid = getLoggedInUserId();
  if (currentUserUid.isNotEmpty) {
    final db = firestore.collection(currentUserUid).doc(id);
    await db.delete();
  }
}

Future<List<QueryDocumentSnapshot<ToDoItem>>?> getItems() async {
  String currentUserUid = getLoggedInUserId();
  if (currentUserUid.isNotEmpty) {
    final ref = firestore.collection(currentUserUid).withConverter(
          fromFirestore: (snapshot, _) => ToDoItem.fromJson(snapshot.data()!),
          toFirestore: (ToDoItem todoItem, _) => todoItem.toJson(),
        );

    return await ref.get().then((snapshot) => snapshot.docs);
  }
  return null;
}
