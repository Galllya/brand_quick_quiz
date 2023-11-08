import 'package:flutter/material.dart';

class QuizButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const QuizButton({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: const Color(0xffF2FFD6),
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 22),
              child: Center(
                child: Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    height: 20 / 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
