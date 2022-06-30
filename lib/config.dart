import 'package:flutter/material.dart';

class AppConfig {}

class Button extends StatelessWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final Widget? child;

  late final EdgeInsets? padding;

  Button({
    Key? key,
    this.onPressed,
    this.onLongPress,
    this.padding,
    required this.child,
  }) : super(key: key) {
    padding ??= const EdgeInsets.all(8);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding!,
      child: ElevatedButton(
        key: key,
        onPressed: onPressed,
        onLongPress: onLongPress,
        style: ButtonStyle(
          // backgroundColor: MaterialStateProperty.resolveWith(
          //   (states) => Colors.black,
          // ),
          // foregroundColor: MaterialStateProperty.resolveWith(
          //   (states) => Colors.white,
          // ),
          padding: MaterialStateProperty.resolveWith(
            (states) => const EdgeInsets.all(8),
          ),
          alignment: Alignment.center,
        ),
        child: child,
      ),
    );
  }
}
