import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _IDController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumController = TextEditingController();
  final TextEditingController _nickNameController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> createUser() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      String? useruid = userCredential.user?.uid;

      addNewUserInfo(
          useruid: useruid,
          name: _nameController.text,
          id: _IDController.text,
          nickname: _nickNameController.text,
          phonenum: _phoneNumController.text);

      if (userCredential.user != null) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showToast('비밀번호를 6자 이상 입력해주세요.');
      } else if (e.code == 'invalid-email') {
        showToast('올바른 이메일 형식으로 입력해주세요.');
      } else if (e.code == 'email-already-in-use') {
        showToast('이미 존제하는 이메일입니다.');
      }
      print(e.code);
    } catch (e) {
      print(e);
    }
  }

  Future<void> addNewUserInfo(
      {required String? useruid,
      required String name,
      required String id,
      required String nickname,
      required String phonenum}) async {
    try {
      if (useruid != null) {
        FirebaseFirestore db = FirebaseFirestore.instance;
        final example = <String, String>{
          "name": name,
          "id": id,
          "nickname": nickname,
          "phonenum": phonenum,
        };

        await db
            .collection("userInfo")
            .doc("$useruid")
            .set(example)
            .onError((e, _) => print("Error writing document: $e"));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _IDController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumController.dispose();
    _nickNameController.dispose();
    super.dispose();
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.orange[300],
      textColor: Colors.white,
      fontSize: 12.0,
    );
  }

  Widget _userIdWidget() {
    return TextFormField(
      controller: _IDController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: '학번',
      ),
      validator: (String? value) {
        if (value!.isEmpty) {
          return '학번을 입력해주세요.';
        }
        return null;
      },
    );
  }

  Widget _passwordWidget() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: '비밀번호',
      ),
      validator: (String? value) {
        if (value!.isEmpty) {
          return '비밀번호를 입력해주세요.';
        }
        return null;
      },
    );
  }

  Widget _nameWidget() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: '이름',
      ),
      validator: (String? value) {
        if (value!.isEmpty) {
          return '이름을 입력해주세요.';
        }
        return null;
      },
    );
  }

  Widget _emailWidget() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'E-mail',
      ),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'E-mail을 입력해주세요.';
        }
        return null;
      },
    );
  }

  Widget _phoneNumWidget() {
    return TextFormField(
      controller: _phoneNumController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: '전화번호',
      ),
      validator: (String? value) {
        if (value!.isEmpty) {
          return '전화번호를 입력해주세요.';
        }
        return null;
      },
    );
  }

  Widget _nickNameWidget() {
    return TextFormField(
      controller: _nickNameController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: '닉네임',
      ),
      validator: (String? value) {
        if (value!.isEmpty) {
          return '닉네임을 입력해주세요.';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Color backColor = const Color.fromARGB(255, 64, 196, 255);
    return Scaffold(
      appBar: AppBar(
        title: const Text("회원 가입"),
        backgroundColor: backColor,
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
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(80, 0, 80, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _nameWidget(),
              const SizedBox(height: 20.0),
              _emailWidget(),
              const SizedBox(height: 20.0),
              _passwordWidget(),
              const SizedBox(height: 20.0),
              _userIdWidget(),
              const SizedBox(height: 20.0),
              _phoneNumWidget(),
              const SizedBox(height: 20.0),
              _nickNameWidget(),
              Container(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (_nameController.text.isEmpty) {
                          showToast("아이디를 다시 입력해주세요.");
                        } else if (_emailController.text.isEmpty) {
                          showToast("이메일을 입력해주세요.");
                        } else if (_passwordController.text.isEmpty) {
                          showToast("비밀번호를 입력해주세요.");
                        } else if (_IDController.text.isEmpty) {
                          showToast("학번을 다시 입력해주세요.");
                        } else if (_phoneNumController.text.isEmpty) {
                          showToast("전화번호를 다시 입력해주세요.");
                        } else if (_nickNameController.text.isEmpty) {
                          showToast("닉네임을 다시 입력해주세요.");
                        } else {
                          createUser();
                        }
                      },
                      child: const Text("가입"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
