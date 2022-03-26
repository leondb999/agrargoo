import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/auth_controller.dart';

class TestScreen extends ConsumerWidget {
  const TestScreen({Key? key}) : super(key: key);

  Widget build(BuildContext context, WidgetRef ref) {
    User? authControllerState = ref.watch(authControllerProvider);
    return Text("Hello");
  }
}
