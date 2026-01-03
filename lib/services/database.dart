import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/models/todo.dart';

class Database{
  final FirebaseFirestore firestore;

  Database(this.firestore);

  Stream<List<TodoModel>> streamTodos({required String uId}) {
    try{ 
      return firestore
        .collection("todos")
        .doc(uId).collection("todos")
        .snapshots() 
        .map((query) {
          List<TodoModel> retVal = [];
          for (final doc in query.docs) {
            retVal.add(TodoModel.fromDocumentSnapshot(doc));
          }
          return retVal;
        });
    } catch(e) {
      rethrow;
    }
  }
}

  Future<void> addTodo({required String uId, required String content, required dynamic firestore}) async {
    try {
      await firestore
        .collection("todos")
        .doc(uId).collection("todos")
        .add({
          "content": content,
          "done": false,
        });
    } catch(e) {
      rethrow;
    }
  }

  Future<void> updateTodo({required String uId, required String todoId, required bool done, required dynamic firestore}) async {
    try {
      await firestore
        .collection("todos")
        .doc(uId).collection("todos")
        .doc(todoId)
        .update({
          "done": done,
        });
    } catch(e) {
      rethrow;
    }
  }
