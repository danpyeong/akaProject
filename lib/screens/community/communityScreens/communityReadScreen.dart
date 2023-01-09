import 'package:aka_project/screens/community/communityScreens/communityListScreen.dart';
import 'package:aka_project/screens/community/communityScreens/communityReportScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:aka_project/screens/community/services/firebaseService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aka_project/screens/community/models/post.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aka_project/screens/community/services/toast.dart';

enum AnonymousStatus { on, off }

// ignore: must_be_immutable
class CommuReadScreen extends StatefulWidget {
  PostModel postModel;

  CommuReadScreen({super.key, required this.postModel});

  @override
  State<CommuReadScreen> createState() => _CommuReadState();
}

class _CommuReadState extends State<CommuReadScreen> {
  String anonimage = 'https://cdn-icons-png.flaticon.com/512/1361/1361876.png';
  late int likeNum = widget.postModel.postLikeNum as int; // 좋아요수
  late int commentNum = widget.postModel.commentNum as int; // 댓글수
  late bool postLikeState = widget.postModel.postLikeState as bool;
  String uid = '';
  late CollectionReference colRef;
  int anon = 0; // 익명
  String nickname = "";
  String commentNickName = "";
  String comment = ''; // 댓글 내용

  final commentController = TextEditingController();

  late bool _anonymousStatus; // 해당 댓글의 익명 유무, 익명은 해당 게시글에 한해 계정당 1번
  late List<Widget> dataList = [];
  late List<String> commentContentList = [];
  late List<bool> commentLikeStateList = [];
  late List<String> commentTimeList = [];
  late List<int> commentLikeNumList = [];
  late List<String> commentNameList = [];
  late List<Map<String, dynamic>> commentList = [];
  late List<String> commentSequence = [];
  late List<String> uidList = [];
  late List<String> nickNameList = [];

