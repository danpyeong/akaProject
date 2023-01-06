import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CommentModel {
  CommentModel(
    String s, {
    this.commentName,
    this.commentContent,
    this.commentWriteTime,
    this.commentLikeNum,
    this.commentAnnonSequence,
    this.commentSequenceState,
    this.commentLikeState,
    this.commentModel,
  });

  String? commentName;
  String? commentWriteTime;
  String? commentContent;
  int? commentLikeNum;
  int? commentAnnonSequence;
  int? commentSequenceState;
  bool? commentLikeState;
  Map<String, dynamic>? commentModel;

  DocumentReference? reference;

  CommentModel.fromJson(dynamic json, this.reference) {
    commentName = json['commentName'];
    commentWriteTime = json['commentWriteTime'];
    commentContent = json['commentContent'];
    commentLikeNum = json['commentLikeNum'];
    commentAnnonSequence = json['commentAnnonSequence'];
    commentSequenceState = json['commentSequenceState'];
    commentLikeState = json['commentLikeState'];
    commentModel =
        json[DateFormat('yyyy-MM-dd - HH:mm:ss').format(DateTime.now())];
  }

  CommentModel.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(), snapshot.reference);

  CommentModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(), snapshot.reference);

// 파이어 베이스로 저장 할때 쓴다.
  Map<String, dynamic> toJsonAll() {
    final map = <String, dynamic>{};
    map['commentName'] = commentName;
    map['commentWriteTime='] = commentWriteTime;
    map['commentContent'] = commentContent;
    map['commentLikeNum'] = commentLikeNum;
    map['commentAnnonSequence'] = commentAnnonSequence;
    map['commentSequenceState'] = commentSequenceState;
    map['commentLikeState'] = commentLikeState;
    //map['DateFormat('yyyy-MM-dd - HH:mm:ss').format(DateTime.now())'] = commentModel;
    return map;
  }

  Map<String, dynamic> toJsonPostTitle() {
    final map = <String, dynamic>{};
    //map['postTitle'] = postTitle;
    return map;
  }

  Map<String, dynamic> toJsonCommentLikeState() {
    final map = <String, dynamic>{};
    map['commentLikeState'] = commentLikeState;
    return map;
  }

  Map<String, dynamic> toJsonComment() {
    final map = <String, dynamic>{};
    map[DateFormat('yyyy-MM-dd - HH:mm:ss').format(DateTime.now())] =
        commentModel;
    return map;
  }
}

class Comment {
  String name;
  String time;
  String content;
  int like;
  int annonSequnece;
  int commentSequenceState;

  Comment(
      {required this.name,
      required this.content,
      required this.time,
      required this.like,
      required this.annonSequnece,
      required this.commentSequenceState});
}
