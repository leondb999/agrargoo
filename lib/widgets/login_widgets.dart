import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
              return 'Name darf nicht leer sein';
            }
            return null;
          case 'email':
            RegExp emailRegExp = RegExp(
                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
            //if (value!.isEmpty || !value.contains('@')) {
            //return 'Enter a invalid Email';}
            if (value!.isEmpty) {
              return 'E-Mail darf nicht leer sein';
            } else if (!emailRegExp.hasMatch(value)) {
              return 'Gib eine korrekte E-Mailadresse ein';
            }
            return null;
          case 'password':
            if (value!.isEmpty) {
              return 'Passwort darf nicht leer sein';
            } else if (value.length < 8) {
              return 'Dein Passwort muss mind. 8 Zeichen lang sein';
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
