import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';

class ParkingDetailPage extends StatelessWidget {
  const ParkingDetailPage({super.key, this.parkingSessionId});

  final String? parkingSessionId;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final session = appState.getParkingById(parkingSessionId ?? '');

    Widget _detailRow(String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              child: Text(
                '$label:',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(child: Text(value)),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Parkir')),
      body: session == null
          ? const Center(child: Text('Sesi parkir tidak ditemukan.'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Image.file(
                  File(session.photoPath),
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox(
                    height: 200,
                    child: Center(child: Text('Foto tidak tersedia.')),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  session.placeName ?? session.mallId ?? 'Lokasi parkir',
                  style: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _detailRow('Kota', session.cityId),
                if (session.areaCode != null)
                  _detailRow('Area', session.areaCode!),
                if (session.notes != null)
                  _detailRow('Catatan', session.notes!),
                _detailRow('Waktu parkir', session.createdAt.toString()),
                _detailRow(
                  'Koordinat',
                  '${session.latitude}, ${session.longitude}',
                ),
                if (session.reminderMinutes != null)
                  _detailRow('Pengingat', '${session.reminderMinutes} menit'),
                _detailRow('Status', session.status),
                if (session.completedAt != null)
                  _detailRow('Waktu selesai', session.completedAt.toString()),
                if (session.status == 'active')
                  ElevatedButton(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Selesaikan parkir?'),
                          content: const Text(
                            'Kendaraan sudah ditemukan dan diambil?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Selesai'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true && context.mounted) {
                        context.read<AppState>().completeParking(session.id);
                      }
                    },
                    child: const Text('Selesai Parkir'),
                  ),
              ],
            ),
    );
  }
}
