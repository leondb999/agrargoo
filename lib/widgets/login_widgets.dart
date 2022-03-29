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
        switch (validateString) {
          case 'name':
            if (value!.isEmpty) {
              return 'Name is empty';
            }
            return null;
          case 'email':
            if (value!.isEmpty || !value.contains('@')) {
              return 'Invalid email!';
            }
            return null;
          case 'password':
            if (value!.isEmpty || value.length < 8) {
              return 'Password is too short!';
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
