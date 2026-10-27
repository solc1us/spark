import 'package:flutter/material.dart';

import '../routes/app_routes.dart';

class ConfirmLocationPage extends StatelessWidget {
  const ConfirmLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Location')),
      body: Column(
        children: [
          const Text('ConfirmLocationPage'),
          TextButton(
            onPressed: () => Navigator.popUntil(
              context,
              ModalRoute.withName(AppRoutes.home),
            ),
            child: const Text('Home'),
          ),
        ],
      ),
    );
  }
}
