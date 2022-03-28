import 'package:agrargo/UI/login/profile_page.dart';
import 'package:agrargo/UI/pages/1_a_landing_page_christina.dart';
import 'package:agrargo/UI/pages/5_chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../UI/error_screen.dart';
import '../UI/pages/1_landing_page.dart';
import '../UI/loading_screen.dart';
import '../UI/login/login_page.dart';
import '../providers/auth_providers.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({Key? key}) : super(key: key);

  //  Notice here we aren't using stateless/statefull widget. Instead we are using
  //  a custom widget that is a consumer of the state.
  //  So if any data changes in the state, the widget will be updated.

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //  now the build method takes a new paramaeter ScopeReader.
    //  this object will be used to access the provider.

    //  now the following variable contains an asyncValue so now we can use .when method
    //  to imply the condition
    final AsyncValue<User?> _user = ref.watch(authStateProvider);
    return _user.when(
        data: (data) {
          if (data != null) {
            print("User Logged In | User Name: ${_user.value!.displayName}");
            return LandingPageCh();
          }
          print("User Logged Out!");
          return LandingPageCh();
        },
        loading: () => const LoadingScreen(),
        error: (e, trace) => ErrorScreen(e, trace));
  }
}
