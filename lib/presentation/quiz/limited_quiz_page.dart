import 'dart:math';

import 'package:brand_quick_quiz/data/brends.dart';
import 'package:brand_quick_quiz/data/items.dart';
import 'package:brand_quick_quiz/domain/item_model.dart';
import 'package:brand_quick_quiz/presentation/quiz/limited_end_page.dart';
import 'package:brand_quick_quiz/presentation/quiz/widgets/quiz_base.dart';
import 'package:brand_quick_quiz/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LimitedQuizPage extends StatefulWidget {
  const LimitedQuizPage({super.key});

  @override
  State<LimitedQuizPage> createState() => _LimitedQuizPageState();
}

class _LimitedQuizPageState extends State<LimitedQuizPage> {
  late SharedPreferences sharedPreferences;
  int maxLimited = 0;
  int maxItems = 10;
  int currentIndex = -1;
  List<ItemModel> items = [];
  bool correctInTop = true;
  String wrongAnswer = "";
  List<String> brends = brandsAll;
  int score = 0;

  bool correct = false;
  bool wrong = false;

  // BannerAd? _bannerAd;
  @override
  void initState() {
    // _createBannerAd();

    sharedPreferences = context.read<SharedPreferences>();
    maxLimited = sharedPreferences.getInt("maxLimited") ?? 0;
    List<ItemModel> allItems = itemsAll;
    allItems.shuffle();
    items = allItems.sublist(0, maxItems);
    createLevel(isCorrect: false, fromStart: true);
    super.initState();
  }

  void createLevel({
    required bool isCorrect,
    bool fromStart = false,
  }) {
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
      wrong = true;
      setState(() {});
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          wrong = false;
        });
      });
    }
    if (currentIndex == maxItems - 1) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LimitedEndPage(
          maxResult: maxItems,
          result: score,
        ),
      ));
    } else {
      currentIndex++;
      correctInTop = Random().nextInt(2) == 1;
      wrongAnswer = getRandom();
      setState(() {});
    }
  }

  String getRandom() {
    String value = brends[Random().nextInt(brends.length)];
    while (value == items[currentIndex].brend) {
      value = brends[Random().nextInt(brends.length)];
    }
    return value;
  }

  // _createBannerAd() {
  //   _bannerAd = BannerAd(
  //     size: AdSize.banner,
  //     adUnitId: AdMobService.bannerAdUnitId,
  //     listener: AdMobService.bannerAdListener,
  //     request: const AdRequest(),
  //   )..load();
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: _bannerAd == null
      //     ? const SizedBox()
      //     : Container(
      //         margin: const EdgeInsets.only(bottom: 12),
      //         height: 52,
      //         child: AdWidget(ad: _bannerAd!),
      //       ),
      appBar: const CustomAppBar(
        name: "limited game",
        showBack: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 11),
                Text(
                  "YOUR RECORD $maxLimited/10",
                  style: const TextStyle(
                    fontSize: 12,
                    height: 14 / 12,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "CURRENT ${currentIndex + 1}/10",
                  style: const TextStyle(
                    fontSize: 12,
                    height: 14 / 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: LinearProgressBar(
              maxSteps: 10,
              progressType: LinearProgressBar.progressTypeLinear,
              currentStep: currentIndex,
              progressColor: Colors.black,
              backgroundColor: Colors.grey,
            ),
          ),
          Expanded(
            child: QuizBase(
              image: items[currentIndex].image,
              onDownTap: () {
                createLevel(isCorrect: !correctInTop);
              },
              onUpTap: () {
                createLevel(isCorrect: correctInTop);
              },
              downTitle:
                  !correctInTop ? items[currentIndex].brend : wrongAnswer,
              upTitle: correctInTop ? items[currentIndex].brend : wrongAnswer,
              itemText: items[currentIndex].type,
              correct: correct,
              wrong: wrong,
            ),
          ),
        ],
      ),
    );
  }
}
