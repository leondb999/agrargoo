import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';

import '../../controllers/auth_controller.dart';

class TestScreen extends HookWidget {
  const TestScreen({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    User? authControllerState = useProvider(authControllerProvider);
    return Text("Hello");
  }
}
