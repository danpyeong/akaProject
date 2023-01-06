import 'package:aka_project/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:aka_project/screens/myInfo/signUp_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AutoLoginStatus { on, off }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late AutoLoginStatus _autoLoginStatus;

  Future setLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_autoLoginStatus == AutoLoginStatus.on) {
      prefs.setBool('isLogin', true);
    } else {
      prefs.setBool('isLogin', false);
    }
  }

  static Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("No User found for that email");
      }
    }
    return user;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _autoLoginStatus = AutoLoginStatus.on;
    super.initState();
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

  void AutoLogin() {
    setState(() {
      if (_autoLoginStatus == AutoLoginStatus.off) {
        _autoLoginStatus = AutoLoginStatus.on;
        showToast("자동로그인이 활성화됐습니다.");
      } else {
        _autoLoginStatus = AutoLoginStatus.off;
        showToast("자동로그인이 비활성화됐습니다.");
      }
    });
  }

  Widget _userEmailWidget() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.person),
        border: OutlineInputBorder(),
        labelText: '이메일',
      ),
      validator: (String? value) {
        if (value!.isEmpty) {
          return '이메일을 입력해주세요.';
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
        prefixIcon: Icon(Icons.key),
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

  @override
  Widget build(BuildContext context) {
    Color backColor = const Color.fromARGB(255, 64, 196, 255);
    return Scaffold(
      appBar: AppBar(
        title: const Text("로그인"),
        backgroundColor: backColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
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
          padding: const EdgeInsets.all(80.0),
          child: Column(
            children: [
              const Image(
                image: AssetImage('images/logo.png'),
                width: 200,
                height: 100,
                //fit: BoxFit.contain,
              ),
              const SizedBox(height: 20.0),
              Column(
                children: [
                  _userEmailWidget(),
                  const SizedBox(height: 20.0),
                  _passwordWidget(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          icon: Icon(
                            _autoLoginStatus == AutoLoginStatus.off
                                ? Icons.check_box_outline_blank
                                : Icons.check_box_outlined,
                            size: 17,
                          ),
                          onPressed: AutoLogin),
                      const Text("자동로그인"),
                    ],
                  ),
                  Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        ElevatedButton(
                            onPressed: () async {
                              User? user = await loginUsingEmailPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  context: context);
                              if (user != null) {
                                setLogin();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            Mainhomepage()),
                                    (route) => false);
                                showToast("로그인에 성공하였습니다.");
                              } else {
                                showToast(
                                    "로그인에 실패하였습니다.\n아이디와 비밀번호를 다시 확인해주세요.");
                              }
                            },
                            child: const Text("로그인")),
                        const SizedBox(width: 40.0),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUpScreen()),
                              );
                            },
                            child: const Text("회원 가입")),
                      ])),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
