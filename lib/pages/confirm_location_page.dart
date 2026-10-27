import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes/app_routes.dart';
import '../state/app_state.dart';

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
            onPressed: () {
              context.read<AppState>().clearParkingDraft();
              Navigator.popUntil(context, ModalRoute.withName(AppRoutes.home));
            },
            child: const Text('Home'),
          ),
        ],
      ),
    );
  }
}