  @override
  void initState() {
    super.initState();
    _anonymousStatus = true;
    getData();
    colRef = FirebaseFirestore.instance
        .collection("posts")
        .doc("${widget.postModel.postTitle}")
        .collection('comments');
    getUid();
    getNickname();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  // userid 받기
  Future getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = prefs.getString('uid').toString();
    });
  }

  // 로그인 확인
  Future<bool> checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogin = prefs.getBool('isLogin') ?? false;
    return isLogin;
  }

  // 닉네임 받아오기
  Future getNickname() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection("userInfo");
    var snapshot = await collectionReference.doc(uid).get();
    setState(() {
      nickname = snapshot.get("nickname").toString();
    });
  }

  // 게시글 좋아요
  void likeUp() {
    setState(() {
      if (postLikeState == true) {
        postLikeState = false;
        ToastService().showToast("좋아요 취소");
        likeNum--;
        PostModel updateModel =
            PostModel(postLikeNum: likeNum, postLikeState: postLikeState);
        FireService().updateMemo(
            reference: widget.postModel.reference!,
            json: updateModel.toJsonPostLikeNum());
      } else {
        postLikeState = true;
        ToastService().showToast("좋아요");
        likeNum++;
        PostModel updateModel =
            PostModel(postLikeNum: likeNum, postLikeState: postLikeState);
        FireService().updateMemo(
            reference: widget.postModel.reference!,
            json: updateModel.toJsonPostLikeNum());
      }
    });
  }

  // 게시글 유저 UI
  Widget _User() {
    return Row(
      children: [
        SizedBox(
          width: 40,
          child: Image.network(anonimage),
        ),
        Container(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.postModel.userName}",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.purple[300],
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "${widget.postModel.writeTime}",
                style: TextStyle(fontSize: 10, color: Colors.red[300]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 게시글 제목 UI
  Widget _Title() {
    return Text(
      "${widget.postModel.postTitle}",
      style: const TextStyle(
        color: Colors.black,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // 게시글 내용 UI
  Widget _Content() {
    return Text(
      "${widget.postModel.postContent}",
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      maxLines: null,
    );
  }

  // 게시글_좋아요, 댓글 개수 확인 UI
  Widget _LikeComment() {
    return Row(
      children: [
        Row(
          children: [
            Icon(
              Icons.thumb_up_alt,
              size: 12,
              color: Colors.pink[200],
            ),
            Text(
              "$likeNum",
              style: TextStyle(color: Colors.pink[200], fontSize: 10),
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.only(right: 5)),
        Row(
          children: [
            Icon(
              Icons.chat_bubble,
              size: 12,
              color: Colors.blue[200],
            ),
            Text(
              "$commentNum",
              style: TextStyle(color: Colors.blue[200], fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }

  // 게시글 좋아요 버튼 UI
  Widget _LikeButton() {
    return Row(children: [
      ButtonTheme(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink[200],
          ),
          onPressed: likeUp,
          child: Row(
            children: [
              Icon(
                postLikeState == false
                    ? Icons.thumb_up_alt_outlined
                    : Icons.thumb_up_alt,
                size: 10,
              ),
              const Padding(padding: EdgeInsets.only(right: 5)),
              const Text(
                '공감',
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  // 게시글 팝업
  Widget _popupMenuPost() {
    return PopupMenuButton(
      onSelected: (value) {
        if (value == 1) {
          // 게시글 신고하기
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const CommuReportScreen()));
        } else if (value == 2) {
          // 게시글 삭제하기
          _onMenuDeleteSelectedPost();
        }
      },
      offset: const Offset(0.0, 10.0),
      shape: _rectangleBorder,
      itemBuilder: (ctx) => [
        const PopupMenuItem(value: 1, child: Text('신고')),
        const PopupMenuItem(value: 2, child: Text('삭제'))
      ],
    );
  }

  // 게시글 팝업_삭제하기
  _onMenuDeleteSelectedPost() {
    showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('삭제하시겠습니까?'),
          actions: [
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('삭제'),
              onPressed: () {
                setState(() {
                  if (uid == widget.postModel.uid) {
                    FireService().deleteMemo(widget.postModel.reference!);
                    Navigator.pop(context);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const CommuListScreen()),
                        (route) => false).then(
                      (value) {
                        setState(() {});
                      },
                    );
                    ToastService().showToast("해당 게시물이 삭제됐습니다.");
                  } else {
                    ToastService().showToast("해당 작성자가 아닙니다.");
                    Navigator.pop(context);
                  }
                });
              },
            ),
          ],
        );
      }),
    );
  }

  // 댓글 작성 UI
  Widget _Comment() {
    return SizedBox(
      height: 50.0,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: TextField(
          style: const TextStyle(fontSize: 12),
          controller: commentController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: '댓글을 입력하세요',
            hintStyle: const TextStyle(
              fontSize: 12.0,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 1.0, 0),
              child: IconButton(
                onPressed: annoymousCheck,
                icon: Column(
                  children: [
                    Icon(
                      _anonymousStatus == true
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      size: 10,
                      color:
                          _anonymousStatus == true ? Colors.red : Colors.grey,
                    ),
                    Text(
                      nickname,
                      style: TextStyle(
                          fontSize: 6,
                          color: _anonymousStatus == true
                              ? Colors.red
                              : Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 1.0, 0),
              child: IconButton(
                icon: const Icon(
                  Icons.send,
                  color: Colors.red,
                ),
                onPressed: () async {
                  if (commentController.text.isEmpty == false) {
                    await checkLogin().then((isLogin) {
                      if (isLogin) {
                        commentUp();
                        dataList.add(CommentWidget(dataList.length));
                      } else {
                        ToastService().showToast("로그인 후 댓글 작성하실 수 있습니다.");
                      }
                    });
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 댓글 작성 기능
  void commentUp() {
    setState(() {
      commentNum++;
      PostModel updateModel = PostModel(commentNum: commentNum);
      FireService().updateMemo(
          reference: widget.postModel.reference!,
          json: updateModel.toJsonCommentNum());

      commentContentList.add(commentController.text);
      commentNickName = _anonymousStatus == true ? '익명' : nickname;
      uidList.add(uid);
      nickNameList.add(nickname);
      commentLikeNumList.add(0);
      commentLikeStateList.add(false);
      commentNameList.add(commentNickName);
      commentTimeList
          .add(DateFormat('yyyy-MM-dd - HH:mm:ss').format(DateTime.now()));

      commentController.clear();

      final commentInfo = <String, dynamic>{
        "commentName": commentNickName,
        "commentContent": commentContentList[dataList.length],
        'commentTime':
            DateFormat('yyyy-MM-dd - HH:mm:ss').format(DateTime.now()),
        'commentLikeState': false,
        'commentLikeNum': 0,
        'commentReport': 0,
        "uid": uid,
        "nickName": nickname,
      };

      PostModel commentModel = PostModel(comment1: commentInfo);
      FireService().createComment(
          commentModel.toJsonComment(), widget.postModel.postTitle.toString());
    });
  }

  // 게시글 확인 시 저장된 댓글 데이터 수집
  void getData() async {
    var snapshot = await FirebaseFirestore.instance
        .collection("posts")
        .doc("${widget.postModel.postTitle}")
        .collection('comments')
        .get();

    Map<String, dynamic> model = {};

    if (snapshot.docs.isNotEmpty) {
      for (int i = 0; i < snapshot.docs.length; i++) {
        model = snapshot.docs[i].get(snapshot.docs[i]
            .data()
            .keys
            .toString()
            .replaceAll('(', ' ')
            .replaceAll(')', ' ')
            .trim());
        setState(() {
          commentContentList.add(model['commentContent']);
          commentLikeNumList.add(model['commentLikeNum']);
          commentLikeStateList.add(model['commentLikeState']);
          commentNameList.add(model['commentName']);
          commentTimeList.add(model['commentTime']);
          commentSequence.add(snapshot.docs[i].id.toString());
          dataList.add(CommentWidget(dataList.length));
          uidList.add(model['uid']);
          nickNameList.add(model['nickName']);
          List<Widget>.generate(
              dataList.length, (index) => CommentWidget(index));
        });
      }
    } else {
      print("empty");
    }
  }

  // 댓글 익명 유무
  void annoymousCheck() {
    setState(() {
      if (_anonymousStatus == true) {
        _anonymousStatus = false;
      } else {
        _anonymousStatus = true;
      }
    });
  }

  // 댓글 UI
  Widget CommentWidget(index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                SizedBox(
                  width: 20,
                  child: Image.network(anonimage),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  // 댓글 작성자 이름
                  child: Text(
                    commentNameList[index],
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(right: 7)),
                Icon(
                  // 현재 좋아요 상태에 따른 ui 변화 (아이콘)
                  commentLikeNumList[index] == 0 ? null : Icons.thumb_up_alt,
                  size: 12,
                  color: Colors.pink[200],
                ),
                Text(
                  // 현재 좋아요 상태에 따른 ui 변화 (텍스트)
                  commentLikeNumList[index] == 0
                      ? ''
                      : '${commentLikeNumList[index]}',
                  style: TextStyle(color: Colors.pink[200], fontSize: 10),
                ),
              ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        commentLikeStateList[index] == false
                            ? Icons.thumb_up_alt_outlined
                            : Icons.thumb_up_alt,
                        size: 12,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          if (commentLikeStateList[index] == false) {
                            commentLikeStateList[index] = true;
                            ToastService().showToast("좋아요");
                            commentLikeNumList[index]++;
                            Map<String, dynamic> update = {
                              "commentLikeNum": commentLikeNumList[index]
                            };
                            FirebaseFirestore.instance
                                .collection("posts")
                                .doc("${widget.postModel.postTitle}")
                                .collection('comments')
                                .doc(commentSequence[index])
                                .update(update);
                          } else {
                            commentLikeStateList[index] = false;
                            ToastService().showToast("좋아요 취소");
                            commentLikeNumList[index]--;
                            Map<String, dynamic> update = {
                              "commentLikeNum": commentLikeNumList[index]
                            };
                            FirebaseFirestore.instance
                                .collection("posts")
                                .doc("${widget.postModel.postTitle}")
                                .collection('comments')
                                .doc(commentSequence[index])
                                .update(update);
                          }
                        });
                      },
                    ),
                    _popupMenuComment(index),
                  ]),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.only(left: 15)),
              // 댓글 내용
              Text(
                commentContentList[index],
                style: const TextStyle(
                  fontSize: 12,
                ),
                textAlign: TextAlign.left,
              ),
              // 작성 시간
              Text(
                commentTimeList[index],
                style: const TextStyle(fontSize: 8, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 팝업 메뉴_버튼 둥글게
  final RoundedRectangleBorder _rectangleBorder = const RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(8.0),
      bottomRight: Radius.circular(8.0),
      topLeft: Radius.circular(8.0),
      topRight: Radius.circular(8.0),
    ),
  );

  // 팝업 메뉴 (댓글)
  Widget _popupMenuComment(index) {
    return PopupMenuButton(
      onSelected: (value) {
        if (value == 1) {
          // 댓글 신고하기
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const CommuReportScreen()));
        } else if (value == 2) {
          // 댓글 삭제하기
          _onMenuDeleteSelectedComment(index);
        }
      },
      offset: const Offset(0.0, 10.0),
      shape: _rectangleBorder,
      itemBuilder: (ctx) => [
        const PopupMenuItem(value: 1, child: Text('신고')),
        const PopupMenuItem(value: 2, child: Text('삭제'))
      ],
    );
  }

  // 댓글 팝업_삭제하기
  _onMenuDeleteSelectedComment(index) {
    showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('삭제하시겠습니까?'),
          actions: [
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('삭제'),
              onPressed: () {
                setState(() {
                  if (uid == uidList[index]) {
                    dataList.removeAt(index);
                    commentContentList.removeAt(index);
                    commentNum--;
                    colRef.doc(commentSequence[index]).delete();
                    commentSequence.removeAt(index);
                    Navigator.pop(context);
                    ToastService().showToast("해당 댓글이 삭제됐습니다.");
                  } else {
                    ToastService().showToast("해당 댓글의 작성자가 아닙니다.");
                    Navigator.pop(context);
                  }
                });
              },
            ),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color bc = const Color.fromARGB(255, 255, 173, 84);
    Padding bp = const Padding(padding: EdgeInsets.all(5));

    return Scaffold(
      appBar: AppBar(
        title: const Text("자유게시판_게시글_확인"),
        backgroundColor: bc,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 15,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [_popupMenuPost()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _User(),
            bp,
            _Title(),
            bp,
            _Content(),
            bp,
            _LikeComment(),
            bp,
            _LikeButton(),
            bp,
            // 5 박스 (댓글)
            Column(
                children: List<Widget>.generate(
                    dataList.length, (index) => CommentWidget(index))),
          ],
        ),
      ),
      // 6 박스 ( 댓글 달기 )
      bottomNavigationBar: _Comment(),
    );
  }
}
