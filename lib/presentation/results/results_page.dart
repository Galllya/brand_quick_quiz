import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  int maxLimited = 0;
  int maxEndLess = 0;

  late SharedPreferences sharedPreferences;
  @override
  void initState() {
    sharedPreferences = context.read<SharedPreferences>();
    maxLimited = sharedPreferences.getInt("maxLimited") ?? 0;
    maxEndLess = sharedPreferences.getInt("maxEndLess") ?? 0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        maxLimited == 0
            ? Text(
                "you didn't score any points in limired game",
                style: _getResultTextStyle(),
              )
            : Text(
                "your max score in limired game: $maxLimited points",
                style: _getResultTextStyle(),
              ),
        const SizedBox(height: 4),
        maxEndLess == 0
            ? Text(
                "you didn't score any points in endless game",
                style: _getResultTextStyle(),
              )
            : Text(
                "your max score in endless game: $maxEndLess points",
                style: _getResultTextStyle(),
              ),
      ],
    );
  }
}

TextStyle _getResultTextStyle() => TextStyle(
      color: Colors.black.withOpacity(0.5),
      fontSize: 12,
      height: 14 / 12,
    );
