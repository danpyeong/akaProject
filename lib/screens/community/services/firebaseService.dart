import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aka_project/screens/community/models/post.dart';

class FireService {
  static final FireService _fireService = FireService._internal();

  factory FireService() => _fireService;

  FireService._internal();
  int sequence = 0;
  Future createPost(Map<String, dynamic> json, String string) async {
    await FirebaseFirestore.instance.collection("posts").doc(string).set(json);
  }

  Future createComment(Map<String, dynamic> json, String string) async {
    await FirebaseFirestore.instance
        .collection("posts")
        .doc(string)
        .collection('comments')
        .add(json);
  }

  Future<List<PostModel>> getPostModel() async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection("posts");
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await collectionReference.get();

    List<PostModel> postModels = [];

    for (var doc in querySnapshot.docs) {
      PostModel postModel = PostModel.fromQuerySnapshot(doc);
      postModels.add(postModel);
    }
    return postModels;
  }

  Future<List<PostModel>> getCommentModel(String string) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance
            .collection("posts")
            .doc(string)
            .collection('comments');
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await collectionReference.get();

    List<PostModel> commentModels = [];

    for (var doc in querySnapshot.docs) {
      PostModel postModel = PostModel.fromQuerySnapshot(doc);
      commentModels.add(postModel);
    }
    return commentModels;
  }

  Future updateMemo(
      {required DocumentReference reference,
      required Map<String, dynamic> json}) async {
    await reference.update(json);
  }

  Future setMemo(
      {required DocumentReference reference,
      required Map<String, dynamic> json}) async {
    await reference.update(json);
  }

  Future<void> deleteMemo(DocumentReference reference) async {
    await reference.delete();
  }
}
