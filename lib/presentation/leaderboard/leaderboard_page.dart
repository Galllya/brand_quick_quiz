import 'package:brand_quick_quiz/data/lederboard.dart';
import 'package:brand_quick_quiz/domain/lidetboard_model.dart';
import 'package:brand_quick_quiz/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  late List<LiderboardModel> liderboard;
  late SharedPreferences sharedPreferences;
  int lateMaxLimited = 0;
  int userPosition = -1;

  late List<LiderboardModel> liderboardFrom;

  @override
  void initState() {
    liderboard = [];
    liderboard = getLiderboard();
    liderboardFrom = liderboard;
    sharedPreferences = context.read<SharedPreferences>();
    lateMaxLimited = sharedPreferences.getInt("maxEndLess") ?? 0;
    String name = sharedPreferences.getString("name") ?? "";

    if (lateMaxLimited > liderboard.last.score) {
      userPosition = liderboard.indexOf(
          liderboard.firstWhere((element) => element.score < lateMaxLimited));
      liderboardFrom.insert(
        userPosition,
        LiderboardModel(name: name == "" ? "YOU" : name, score: lateMaxLimited),
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    if (userPosition != -1) {
      liderboardAll.removeAt(userPosition);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        showBack: true,
        name: 'leaderboard',
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        children: [
          const SizedBox(height: 44),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "   ",
                  ),
                  SizedBox(width: 6),
                  Text(
                    "USERNAME",
                    style: TextStyle(
                      fontSize: 18,
                      height: 22 / 18,
                    ),
                  ),
                ],
              ),
              Text(
                "SCORE",
                style: TextStyle(
                  fontSize: 18,
                  height: 22 / 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 33),
          for (int i = 0;
              i < (userPosition == -1 ? liderboard.length : 11);
              i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              "${(i + 1)}.",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: i == userPosition
                                    ? FontWeight.w900
                                    : FontWeight.w400,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                liderboard[i].name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: i == userPosition
                                      ? FontWeight.w900
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        liderboardFrom[i].score.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: i == userPosition
                              ? FontWeight.w900
                              : FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    color: const Color(0xffDCDCDC),
                    height: 1,
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),
          if (userPosition == -1)
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Text(
                "Your result is $lateMaxLimited and you are not yet included in the rating :(",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  height: 22 / 18,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
