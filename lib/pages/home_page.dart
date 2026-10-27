import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes/app_routes.dart';
import '../state/app_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final sessions = appState.activeSessions;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          TextButton(
            onPressed: () {
              appState.logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (_) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
      body: ListView(
        children: [
          const Text('HomePage'),
          TextButton(
            onPressed: () {
              appState.startParkingDraft();
              Navigator.pushNamed(context, AppRoutes.addParking);
            },
            child: const Text('Add Parking'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.parkingHistory),
            child: const Text('Parking History'),
          ),
          if (sessions.isEmpty) const Text('Belum ada parkir aktif.'),
          for (final session in sessions)
            ListTile(
              title: Text(session.id),
              subtitle: Text(
                session.placeName ?? session.mallId ?? session.cityId,
              ),
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.parkingDetail,
                arguments: session.id,
              ),
            ),
        ],
      ),
    );
  }
}
