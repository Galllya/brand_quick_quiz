import 'package:flutter/material.dart';

class HomeButton extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback onTap;
  const HomeButton({
    super.key,
    required this.title,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xffF2FFD6),
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/$image.png",
                height: 25,
              ),
              const SizedBox(width: 4),
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  height: 20 / 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
