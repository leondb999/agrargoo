import 'package:agrargo/UI/login_riverpod/test_screen.dart';
import 'package:agrargo/controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:flutterfire_ui/database.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:flutterfire_ui/i10n.dart';

Container customTextFormField({
  required TextEditingController controller,
  TextInputType? textInputType,
  required String? hintText,
  required Icon icon,
  required String validateString,
  required bool obscureText,
  required bool autocorrect,
  required bool enableSuggestions,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(25)),
    child: TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: textInputType,
      autocorrect: autocorrect,
      validator: (value) {
        /// Validate Input
        switch (validateString) {
          case 'name':
            if (value!.isEmpty) {
              return 'Name can\'t be empty';
            }
            return null;
          case 'email':
            RegExp emailRegExp = RegExp(
                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
            //if (value!.isEmpty || !value.contains('@')) {
            //return 'Enter a invalid Email';}
            if (value!.isEmpty) {
              return 'Email can\'t be emptyy';
            } else if (!emailRegExp.hasMatch(value)) {
              return 'Enter a correct email';
            }
            return null;
          case 'password':
            if (value!.isEmpty) {
              return 'Password can\'t be empty';
            } else if (value.length < 8) {
              return 'Enter a password with length at least 8';
            }
            return null;
        }
      },
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black54),
        icon: icon,
        alignLabelWithHint: true,
        border: InputBorder.none,
      ),
    ),
  );
}
