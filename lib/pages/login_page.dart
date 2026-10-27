import 'package:flutter/material.dart';

import '../routes/app_routes.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Column(
        children: [
          const Text('LoginPage'),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.home),
            child: const Text('Home'),
          ),
        ],
      ),
    );
  }
}
