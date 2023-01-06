import 'package:flutter/material.dart';
import 'package:aka_project/screens/community/models/post.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aka_project/screens/community/services/firebaseService.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AnonymousStatus { on, off }

class CommuWriteScreen extends StatefulWidget {
  const CommuWriteScreen({super.key});

  @override
  State<CommuWriteScreen> createState() => _CommuWScreenState();
}

class _CommuWScreenState extends State<CommuWriteScreen> {
  late PostModel postModel;
  late AnonymousStatus _anonymousStatus;

  String userName = '';
  String writeTime = DateFormat('yyyy-MM-dd - HH:mm:ss').format(DateTime.now());
  String postTitle = '';
  String postContent = '';
  String uid = '';
  int postLikeNum = 0; // 좋아요수
  int commentNum = 0; // 댓글수
  int postReport = 0;

  final List<String> _postTitle = []; // 게시글 제목 리스트
  final List<String> _postContent = []; // 게시글 내용 리스트

  @override
  void initState() {
    super.initState();
    _anonymousStatus = AnonymousStatus.on;
    getUid();
  }

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  // userid 받기
  Future getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = prefs.getString('uid').toString();
    });
  }

  void savePost(CollectionReference userPost) async {
    setState(() {
      _postTitle.add(titleController.text);
      _postContent.add(contentController.text);

      postTitle = _postTitle[_postTitle.length - 1];
      postContent = _postContent[_postContent.length - 1];

      if (_anonymousStatus == AnonymousStatus.on) {
        userName = '익명';
      } else {
        userName = '';
      }
    });

    PostModel postModel = PostModel(
      postTitle: postTitle,
      postContent: postContent,
      writeTime: DateFormat('yyyy-MM-dd - HH:mm:ss').format(DateTime.now()),
      userName: userName,
      postLikeNum: postLikeNum,
      commentNum: commentNum,
      postReport: 0,
      postLikeState: false,
      uid: uid,
    );

    await FireService()
        .createPost(postModel.toJsonAll(), postModel.postTitle.toString());
  }

  void annoymousCheck() {
    setState(() {
      if (_anonymousStatus == AnonymousStatus.on) {
        _anonymousStatus = AnonymousStatus.off;
      } else {
        _anonymousStatus = AnonymousStatus.on;
      }
    });
  }

  // 제목 작성
  Widget _TitleWrite() {
    return SizedBox(
      height: 72.0,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: TextField(
          style: const TextStyle(
            fontSize: 24,
          ),
          controller: titleController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            hintText: '제목을 입력하세요',
            hintStyle: TextStyle(
              fontSize: 24.0,
            ),
          ),
        ),
      ),
    );
  }

  // 내용 작성
  Widget _ContentWrite() {
    const int maxLines = 20;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: TextField(
          style: const TextStyle(fontSize: 16),
          controller: contentController,
          keyboardType: TextInputType.multiline,
          maxLines: maxLines,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            hintText: '내용을 입력하세요',
            hintStyle: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color bc = const Color.fromARGB(255, 255, 173, 84);
    CollectionReference userPost =
        FirebaseFirestore.instance.collection("posts");

    return Scaffold(
      appBar: AppBar(
        title: const Text("자유게시판_게시글_작성"),
        backgroundColor: bc,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.send,
              color: Colors.white,
              size: 15,
            ),
            onPressed: () {
              setState(() {
                if (titleController.text.isEmpty == false &&
                    contentController.text.isEmpty == false) {
                  savePost(userPost);
                }
              });
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제목
              _TitleWrite(),
              // 내용
              _ContentWrite(),
            ],
          ),
        ),
      ),
      // 익명
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            IconButton(
              onPressed: annoymousCheck,
              icon: Icon(
                _anonymousStatus == AnonymousStatus.on
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                size: 20,
                color: _anonymousStatus == AnonymousStatus.on
                    ? Colors.red
                    : Colors.grey,
              ),
            ),
            Text(
              '익명',
              style: TextStyle(
                  fontSize: 18,
                  color: _anonymousStatus == AnonymousStatus.on
                      ? Colors.red
                      : Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
