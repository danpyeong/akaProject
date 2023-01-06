import 'package:aka_project/screens/community/models/post.dart';

class PostRepository {
  final List<PostModel> _dummyPosts = [
    PostModel(
      postTitle: '첫 번째 게시물입니다.',
      //userName: '익명',
      postContent:
          '첫 번째 게시물의 내용입니다첫 번째 게시물의 내용입니다.첫 번째 게시물의 내용입니다.첫 번째 게시물의 내용입니다.첫 번째 게시물의 내용입니다.첫 번째 게시물의 내용입니다.첫 번째 게시물의 내용입니다.첫 번째 게시물의 내용입니다.첫 번째 게시물의 내용입니다.첫 번째 게시물의 내용입니다.첫 번째 게시물의 내용입니다.첫 번째 게시물의 내용입니다.첫 번째 게시물의 내용입니다.첫 번째 게시물의 내용입니다.첫 번째 게시물의 내용입니다.첫 번째 게시물의 내용입니다.첫 번째 게시물의 내용입니다.첫 번째 게시물의 내용입니다.첫 번째 게시물의 내용입니다.첫 번째 게시물의 내용입니다.첫 번째 게시물의 내용입니다.첫 번째 게시물의 내용입니다.첫 번째 게시물의 내용입니다.첫 번째 게시물의 내용입니다.',
      //writeTime: '22.10.30.02:00',
      //anonStatus: 1,
    ),
    PostModel(
      postTitle: '두 번째 게시물입니다.',
      //userName: '익명',
      postContent: '두 번째 게시물의 내용입니다.',
      //writeTime: '22.10.31.02:00',
      //anonStatus: 1,
    ),
  ];

  List<PostModel> getPosts() {
    return _dummyPosts;
  }
}
