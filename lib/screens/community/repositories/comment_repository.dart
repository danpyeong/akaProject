import 'package:aka_project/screens/community/communityScreens/communityReportScreen.dart';
import 'package:aka_project/screens/community/models/comment.dart';
import 'package:flutter/material.dart';

enum LikeStatus { on, off }

enum AnonymousStatus { on, off }

enum CommentStatus { none, on }

enum CommentLikeStatus { on, off }

class CommentRepository {
  final List<Comment> _dummyComments = [
    Comment(
      name: '익명',
      like: 0,
      content: '댓글',
      time: '22.10.30.02:00',
      annonSequnece: 1,
      commentSequenceState: 1,
    ),
  ];

  List<Comment> getComments() {
    return _dummyComments;
  }
}

class _Comment extends StatefulWidget {
  //const _Comment({super.key});

  @override
  State<_Comment> createState() => __CommentState();
}

class __CommentState extends State<_Comment> {
  int likeNum = 0; // 좋아요수
  int commentNum = 0; // 댓글수
  int commentLikeNum = 0; // 댓글 좋아요 수
  int anon = 0; // 익명
  int anonSequence = 0; // 익명 인원
  int _popupMenuItemIndex = 0;
  int commentSequence = 0;

  String comment = ''; // 댓글 내용
  String anonimage = 'https://cdn-icons-png.flaticon.com/512/1361/1361876.png';

  final commentController = TextEditingController();

  late LikeStatus _likeStatus; // 해당 게시글에 대한 좋아요 클릭 유무
  late CommentStatus _commentStatus; // 해당 댓글에 대한 개수
  late AnonymousStatus _anonymousStatus; // 해당 댓글의 익명 유무, 익명은 해당 게시글에 한해 계정당 1번
  late CommentLikeStatus _commentLikeStatus; // 해당 댓글에 대한 좋아요 개수, 해당 댓글에 한함

  @override
  void initState() {
    super.initState();
    _likeStatus = LikeStatus.off;
    _commentLikeStatus = CommentLikeStatus.off;
    _commentStatus = CommentStatus.none;
    _anonymousStatus = AnonymousStatus.on;
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  // 댓글 익명 유무
  void annoymousCheck() {
    setState(() {
      if (_anonymousStatus == AnonymousStatus.on) {
        _anonymousStatus = AnonymousStatus.off;
      } else {
        _anonymousStatus = AnonymousStatus.on;
      }
    });
  }

  // 게시글 좋아요
  void likeUp() {
    setState(() {
      if (_likeStatus == LikeStatus.on) {
        _likeStatus = LikeStatus.off;
        //showToast("좋아요 취소");
        likeNum--;
      } else {
        _likeStatus = LikeStatus.on;
        //showToast("좋아요");
        likeNum++;
      }
    });
  }

  // 댓글 좋아요
  void commentLikeUp() {
    setState(() {
      if (_commentLikeStatus == CommentLikeStatus.on) {
        _commentLikeStatus = CommentLikeStatus.off;
        //showToast("좋아요 취소");
      } else {
        _commentLikeStatus = CommentLikeStatus.on;
        //showToast("좋아요");
      }
    });
  }

  // 팝업 메뉴_버튼 둥글게
  RoundedRectangleBorder _rectangleBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(8.0),
      bottomRight: Radius.circular(8.0),
      topLeft: Radius.circular(8.0),
      topRight: Radius.circular(8.0),
    ),
  );

  // 팝업 메뉴 (댓글)
  Widget _popupMenuComment(index) {
    return Container(
      child: PopupMenuButton(
        onSelected: (value) {
          if (value == 1) {
            // 댓글 신고하기
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CommuReportScreen()));
          } else if (value == 2) {
            // 댓글 삭제하기
            _onMenuDeleteSelected(index);
          }
        },
        offset: Offset(0.0, 10.0),
        shape: _rectangleBorder,
        itemBuilder: (ctx) => [
          PopupMenuItem(value: 1, child: Text('신고')),
          PopupMenuItem(value: 2, child: Text('삭제'))
        ],
      ),
    );
  }

  // 댓글 팝업_삭제하기
  _onMenuDeleteSelected(int value) {
    showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text('삭제하시겠습니까?'),
          actions: [
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('삭제'),
              onPressed: () {
                setState(() {
                  _data.removeAt(value);
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
    return Container(
      child: SizedBox(
        height: 100.0,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: TextField(
            style: TextStyle(fontSize: 12),
            controller: commentController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '댓글을 입력하세요',
              hintStyle: TextStyle(
                fontSize: 12.0,
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 1.0, 0),
                child: IconButton(
                  onPressed: annoymousCheck,
                  icon: Column(
                    children: [
                      Icon(
                        _anonymousStatus == AnonymousStatus.on
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        size: 10,
                        color: _anonymousStatus == AnonymousStatus.on
                            ? Colors.red
                            : Colors.grey,
                      ),
                      Text(
                        '익명',
                        style: TextStyle(
                            fontSize: 6,
                            color: _anonymousStatus == AnonymousStatus.on
                                ? Colors.red
                                : Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              suffixIcon: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 1.0, 0),
                child: IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      if (commentController.text.isEmpty == false) {
                        commentUp();
                        _data.add(CommentWidget(_data.length));
                      }
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 댓글 작성 상태 확인
  void commentUp() {
    setState(() {
      if (_commentStatus == CommentStatus.none) {
        anonSequence++;
        _commentStatus = CommentStatus.on;
      }
      commentNum++;
      setState(() {
        // 본인인지 확인해야함.
        comment = commentController.text;
      });
      commentController.clear();
    });
  }

  // 댓글 위젯 리스트
  List<Widget> _data = [];

  // 댓글 Ui
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
                Container(
                  child: Image.network(anonimage),
                  width: 20,
                ),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "익명 $anonSequence",
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                Padding(padding: EdgeInsets.only(right: 7)),
                Icon(
                  commentLikeNum == 0 ? null : Icons.thumb_up_alt,
                  size: 12,
                  color: Colors.pink[200],
                ),
                Text(
                  commentLikeNum == 0 ? '' : '$commentLikeNum',
                  style: TextStyle(color: Colors.pink[200], fontSize: 10),
                ),
              ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        _commentLikeStatus == CommentLikeStatus.off
                            ? Icons.thumb_up_alt_outlined
                            : Icons.thumb_up_alt,
                        size: 12,
                        color: Colors.grey,
                      ),
                      onPressed: commentLikeUp,
                    ),
                    _popupMenuComment(index),
                  ]),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(left: 15)),
              Text(
                '$comment', // data[1]
                style: TextStyle(
                  fontSize: 12,
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                '작성 시간',
                style: TextStyle(fontSize: 8, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
