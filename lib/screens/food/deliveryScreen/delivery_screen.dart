import 'package:aka_project/screens/food/deliveryScreen/food_type/delivery_screen_china.dart';
import 'package:aka_project/screens/food/deliveryScreen/food_type/delivery_screen_fbf.dart';
import 'package:aka_project/screens/food/deliveryScreen/food_type/delivery_screen_japan.dart';
import 'package:aka_project/screens/food/deliveryScreen/food_type/delivery_screen_korean.dart';
import 'package:aka_project/screens/food/deliveryScreen/food_type/delivery_screen_west.dart';
import 'package:aka_project/screens/main_screen.dart';
import 'package:flutter/material.dart';

class deliver extends StatelessWidget {
  const deliver({super.key});

  @override
  Widget build(BuildContext context) {
    Color backColor = const Color.fromARGB(255, 102, 185, 241);
    Color koreanFoodColor = const Color.fromARGB(255, 241, 118, 105);
    Color chinaFoodColor = const Color.fromARGB(255, 239, 172, 113);
    Color japanFoodColor = const Color.fromARGB(255, 239, 208, 85);
    Color westFoodColor = const Color.fromARGB(255, 72, 241, 144);
    Color snackFoodColor = const Color.fromARGB(255, 71, 169, 234);

    Padding pd50 = const Padding(padding: EdgeInsets.only(top: 50));
    Padding pd30 = const Padding(padding: EdgeInsets.only(top: 30));

    // 한식 음식페이지 버튼
    Widget KoreanFoodButton() {
      return SizedBox(
        width: 280,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => deliver_korean()));
          },
          icon: Image.asset('images/bibimbap.png'),
          style: ElevatedButton.styleFrom(
            primary: koreanFoodColor,
            padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          label: Row(
            children: [
              Expanded(
                child: Text(
                  '한식',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 중식 음식페이지 버튼
    Widget ChinaFoodButton() {
      return SizedBox(
        width: 280,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Delivery_China()));
          },
          icon: Image.asset('images/jjajangmyeon.png'),
          style: ElevatedButton.styleFrom(
            primary: chinaFoodColor,
            padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          label: Row(
            children: [
              Expanded(
                child: Text(
                  '중식',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 일식 음식페이지 버튼
    Widget JapanFoodButton() {
      return SizedBox(
        width: 280,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => deliver_japan()));
          },
          icon: Image.asset('images/ramen.png'),
          style: ElevatedButton.styleFrom(
            primary: japanFoodColor,
            padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          label: Row(
            children: [
              Expanded(
                child: Text(
                  '일식',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 양식 음식페이지 버튼
    Widget WestFoodButton() {
      return SizedBox(
        width: 280,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => deliver_west()));
          },
          icon: Image.asset('images/pizza.png'),
          style: ElevatedButton.styleFrom(
            primary: westFoodColor,
            padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          label: Row(
            children: [
              Expanded(
                child: Text(
                  '양식',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 분식 음식페이지 버튼()
    Widget SnackFoodButton() {
      return SizedBox(
        width: 280,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => deliver_fbf()));
          },
          icon: Image.asset('images/tteokbokki.png'),
          style: ElevatedButton.styleFrom(
            primary: snackFoodColor,
            padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          label: Row(
            children: [
              Expanded(
                child: Text(
                  '분식',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("오늘은 뭐 시켜먹을까?"),
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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              pd30,
              KoreanFoodButton(),
              pd50,
              ChinaFoodButton(),
              pd50,
              JapanFoodButton(),
              pd50,
              WestFoodButton(),
              pd50,
              SnackFoodButton(),
            ],
          ),
        ),
      ),
    );
  }
}
