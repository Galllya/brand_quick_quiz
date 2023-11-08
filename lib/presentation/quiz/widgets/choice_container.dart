import 'package:flutter/material.dart';

class ChoiceContainer extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const ChoiceContainer({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.black,
            )),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            title,
          ),
        ),
      ),
    );
  }
}
