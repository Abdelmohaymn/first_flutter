
import 'package:first_flutter/modules/shop_app/login/shop_login.dart';
import 'package:first_flutter/modules/social_app/login/social_login.dart';
import 'package:first_flutter/shared/components/components.dart';
import 'package:first_flutter/shared/network/local/shared_pref_helper.dart';
import 'package:first_flutter/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel {
  final String image;
  final String title;
  final String body;

  BoardingModel({
    required this.image,
    required this.title,
    required this.body,
  });
}

class OnboardingScreen extends StatefulWidget{
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  List<BoardingModel> list = [
    BoardingModel(
        image: 'assets/images/onboarding_1.jpg',
        title: 'Get in touch with the world',
        body: ''
    ),
    BoardingModel(
        image: 'assets/images/onboarding_2.jpg',
        title: 'Chat with your friends',
        body: ''
    ),
    BoardingModel(
        image: 'assets/images/onboarding_3.jpg',
        title: 'Talk to your family',
        body: ''
    ),
  ];

  var boardController = PageController();

  bool isLast = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          defaultTextButton(
            onClick:(){
              finishOnBoarding();
            },
            text: 'SKIP'
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: boardController,
                itemBuilder: (context,index)=>onBoardingItem(list[index],context),
                itemCount: 3,
                onPageChanged: (index){
                  if(index == list.length-1) {
                    isLast=true;
                  } else {
                    isLast=false;
                  }
                  setState(() {

                  });
                },
              ),
            ),
            const SizedBox(height: 40,),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: boardController,
                  count: list.length,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: defaultColor,
                    dotHeight: 10,
                    dotWidth: 10,
                    spacing: 5,
                    expansionFactor: 4
                  ),
                ),
                const Spacer(),
                FloatingActionButton(
                  onPressed:(){
                    if(isLast){
                      finishOnBoarding();
                    }else{
                      boardController.nextPage(
                          duration: const Duration(
                              microseconds: 400
                          ),
                          curve: Curves.fastLinearToSlowEaseIn,
                      );
                    }
                  },
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                )
              ],
            )
          ],
        ),
      ) ,
    );
  }

  void finishOnBoarding(){
    SharedPrefHelper.saveData(key: 'onBoarding', value: false).then((value) => {
      NavigateWithoutBack(context, SocialLoginScreen())
    });
  }

  Widget onBoardingItem(BoardingModel model,context) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Image(
            image: AssetImage(model.image),
            fit: BoxFit.cover,)
          ),
          Text(
            model.title,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15,),
          Text(
            model.body,
            style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30,),
        ],
      );
}