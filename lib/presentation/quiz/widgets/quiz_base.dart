import 'package:brand_quick_quiz/presentation/quiz/widgets/choice_container.dart';
import 'package:brand_quick_quiz/presentation/quiz/widgets/quiz_button.dart';
import 'package:brand_quick_quiz/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:swipe/swipe.dart';

class QuizBase extends StatefulWidget {
  final VoidCallback onUpTap;
  final VoidCallback onDownTap;
  final String upTitle;
  final String downTitle;
  final String itemText;
  final bool correct;
  final bool wrong;
  final bool loop;
  final String image;

  const QuizBase({
    required this.onDownTap,
    required this.onUpTap,
    required this.downTitle,
    required this.upTitle,
    required this.itemText,
    required this.correct,
    required this.wrong,
    this.loop = false,
    required this.image,
    super.key,
  });

  @override
  State<QuizBase> createState() => _QuizBaseState();
}

class _QuizBaseState extends State<QuizBase> {
  CardSwiperController cardSwiperController = CardSwiperController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CardSwiper(
            controller: cardSwiperController,
            numberOfCardsDisplayed: 1,
            isLoop: widget.loop,
            allowedSwipeDirection: AllowedSwipeDirection.symmetric(
              horizontal: true,
            ),
            cardsCount: 10,
            onSwipe: (previousIndex, currentIndex, direction) async {
              if (direction == CardSwiperDirection.left) {
                widget.onUpTap();
              } else {
                widget.onDownTap();
              }
              return true;
            },
            cardBuilder:
                (context, index, percentThresholdX, percentThresholdY) =>
                    DecoratedBox(
              decoration: BoxDecoration(
                color: widget.correct
                    ? Colors.green
                    : widget.wrong
                        ? Colors.red
                        : const Color(0xffD3D3D3),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black,
                ),
              ),
              child: Center(
                child: widget.correct
                    ? const Text(
                        "Correct",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      )
                    : widget.wrong
                        ? const Text(
                            "Wrong",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    widget.image,
                                    height: 160,
                                    width: 160,
                                    fit: BoxFit.contain,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 36,
                                  vertical: 2,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset(
                                      "assets/left_arrow.png",
                                      height: 40,
                                    ),
                                    Image.asset(
                                      "assets/right_arrow.png",
                                      height: 40,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              QuizButton(
                onTap: () => widget.onUpTap(),
                title: widget.upTitle,
              ),
              const SizedBox(width: 4),
              QuizButton(
                onTap: () => widget.onDownTap(),
                title: widget.downTitle,
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        const SizedBox(height: 13),
      ],
    );

    Swipe(
      onSwipeUp: widget.onUpTap,
      onSwipeDown: widget.onDownTap,
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.black.withOpacity(0.8),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ChoiceContainer(
                  title: widget.upTitle,
                  onTap: widget.onUpTap,
                ),
                Center(
                  child: CircleAvatar(
                    radius: 120,
                    backgroundColor: widget.correct
                        ? Colors.green
                        : widget.wrong
                            ? Colors.red
                            : AppColors.mainColor,
                    child: widget.correct
                        ? const Text(
                            "Correct",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          )
                        : widget.wrong
                            ? const Text(
                                "Wrong",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/sneakers.png",
                                    height: 100,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    widget.itemText,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                  ),
                ),
                ChoiceContainer(
                  title: widget.downTitle,
                  onTap: widget.onDownTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
