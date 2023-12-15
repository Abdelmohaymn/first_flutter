
import 'dart:math';

import 'package:first_flutter/modules/basics/bmi_results.dart';
import 'package:flutter/material.dart';

class BmiCalculator extends StatefulWidget {
  const BmiCalculator({super.key});


  @override
  _BmiCalculator createState() => _BmiCalculator();

}

class _BmiCalculator extends State<BmiCalculator>{


  bool isMale = true;
  int height = 175;
  int weight = 75;
  int age = 25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bmi Calculator'
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          isMale = true;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: isMale? Colors.red : Colors.grey[400]
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage(
                                'assets/images/male.png'
                              ),
                              height: 90,
                              width: 90,
                              color: Colors.white,
                            ),
                            Text(
                              'MALE',
                              style: TextStyle(
                                  color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          isMale = false;
                          //print('$isMale');
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: isMale? Colors.grey[400] : Colors.red
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage(
                                  'assets/images/female.png'
                              ),
                              height: 90,
                              width: 90,
                              color: Colors.white,
                            ),
                            Text(
                                'FEMALE',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[400]
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      const Text(
                        'HEIGHT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20
                        ),
                      ),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '$height',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40
                          ),
                        ),
                        const Text(
                          'cm',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20
                          ),
                        )
                      ],
                    ),
                    Slider(
                      value: height.toDouble(),
                      max: 220,
                      min: 80,
                      activeColor: Colors.red,
                      onChanged: (value){
                        setState(() {
                          height = value.round();
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[400]
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'WEIGHT(KG)',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                           Text(
                            '$weight',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FloatingActionButton(
                                onPressed: (){
                                  setState(() {
                                    if(weight>0)weight--;
                                  });
                                },
                                backgroundColor: Colors.white,
                                shape: CircleBorder(),
                                elevation: 2,
                                mini: true,
                                child: const Icon(
                                  Icons.remove,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 8,),
                              FloatingActionButton(
                                onPressed: (){
                                  setState(() {
                                    if(weight<200)weight++;
                                  });
                                },
                                backgroundColor: Colors.white,
                                shape: CircleBorder(),
                                elevation: 2,
                                mini: true,
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[400]
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           const Text(
                            'AGE',
                            style:  TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                           Text(
                            '$age',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FloatingActionButton(
                                onPressed: (){
                                  setState(() {
                                    if(age>0)age--;
                                  });
                                },
                                backgroundColor: Colors.white,
                                shape: CircleBorder(),
                                elevation: 2,
                                mini: true,
                                child: const Icon(
                                  Icons.remove,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 8,),
                              FloatingActionButton(
                                onPressed: (){
                                  setState(() {
                                    if(age<125)age++;
                                  });
                                },
                                backgroundColor: Colors.white,
                                shape: CircleBorder(),
                                elevation: 2,
                                mini: true,
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.red,
            child: MaterialButton(
              onPressed: (){
                double result = weight/pow(height, 2);
                print(result.round());
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=>BmiResults(
                      result: result.round(),
                      isMale: isMale,
                      age: age,
                    ))
                );
              },
              child: Text(
                'CALCULATE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

}