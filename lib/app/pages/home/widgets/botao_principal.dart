import 'package:flutter/material.dart';

class BotaoPrincipal extends StatelessWidget {
  const BotaoPrincipal({
    super.key,
    required this.text,
    required this.textColor,
    required this.onTap,
    required this.color,
    required this.borderColor,
    this.hasShadow = true,
  });
  final String text;
  final Color textColor;
  final Function()? onTap;
  final Color color;
  final Color borderColor;
  final bool hasShadow;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: onTap,
      child: Container(
        width: 110,
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: hasShadow
              ? const [
                  BoxShadow(
                    color: Color.fromARGB(221, 151, 151, 151),
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: Offset(0, 3),
                  ),
                ]
              : null,
          color: color,
          border: Border.all(
            color: borderColor,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
