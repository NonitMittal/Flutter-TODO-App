import 'package:cloud_firestore/cloud_firestore.dart';

DateTime parseTime(dynamic date) {
  // return Platform.isIOS ? (date as Timestamp).toDate() : (date as DateTime);
  return (date as Timestamp).toDate();
}

class ToDoItem {
  ToDoItem({
    required this.id,
    required this.title,
    required this.information,
    required this.complete,
  });

  String id;
  String title;
  String information;
  bool complete;

  ToDoItem.fromJson(Map<String, Object?> json)
      : this(
          id: json['id'] as String,
          title: json['title'] as String,
          information: json['information'] as String,
          complete: json['complete'] as bool,
        );

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'information': information,
      'complete': complete,
    };
  }

  ToDoItem.copy(ToDoItem item)
      : this(
          id: item.id,
          title: item.title,
          information: item.information,
          complete: item.complete,
        );
}