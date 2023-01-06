import 'package:aka_project/screens/main_screen.dart';
import 'package:flutter/material.dart';

class foodlist extends StatelessWidget {
  const foodlist({super.key});

  @override
  Widget build(BuildContext context) {
    Color bc = Color.fromARGB(255, 85, 216, 140);
    return Scaffold(
      appBar: AppBar(
        title: Text("이번주 학식"),
        backgroundColor: bc,
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
            child: Image.asset('images/meal.jpg'),
          ),
        ),
      ),
    );
  }
}
