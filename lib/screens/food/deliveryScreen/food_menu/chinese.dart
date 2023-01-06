import 'package:aka_project/screens/food/deliveryScreen/food_type/delivery_screen_china.dart';
import 'package:flutter/material.dart';

class china_menu extends StatelessWidget {
  const china_menu({super.key});

  @override
  Widget build(BuildContext context) {
    Color backColor = Color.fromARGB(255, 239, 172, 113);

    return Scaffold(
      appBar: AppBar(
        title: Text("서천각"),
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
          child: SizedBox(
            width: 800,
            height: 600,
            child: Image.asset('images/chinafood.png'),
          ),
        ),
      ),
    );
  }
}
