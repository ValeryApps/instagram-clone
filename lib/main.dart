import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_val/state/posts/is_loading_provider.dart';
import 'package:insta_val/views/components/loading/loading_screen.dart';

import 'firebase_options.dart';
import 'state/auth/providers/auth_state_provider.dart';
import 'state/auth/providers/is_logged_in_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),

      home: Consumer(
        builder: ((context, ref, child) {
          final isLoggedIn = ref.watch(isLoggedInProvider);
          ref.listen<bool>(isLoadingProvider, (_, loading) {
            if (loading) {
              LoadingScreen.instance().show(
                  context: context,
                  text: isLoggedIn ? "Logging out" : "Logging in");
            } else {
              LoadingScreen.instance().hide();
            }
          });
          return isLoggedIn ? const MainView() : const LoginView();
        }),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        indicatorColor: Colors.blueGrey,
      ),
      // themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Main View"),
      ),
      body: Center(
          child: Column(children: [
        const Text("Welcome to MainView"),
        Consumer(
          builder: ((_, ref, child) => TextButton(
                onPressed: () async {
                  await ref.read(authStateProvider.notifier).logOut();
                },
                child: const Text("Log out"),
              )),
        ),
      ])),
    );
  }
}

class LoginView extends ConsumerWidget {
  const LoginView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Login View"),
      ),
      body: Column(children: [
        TextButton(
            onPressed: ref.read(authStateProvider.notifier).loginWithGoogle,
            child: const Text("Sign in with Google")),
        TextButton(
            onPressed: ref.read(authStateProvider.notifier).loginWithFaceBook,
            child: const Text("Sign in with Facebook")),
      ]),
    );
  }
}
