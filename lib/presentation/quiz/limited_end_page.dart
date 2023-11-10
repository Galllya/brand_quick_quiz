import 'package:brand_quick_quiz/presentation/home/home_page.dart';
import 'package:brand_quick_quiz/presentation/widgets/ads.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LimitedEndPage extends StatefulWidget {
  final int result;
  final int maxResult;
  const LimitedEndPage({
    super.key,
    required this.result,
    required this.maxResult,
  });

  @override
  State<LimitedEndPage> createState() => _LimitedEndPageState();
}

class _LimitedEndPageState extends State<LimitedEndPage> {
  late SharedPreferences sharedPreferences;
  @override
  void initState() {
    sharedPreferences = context.read<SharedPreferences>();

    int lateMaxLimited = sharedPreferences.getInt("maxLimited") ?? 0;
    if (lateMaxLimited < widget.result) {
      sharedPreferences.setInt("maxLimited", widget.result);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Text(
                "You scored ${widget.result} out of ${widget.maxResult}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 30),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  ),
                  child: const Text(
                    "Home",
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
