import 'dart:async';
import 'dart:math';

import 'package:brand_quick_quiz/data/brends.dart';
import 'package:brand_quick_quiz/data/items.dart';
import 'package:brand_quick_quiz/domain/item_model.dart';
import 'package:brand_quick_quiz/presentation/quiz/endless_end_page.dart';
import 'package:brand_quick_quiz/presentation/quiz/limited_end_page.dart';
import 'package:brand_quick_quiz/presentation/quiz/widgets/quiz_base.dart';
import 'package:brand_quick_quiz/presentation/widgets/ads.dart';
import 'package:brand_quick_quiz/presentation/widgets/custom_app_bar.dart';
import 'package:brand_quick_quiz/style/colors.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:circular_countdown_timer/countdown_text_format.dart';
import 'package:flutter/material.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EndlessQuizPage extends StatefulWidget {
  const EndlessQuizPage({super.key});

  @override
  State<EndlessQuizPage> createState() => _EndlessQuizPageState();
}

class _EndlessQuizPageState extends State<EndlessQuizPage> {
  int maxEndLess = 0;
  late SharedPreferences sharedPreferences;

  int maxItems = 10;
  List<ItemModel> items = itemsAll;
  bool correctInTop = true;
  String wrongAnswer = "";
  List<String> brends = brandsAll;
  int score = 0;

  int lives = 3;
  late ItemModel currectItemModel;

  bool correct = false;
  bool wrong = false;

  late Timer _timer;
  int _start = 3;

  bool lose = false;

  CountDownController countDownController = CountDownController();

  @override
  void initState() {
    sharedPreferences = context.read<SharedPreferences>();
    maxEndLess = sharedPreferences.getInt("maxEndLess") ?? 0;
    startTimer();

    createLevel(isCorrect: false, fromStart: true);
    super.initState();
  }

  void startTimer() {
    if (!lose) {
      _start = 3;
      // countDownController.start();
      countDownController.restart();
      // countDownController.resume();

      const oneSec = Duration(seconds: 1);
      _timer = Timer.periodic(
        oneSec,
        (Timer timer) {
          if (_start == 0) {
            setState(() {
              timer.cancel();
              lives--;
              if (lives == 0) {
                print("LOSE");
                onLose();
              } else {
                startTimer();
                createLevel(isCorrect: false, fromStart: true);
              }
            });
          } else {
            setState(() {
              _start--;
            });
          }
        },
      );
    }
  }

  void onLose() async {
    setState(() {
      lose = true;
    });
    countDownController.restart();
    countDownController.pause();

    AlertDialog alert = AlertDialog(
      title: const Text("You lose"),
      content: Row(
        children: [
          Flexible(
            flex: 3,
            child: ElevatedButton(
              onPressed: () async {
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                    builder: (context) => const Ads(),
                  ),
                )
                    .then((value) {
                  Navigator.pop(context);

                  setState(() {
                    lives = 1;
                    countDownController = CountDownController();

                    lose = false;
                  });
                  createLevel(isCorrect: false, fromStart: true);
                });
              },
              child: const Text("Watch ads and continue"),
            ),
          ),
          Flexible(
            flex: 1,
            child: TextButton(
              onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EndlessEndPage(
                      score: (score).toString(),
                    ),
                  )),
              child: const Text(
                "Finish",
                style: TextStyle(color: AppColors.mainColor),
              ),
            ),
          ),
        ],
      ),
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void createLevel({
    required bool isCorrect,
    bool fromStart = false,
  }) {
    if (_timer.isActive) {
      _timer.cancel();
    }
    startTimer();

    if (isCorrect) {
      score++;

      correct = true;
      setState(() {});
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          correct = false;
        });
      });
    } else if (!fromStart) {
      lives--;
      wrong = true;
      setState(() {});
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          wrong = false;
        });
      });
    }
    if (lives == 0) {
      onLose();
    } else {
      currectItemModel = items[Random().nextInt(items.length)];
      correctInTop = Random().nextInt(2) == 1;
      wrongAnswer = getRandom();
      setState(() {});
    }
  }

  String getRandom() {
    String value = brends[Random().nextInt(brends.length)];
    while (value == currectItemModel.brend) {
      value = brends[Random().nextInt(brends.length)];
    }
    return value;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        name: "endless game",
        showBack: true,
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(
          //     left: 20,
          //     right: 20,
          //     top: 60,
          //     bottom: 10,
          //   ),
          //   child: SizedBox(
          //     height: 30,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: lose
          //           ? [
          //               const SizedBox(),
          //               const Center(
          //                 child: Text(
          //                   "LOSE",
          //                   style: TextStyle(
          //                     fontSize: 20,
          //                   ),
          //                 ),
          //               ),
          //               const SizedBox(),
          //             ]
          //           : [
          //               Row(
          //                 children: [
          //                   const SizedBox(height: 20),
          //                   for (int i = 0; i < lives; i++)
          //                     Image.asset(
          //                       "assets/heart.png",
          //                       height: 20,
          //                       width: 20,
          //                     ),
          //                 ],
          //               ),
          //               CircularCountDownTimer(
          //                 duration: 3,
          //                 initialDuration: 0,
          //                 controller: countDownController,
          //                 width: 40,
          //                 height: 40,
          //                 ringColor: Colors.grey[300]!,
          //                 ringGradient: null,
          //                 fillColor: Colors.black,
          //                 fillGradient: null,
          //                 backgroundColor: Colors.transparent,
          //                 backgroundGradient: null,
          //                 strokeWidth: 3,
          //                 strokeCap: StrokeCap.round,
          //                 textStyle: const TextStyle(
          //                     fontSize: 10,
          //                     color: Colors.white,
          //                     fontWeight: FontWeight.bold),
          //                 textFormat: CountdownTextFormat.S,
          //                 isReverse: false,
          //                 isReverseAnimation: false,
          //                 isTimerTextShown: true,
          //                 autoStart: true,
          //                 timeFormatterFunction:
          //                     (defaultFormatterFunction, duration) {
          //                   return "";
          //                 },
          //               ),
          //             ],
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int i = 0; i < 3; i++)
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Image.asset(
                          "assets/${i < lives ? "heard" : "empty_heard"}.png",
                          height: 20,
                          width: 20,
                        ),
                      ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 11),
                    Text(
                      "YOUR RECORD $maxEndLess",
                      style: const TextStyle(
                        fontSize: 12,
                        height: 14 / 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "CURRENT ${score + 1}",
                      style: const TextStyle(
                        fontSize: 12,
                        height: 14 / 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: LinearProgressBar(
              maxSteps: 3,
              progressType: LinearProgressBar.progressTypeLinear,
              currentStep: _start,
              progressColor: Colors.black,
              backgroundColor: Colors.grey,
            ),
          ),
          Expanded(
            child: QuizBase(
              image: currectItemModel.image,
              loop: true,
              onDownTap: lose
                  ? () {}
                  : () {
                      createLevel(isCorrect: !correctInTop);
                    },
              onUpTap: lose
                  ? () {}
                  : () {
                      createLevel(isCorrect: correctInTop);
                    },
              downTitle: !correctInTop ? currectItemModel.brend : wrongAnswer,
              upTitle: correctInTop ? currectItemModel.brend : wrongAnswer,
              itemText: currectItemModel.type,
              correct: correct,
              wrong: wrong,
            ),
          ),
        ],
      ),
    );
  }
}
