import 'package:flutter/material.dart';
import 'package:pedro_downloads/app/core/cores.dart';

class TextFieldPrincipal extends StatelessWidget {
  const TextFieldPrincipal({
    super.key,
    required this.controller,
    required this.labelText,
    required this.icon,
    this.isReadOnly = false,
    this.onTap,
  });
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final bool isReadOnly;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(221, 151, 151, 151),
            blurRadius: 5,
            spreadRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onTap: onTap,
        readOnly: isReadOnly,
        style: const TextStyle(
          color: Cores.textAndButtonColor,
          fontSize: 10,
        ),
        decoration: InputDecoration(
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white),
          ),
          constraints: const BoxConstraints(
            maxWidth: 350,
            maxHeight: 30,
          ),
          labelText: labelText,
          labelStyle: const TextStyle(
            color: Cores.textAndButtonColor,
            fontSize: 10,
          ),
          filled: true,
          fillColor: const Color(0xFFe1e3e2),
          suffixIcon: Container(
            margin: const EdgeInsets.all(5),
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child: Center(
              child: Icon(
                icon,
                size: 12,
                color: Cores.textAndButtonColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
