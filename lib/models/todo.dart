import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String todoid;
  String content;
  bool done;

  TodoModel({
    required this.todoid,
    required this.content,
    this.done = false,
  });

  factory TodoModel.fromDocumentSnapshot(
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot,
  ) {
    final data = documentSnapshot.data();
    return TodoModel(
      todoid: documentSnapshot.id,
      content: data?['content'] as String? ?? '',
      done: data?['done'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'done': done,
    };
  }
}
