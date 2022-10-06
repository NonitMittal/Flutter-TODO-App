import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/utilities/firebase_auth.dart';
import 'package:todo_app/utilities/todo_item.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

CollectionReference<ToDoItem> getEventRef(String currentUserUid) {
  return firestore
      .collection('TODO_DATA')
      .doc(currentUserUid)
      .collection("items")
      .withConverter(
        fromFirestore: (snapshot, _) => ToDoItem.fromJson(snapshot.data()!),
        toFirestore: (ToDoItem todoItem, _) => todoItem.toJson(),
      );
}

Future<void> addItem({
  required String title,
  required String information,
}) async {
  String currentUserUid = getLoggedInUserId();
  if (currentUserUid.isNotEmpty) {
    String ts = DateTime.now().millisecondsSinceEpoch.toString();

    final eventsRef = getEventRef(currentUserUid);

    await eventsRef.doc(ts).set(
          ToDoItem(
            id: ts,
            title: title,
            information: information,
            complete: false,
          ),
        );
  }
}

Future<void> updateItem({
  required String id,
  required ToDoItem newData,
}) async {
  String currentUserUid = getLoggedInUserId();
  if (currentUserUid.isNotEmpty) {
    final eventsRef = getEventRef(currentUserUid);

    await eventsRef.doc(id).update(
      {
        'title': newData.title,
        'information': newData.information,
        'complete': newData.complete,
      },
    );
  }
}

Future<void> deleteItem({
  required String id,
}) async {
  String currentUserUid = getLoggedInUserId();
  if (currentUserUid.isNotEmpty) {
    final eventsRef = getEventRef(currentUserUid);
    await eventsRef.doc(id).delete();
  }
}

Future<List<QueryDocumentSnapshot<ToDoItem>>?> getItems() async {
  String currentUserUid = getLoggedInUserId();
  if (currentUserUid.isNotEmpty) {
    final eventsRef = getEventRef(currentUserUid);

    return await eventsRef.get().then((snapshot) => snapshot.docs);
  }
  return null;
}