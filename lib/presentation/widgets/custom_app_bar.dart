import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String name;
  final Widget? rightIcon;
  final VoidCallback? onRightIconTap;
  final bool showBack;
  const CustomAppBar({
    super.key,
    required this.name,
    this.rightIcon,
    this.onRightIconTap,
    this.showBack = false,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(60);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: AppBar(
            leading: widget.showBack
                ? GestureDetector(
                    child: Image.asset(
                      "assets/arrow.png",
                    ),
                  )
                : const SizedBox(),
            actions: [
              widget.rightIcon ?? const SizedBox(),
            ],
            toolbarHeight: 55,
            centerTitle: true,
            backgroundColor: Colors.white,
            title: Text(
              widget.name.toUpperCase(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w400,
                height: 22 / 18,
              ),
            ),
          ),
        ),
        Visibility(
          visible: true,
          child: SizedBox(
            width: double.infinity,
            child: Image.asset(
              "assets/bottom.png",
              fit: BoxFit.fill,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 10,
              top: 10,
            ),
            child: InkWell(
              onTap: widget.onRightIconTap,
              child: const SizedBox(
                height: 40,
                width: 40,
              ),
            ),
          ),
        ),
        if (widget.showBack)
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                top: 10,
              ),
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: const SizedBox(
                  height: 40,
                  width: 40,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
