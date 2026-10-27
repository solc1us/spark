import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';

class ParkingDetailPage extends StatelessWidget {
  const ParkingDetailPage({super.key, this.parkingSessionId});

  final String? parkingSessionId;

  @override
  Widget build(BuildContext context) {
    final session = context.watch<AppState>().getParkingById(
      parkingSessionId ?? '',
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Parking Detail')),
      body: session == null
          ? const Center(child: Text('Sesi parkir tidak ditemukan.'))
          : Column(
              children: [
                const Text('ParkingDetailPage'),
                Text(session.id),
                Text(session.status),
                Text(session.placeName ?? session.mallId ?? session.cityId),
              ],
            ),
    );
  }
}
