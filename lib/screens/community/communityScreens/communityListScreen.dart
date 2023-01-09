import 'package:aka_project/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:aka_project/screens/community/communityScreens/communityReadScreen.dart';
import 'package:aka_project/screens/community/communityScreens/communityWriteScreen.dart';
import 'package:aka_project/screens/community/models/post.dart';
import 'package:aka_project/screens/community/services/firebaseService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aka_project/screens/community/services/toast.dart';

class CommuListScreen extends StatefulWidget {
  const CommuListScreen({super.key});

  @override
  State<CommuListScreen> createState() => _CommuListScreenState();
}

class _CommuListScreenState extends State<CommuListScreen> {
  Color bc = const Color.fromARGB(255, 255, 173, 84);
  late String userUid = "";

  @override
  void initState() {
    super.initState();
    getUid();
  }

  Future<bool> checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogin = prefs.getBool('isLogin') ?? false;
    return isLogin;
  }

  Future getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userUid = prefs.getString('uid').toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('자유게시판'),
          backgroundColor: bc,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 15,
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Mainhomepage()),
                  (route) => false).then((value) {
                setState(() {});
              });
            },
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  await checkLogin().then((isLogin) {
                    if (isLogin) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CommuWriteScreen())).then((value) {
                        setState(() {});
                      });
                    } else {
                      ToastService().showToast("로그인 후 글 작성을 이용하실 수 있습니다.");
                    }
                  });
                },
                icon: const Icon(Icons.note_alt_outlined))
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: FutureBuilder<List<PostModel>>(
            future: FireService().getPostModel(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<PostModel> datas = snapshot.data!;
                return ListView.builder(
                    itemCount: datas.length,
                    itemBuilder: (BuildContext context, int index) {
                      PostModel data = datas[index];
                      return PostTile(postModel: data);
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ));
  }
}

class PostTile extends StatefulWidget {
  final PostModel postModel;

  const PostTile({super.key, required this.postModel});
  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20))),
        tileColor: Colors.grey[300],
        title: Text(
          "${widget.postModel.postTitle}",
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        horizontalTitleGap: 5.0,
        subtitle: RichText(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          strutStyle: const StrutStyle(fontSize: 16.0),
          text: TextSpan(
              text: widget.postModel.postContent,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 11,
                color: Colors.grey[500],
                height: 1.4,
              )),
        ),
        trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${widget.postModel.userName}",
                style: const TextStyle(fontSize: 9),
              ),
              Text(
                "${widget.postModel.writeTime}",
                style: const TextStyle(fontSize: 9),
              ),
            ]),
        hoverColor: Colors.orange[300],
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CommuReadScreen(
                        postModel: widget.postModel,
                      ))).then((value) {
            setState(() {});
          });
        });
  }
}
