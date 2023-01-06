import 'package:aka_project/screens/food/deliveryScreen/delivery_screen.dart';
import 'package:aka_project/screens/food/deliveryScreen/food_menu/western.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class deliver_west extends StatelessWidget {
  const deliver_west({super.key});

  @override
  Widget build(BuildContext context) {
    Color westFoodColor = const Color.fromRGBO(72, 241, 144, 1);
    Color buttonColor1 = Color.fromRGBO(241, 118, 105, 1);

    Padding pd50 = const Padding(padding: EdgeInsets.only(top: 50));
    Padding pd30 = const Padding(padding: EdgeInsets.only(top: 30));

    return Center(
      child: Scaffold(
        appBar: AppBar(
          title: Text("양식"),
          backgroundColor: westFoodColor,
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
                        MaterialPageRoute(builder: (context) => west_menu()));
                  },
                  child: Text('양식'),
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
      ),
    );
  }
}
