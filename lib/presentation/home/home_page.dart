import 'package:brand_quick_quiz/presentation/home/widgets/home_button.dart';
import 'package:brand_quick_quiz/presentation/home/widgets/user_info.dart';
import 'package:brand_quick_quiz/presentation/quiz/endless_quiz_page.dart';
import 'package:brand_quick_quiz/presentation/quiz/limited_quiz_page.dart';
import 'package:brand_quick_quiz/presentation/quiz/select_quiz_type_page.dart';
import 'package:brand_quick_quiz/presentation/results/results_page.dart';
import 'package:brand_quick_quiz/presentation/settings/settings_page.dart';
import 'package:brand_quick_quiz/presentation/widgets/ads.dart';
import 'package:brand_quick_quiz/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';

import '../leaderboard/leaderboard_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void openPage(Widget page) => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => page,
        ),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        name: 'brand quiz',
        rightIcon: AbsorbPointer(
          child: Image.asset(
            "assets/share.png",
          ),
        ),
        onRightIconTap: () {
          Share.share(
            'I invite you to the Brand Quick Quiz: https://play.google.com/store/apps/details?id=com.brandquickgame.quizplay',
          );
        },
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
          return false;
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            children: [
              const SizedBox(height: 10),
              const UserInfo(),
              const SizedBox(height: 20),
              const ResultsPage(),
              const SizedBox(height: 70),
              HomeButton(
                image: 'limited',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LimitedQuizPage(),
                    ),
                  );
                },
                title: 'limited game',
              ),
              const SizedBox(height: 11),
              HomeButton(
                image: 'endless',
                onTap: () => openPage(const EndlessQuizPage()),
                title: 'endless game',
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () => openPage(const LeaderboardPage()),
                  child: const Text(
                    "leaderboard",
                    style: TextStyle(
                      fontSize: 16,
                      height: 20 / 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
