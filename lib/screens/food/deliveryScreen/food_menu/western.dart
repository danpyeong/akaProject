import 'package:aka_project/screens/food/deliveryScreen/food_type/delivery_screen_west.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class west_menu extends StatelessWidget {
  const west_menu({super.key});

  @override
  Widget build(BuildContext context) {
    Color backColor = const Color.fromARGB(255, 72, 241, 144);

    return Scaffold(
      appBar: AppBar(
        title: Text("양식"),
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
