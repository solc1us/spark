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
    final cityName = session == null
        ? null
        : appState.cities.firstWhere((city) => city.id == session.cityId).name;
    final mallName = session == null || session.mallId == null
        ? null
        : appState
              .getMallsByCity(session.cityId)
              .firstWhere((mall) => mall.id == session.mallId)
              .name;

    Widget _detailRow(String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 135,
              child: Text(
                '$label:',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(child: Text(value, style: const TextStyle(fontSize: 17))),
          ],
        ),
      );
    }

    String _formatDate(DateTime date) {
      final localDate = date.toLocal();
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];
      final hour = localDate.hour.toString().padLeft(2, '0');
      final minute = localDate.minute.toString().padLeft(2, '0');
      return '${localDate.day} ${months[localDate.month - 1]} '
          '${localDate.year}, $hour:$minute';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Parkir',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: session == null
          ? const Center(child: Text('Sesi parkir tidak ditemukan.'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    File(session.photoPath),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      height: 200,
                      color: const Color(0xFFFFF1E8),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported_outlined,
                            size: 36,
                            color: Color(0xFFEA580C),
                          ),
                          SizedBox(height: 8),
                          Text('Foto tidak tersedia.'),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  session.placeName ?? mallName ?? 'Lokasi parkir',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _detailRow('Kota', cityName!),
                if (session.areaCode != null)
                  _detailRow('Area', session.areaCode!),
                if (session.notes != null)
                  _detailRow('Catatan', session.notes!),
                _detailRow('Waktu parkir', _formatDate(session.createdAt)),
                _detailRow(
                  'Koordinat',
                  '${session.latitude}, ${session.longitude}',
                ),
                if (session.reminderMinutes != null)
                  _detailRow('Pengingat', '${session.reminderMinutes} menit'),
                _detailRow('Status', session.status),
                if (session.completedAt != null)
                  _detailRow(
                    'Waktu selesai',
                    _formatDate(session.completedAt!),
                  ),
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
                    child: const Text(
                      'Selesai Parkir',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 134, 57, 16),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
