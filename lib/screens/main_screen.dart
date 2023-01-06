import 'package:aka_project/screens/community/communityScreens/communityListScreen.dart';
import 'package:aka_project/screens/food/deliveryScreen/delivery_screen.dart';
import 'package:aka_project/screens/food/schoolMenuScreen/foodlist_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'myInfo/login_page.dart';
import 'myInfo/myInfo_page.dart';

enum LoginTextStatus { login, info }

class Mainhomepage extends StatefulWidget {
  @override
  State<Mainhomepage> createState() => _MainhomepageState();
}

class _MainhomepageState extends State<Mainhomepage> {
  final _authentication = FirebaseAuth.instance;
  static User? nowUser;
  late LoginTextStatus _loginTextStatus = LoginTextStatus.login;

  @override
  void initState() {
    super.initState();
    checkLogin();
    setUser();
  }

  Future<bool> checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogin = prefs.getBool('isLogin') ?? false;
    setState(() {
      if (isLogin) {
        _loginTextStatus = LoginTextStatus.info;
      } else {
        _loginTextStatus = LoginTextStatus.login;
      }
    });

    return isLogin;
  }

  Future<void> setUser() async {
    try {
      nowUser = _authentication.currentUser;
      if (nowUser != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLogin', true);
        prefs.setString('uid', nowUser!.uid);
      }
    } catch (e) {
      print(e);
    }
  }

  launchBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    }
  }

  launchWebView(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: true, forceWebView: true);
    }
  }

  Color backColor = const Color.fromARGB(255, 106, 114, 225);
  Color PortButtonColor = const Color.fromARGB(255, 255, 173, 84);
  Color LunchButtonColor = Color.fromARGB(255, 85, 216, 140);
  Color DeliveryButtonColor = Color.fromARGB(255, 102, 185, 241);

  Padding pd65 = const Padding(padding: EdgeInsets.only(top: 65));
  Padding pd30 = const Padding(padding: EdgeInsets.only(top: 30));

  // 게시판, 학식, 배달 버튼
  Widget CenterButton() {
    return Column(
      children: [
        SizedBox(
          width: 270,
          height: 60,
          child: ElevatedButton.icon(
            //게시판 버튼
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CommuListScreen()));
            },
            icon: Image.asset('images/notice board.png'),
            style: ElevatedButton.styleFrom(
              primary: PortButtonColor,
              padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
              textStyle: TextStyle(fontSize: 18),
            ),
            label: Row(
              children: [
                Expanded(
                  child: Text(
                    '게시판',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        pd65,
        SizedBox(
          width: 270,
          height: 60,
          child: ElevatedButton.icon(
            //학식 버튼
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => foodlist()));
            },
            icon: Image.asset('images/lunch.png'),
            style: ElevatedButton.styleFrom(
              primary: LunchButtonColor,
              padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
              textStyle: TextStyle(fontSize: 18),
            ),
            label: Row(
              children: [
                Expanded(
                  child: Text(
                    '금주의 학식',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        pd65,
        SizedBox(
          width: 270,
          height: 60,
          child: ElevatedButton.icon(
            //배달 버튼
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => deliver()));
            },
            icon: Image.asset('images/fooddelivery.png'),
            style: ElevatedButton.styleFrom(
              primary: DeliveryButtonColor,
              padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
              textStyle: TextStyle(fontSize: 18),
            ),
            label: Row(
              children: [
                Expanded(
                  child: Text(
                    '배달의 안양인',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 하단 메뉴바 사이트 이동
  Widget UrlButton() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                launchBrowser("https://www.anyang.ac.kr/main/index.do");
              });
            },
            child: Column(
              children: <Widget>[
                Icon(Icons.link),
                Text("안양대 홈페이지"),
              ],
            ),
            style: ElevatedButton.styleFrom(
              primary: backColor,
              textStyle: TextStyle(fontSize: 18),
            ),
          ),
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                launchBrowser("https://portal.anyang.ac.kr/");
              });
            },
            child: Column(
              children: <Widget>[
                Icon(Icons.link),
                Text("포털사이트"),
              ],
            ),
            style: ElevatedButton.styleFrom(
              primary: backColor,
              textStyle: TextStyle(fontSize: 18),
              minimumSize: Size(120, 70),
            ),
          ),
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                launchBrowser("https://cyber.anyang.ac.kr/index.jsp");
              });
            },
            child: Column(
              children: <Widget>[
                Icon(Icons.link),
                Text("사이버 강의실"),
              ],
            ),
            style: ElevatedButton.styleFrom(
              primary: backColor,
              textStyle: TextStyle(fontSize: 18),
              minimumSize: Size(120, 70),
            ),
          ),
        )
      ],
    );
  }

  // 내정보 버튼
  Widget MyInfoButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () async {
            await checkLogin().then((isLogin) {
              if (isLogin) {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MyInfoScreen()));
                _loginTextStatus = LoginTextStatus.info;
              } else {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
                _loginTextStatus = LoginTextStatus.login;
              }
            });
          },
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPrimary: Colors.white,
            primary: backColor,
            minimumSize: Size(80, 50),
            textStyle: TextStyle(fontSize: 20),
          ),
          child:
              Text(_loginTextStatus == LoginTextStatus.login ? '로그인' : '내 정보'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Anyang KangHwa Application"),
        backgroundColor: backColor,
        centerTitle: true,
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                pd30,
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 350),
                      Image.asset('images/logo.png'), //안양대 로고 사진
                      MyInfoButton(),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
                pd65,
                CenterButton(),
                pd65
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(height: 60),
        child: UrlButton(),
      ),
    );
  }
}
