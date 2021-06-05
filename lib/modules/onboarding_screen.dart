import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/models/onboard_model.dart';
import 'package:shop_app/modules/login_screen.dart';
import 'package:shop_app/shared/components/defaults.dart';
import 'package:shop_app/shared/networks/local/cache_helper.dart';
import 'package:shop_app/shared/styles/constants.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List<OnboardModel> onBoard = [
    OnboardModel("assets/images/onboard_1.jpg", "Board Title 1", "Body1"),
    OnboardModel("assets/images/onboard_1.jpg", "Board Title 2", "Body2"),
    OnboardModel("assets/images/onboard_1.jpg", "Board Title 3", "Body3"),
  ];

  PageController onBoardController = PageController();
  bool isLast = false;
  void submit() {
    CacheHelper.setData(key: "onBoarding", value: true).then((value) {
      if (value = true) {
        navigateToAndFinish(context: context, page: LoginScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          defaultTextButton(
              function: () {
                submit();
              },
              text: "skip")
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  onPageChanged: (value) {
                    if (value == onBoard.length - 1) {
                      setState(() {
                        isLast = true;
                      });
                    } else {
                      setState(() {
                        isLast = false;
                      });
                    }
                  },
                  controller: onBoardController,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) =>
                      buildOnboardItem(onBoard[index], context),
                  itemCount: onBoard.length,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  SmoothPageIndicator(
                    controller: onBoardController,
                    count: onBoard.length,
                    effect: ExpandingDotsEffect(
                        activeDotColor: appColor, expansionFactor: 3),
                  ),
                  Spacer(),
                  FloatingActionButton(
                    onPressed: () {
                      if (isLast) {
                        submit();
                      } else {
                        onBoardController.nextPage(
                            duration: Duration(milliseconds: 750),
                            curve: Curves.fastLinearToSlowEaseIn);
                      }
                    },
                    child: Icon(Icons.arrow_forward_ios),
                  )
                ],
              )
            ],
          )),
    );
  }
}

Widget buildOnboardItem(OnboardModel model, context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Image(
              image: AssetImage(
            "${model.img}",
          )),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "${model.title}",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        SizedBox(
          height: 10,
        ),
        Text("${model.body}")
      ],
    );
