import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes/app_routes.dart';
import '../state/app_state.dart';

class ParkingHistoryPage extends StatelessWidget {
  const ParkingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sessions = context.watch<AppState>().parkingHistory;
    return Scaffold(
      appBar: AppBar(title: const Text('Parking History')),
      body: ListView(
        children: [
          const Text('ParkingHistoryPage'),
          if (sessions.isEmpty) const Text('Belum ada riwayat parkir.'),
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
