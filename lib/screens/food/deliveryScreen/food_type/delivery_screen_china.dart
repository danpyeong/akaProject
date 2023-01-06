import 'package:aka_project/screens/food/deliveryScreen/delivery_screen.dart';
import 'package:aka_project/screens/food/deliveryScreen/food_menu/chinese.dart';
import 'package:flutter/material.dart';

class Delivery_China extends StatelessWidget {
  const Delivery_China({super.key});

  @override
  Widget build(BuildContext context) {
    Color chinaFoodColor = const Color.fromARGB(255, 239, 172, 113);
    Color buttonColor1 = Color.fromRGBO(241, 118, 105, 1);
    Padding pd50 = const Padding(padding: EdgeInsets.only(top: 50));
    Padding pd30 = const Padding(padding: EdgeInsets.only(top: 30));

    return Scaffold(
      appBar: AppBar(
        title: Text("중식"),
        backgroundColor: chinaFoodColor,
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            verticalDirection: VerticalDirection.down,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              pd30,
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => china_menu()));
                },
                child: Text('서천각'),
                style: ElevatedButton.styleFrom(
                  primary: buttonColor1,
                  minimumSize: Size(200, 80),
                  textStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              pd50,
            ],
          ),
        ),
      ),
    );
  }
}
