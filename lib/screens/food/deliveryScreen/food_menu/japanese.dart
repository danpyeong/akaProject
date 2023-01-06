import 'package:aka_project/screens/food/deliveryScreen/food_type/delivery_screen_japan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class japan_menu extends StatelessWidget {
  const japan_menu({super.key});

  @override
  Widget build(BuildContext context) {
    Color backColor = const Color.fromARGB(255, 239, 208, 85);

    return Scaffold(
      appBar: AppBar(
        title: Text("일식"),
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
