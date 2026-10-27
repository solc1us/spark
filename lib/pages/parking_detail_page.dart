import 'package:flutter/material.dart';

class ParkingDetailPage extends StatelessWidget {
  const ParkingDetailPage({super.key, this.parkingSessionId});

  final String? parkingSessionId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parking Detail')),
      body: Center(
        child: Text(
          'ParkingDetailPage: ${parkingSessionId ?? "ID belum dipilih"}',
        ),
      ),
    );
  }
}
