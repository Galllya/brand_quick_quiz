import 'package:brand_quick_quiz/presentation/quiz/limited_quiz_page.dart';
import 'package:flutter/material.dart';

import 'endless_quiz_page.dart';

class SelectQuizTypePage extends StatelessWidget {
  const SelectQuizTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    void openPage(Widget page) => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => page,
          ),
        );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select game type"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LimitedQuizPage(),
                  ),
                );
              },
              child: const Text("Limited game"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => openPage(const EndlessQuizPage()),
              child: const Text("Endless game"),
            ),
          ],
        ),
      ),
    );
  }
}
