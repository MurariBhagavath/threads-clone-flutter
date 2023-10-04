// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class AuthInput extends StatelessWidget {
  const AuthInput({
    super.key,
    required this.textController,
    required this.hint,
    required this.icon,
  });
  final String hint;
  final TextEditingController textController;
  final Icon icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6),
      margin: EdgeInsets.fromLTRB(24, 0, 24, 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromRGBO(255, 255, 255, 0.3)),
      child: TextField(
        controller: textController,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          prefixIcon: icon,
          prefixIconColor: Colors.white,
        ),
        cursorColor: Colors.white,
      ),
    );
  }
}
