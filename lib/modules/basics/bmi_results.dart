
import 'package:flutter/material.dart';

class BmiResults extends StatelessWidget{

  final int result;
  final bool isMale;
  final int age;

  BmiResults({
    required this.result,
    required this.isMale,
    required this.age,
});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bmi Results'
        ),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Gender : ${isMale?'Male':'Female'}'
            ),
            Text(
              'Result : $result'
            ),
            Text(
              'Age : $age'
            )
          ],
        ),
      ),
    );
  }

}