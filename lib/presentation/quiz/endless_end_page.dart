import 'package:brand_quick_quiz/presentation/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EndlessEndPage extends StatefulWidget {
  final String score;
  const EndlessEndPage({
    super.key,
    required this.score,
  });

  @override
  State<EndlessEndPage> createState() => _EndlessEndPageState();
}

class _EndlessEndPageState extends State<EndlessEndPage> {
  late SharedPreferences sharedPreferences;
  @override
  void initState() {
    sharedPreferences = context.read<SharedPreferences>();

    int lateMaxLimited = sharedPreferences.getInt("maxEndLess") ?? 0;
    if (lateMaxLimited < int.parse(widget.score)) {
      sharedPreferences.setInt("maxEndLess", int.parse(widget.score));
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
                "You scored ${widget.score} points",
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
