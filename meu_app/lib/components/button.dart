import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  static const Color DEFAULT = Color.fromRGBO(112, 112, 112, 1);
  static const Color DARK = Color.fromRGBO(64, 64, 64, 1);
  static const Color OPERATION = Color.fromRGBO(242, 163, 60, 1);

  final String text;
  final IconData? icon;
  final bool big;
  final Color color;
  final Color textColor;
  final void Function(String) cb;
  final String? textCommand;

  const Button({
    Key? key,
    required this.text,
    this.icon,
    this.big = false,
    this.color = DEFAULT,
    this.textColor = Colors.white,
    required this.cb,
    this.textCommand,
  }) : super(key: key);

  const Button.operation({
    Key? key,
    required this.text,
    this.icon,
    this.big = false,
    this.color = DARK,
    this.textColor = Colors.white,
    required this.cb,
    this.textCommand,
  }) : super(key: key);

  const Button.icon({
    Key? key,
    this.icon,
    this.text = '',
    this.big = false,
    this.color = DARK,
    this.textColor = Colors.white,
    required this.cb,
    this.textCommand,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: big ? 2 : 1,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: textColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.all(0),
          ),
          onPressed: () => cb(textCommand ?? text),
          child: icon != null
              ? Icon(icon, color: textColor, size: 24)
              : Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: text == 'Calculate' ? 16 : 22,
                    fontWeight: FontWeight.w300,
                  ),
                ),
        ),
      ),
    );
  }
}