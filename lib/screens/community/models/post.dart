import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PostModel {
  PostModel({
    this.postTitle,
    this.postContent,
    this.userName,
    this.writeTime,
    this.postLikeNum,
    this.commentNum,
    this.postReport,
    this.anonState,
    this.postLikeState,
    this.comment1,
    this.uid,
  });

  String? postTitle;
  String? postContent;
  String? userName;
  String? writeTime;
  int? postLikeNum;
  int? commentNum;
  int? postReport;
  bool? anonState;
  bool? postLikeState;
  Map<String, dynamic>? comment1;
  String? uid;
  DocumentReference? reference;

  // 받아오기
  PostModel.fromJson(dynamic json, this.reference) {
    postTitle = json['postTitle'];
    postContent = json['postContent'];
    userName = json['userName'];
    writeTime = json['writeTime'];
    postLikeNum = json['postLikeNum'];
    commentNum = json['commentNum'];
    postReport = json['postReport'];
    anonState = json['anonState'];
    postLikeState = json['postLikeState'];
    //comment = json['comment $commentNum'];
    comment1 = json[DateFormat('yyyy-MM-dd - HH:mm:ss').format(DateTime.now())];
    uid = json['uid'];
  }

  PostModel.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(), snapshot.reference);

  PostModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(), snapshot.reference);

// 파이어 베이스로 저장 할때 쓴다.
  Map<String, dynamic> toJsonAll() {
    final map = <String, dynamic>{};
    map['postTitle'] = postTitle;
    map['postContent'] = postContent;
    map['userName'] = userName;
    map['writeTime'] = writeTime;
    map['postLikeNum'] = postLikeNum;
    map['commentNum'] = commentNum;
    map['postReport'] = postReport;
    map['anonState'] = anonState;
    map['postLikeState'] = postLikeState;
    map['uid'] = uid;
    return map;
  }

  Map<String, dynamic> toJsonPostTitle() {
    final map = <String, dynamic>{};
    map['postTitle'] = postTitle;
    return map;
  }

  Map<String, dynamic> toJsonPostContent() {
    final map = <String, dynamic>{};
    map['postContent'] = postContent;
    return map;
  }

  Map<String, dynamic> toJsonCommentNum() {
    final map = <String, dynamic>{};
    map['commentNum'] = commentNum;
    return map;
  }

  Map<String, dynamic> toJsonPostLikeNum() {
    final map = <String, dynamic>{};
    map['postLikeNum'] = postLikeNum;
    return map;
  }

  Map<String, dynamic> toJsonPostReport() {
    final map = <String, dynamic>{};
    map['postReport'] = postReport;
    return map;
  }

  Map<String, dynamic> toJsonPostLikeState() {
    final map = <String, dynamic>{};
    map['postLikeState'] = postLikeState;
    return map;
  }

  Map<String, dynamic> toJsonComment() {
    final map = <String, dynamic>{};
    map[DateFormat('yyyy-MM-dd - HH:mm:ss').format(DateTime.now())] = comment1;
    return map;
  }
}
