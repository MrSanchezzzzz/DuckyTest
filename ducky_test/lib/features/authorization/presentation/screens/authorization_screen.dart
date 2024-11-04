
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../providers/auth_provider.dart';

class AuthorizationScreen extends ConsumerWidget {
  final emailController = TextEditingController();
  final tokenController = TextEditingController();

  AuthorizationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    authState.whenData((user) {
      if (user != null) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                  username: user.displayName,
                  email: user.email),
            ),
          );
        });
      }
    });
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/jira-logo-gradient-blue-attribution_rgb@2x.png',
                fit:BoxFit.scaleDown,
                width: MediaQuery.of(context).size.width*0.75,
            ),
            const SizedBox(height: 12,),
            TextField(
              controller: emailController,
              decoration:
                  const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 8,),
            TextField(
              controller: tokenController,
              decoration:
                  const InputDecoration(labelText: 'API Token'),
              obscureText: true,
            ),
            authState.when(
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text(e.toString(),
                  style: const TextStyle(color: Colors.red)),
              data: (_) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.3,
              child: ElevatedButton(
                onPressed: () async {
                  String email = emailController.text;
                  String token = tokenController.text;
                  await ref
                      .read(authProvider.notifier)
                      .login(email, token);
                },
                child: const Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
