import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';

class ConfirmLocationPage extends StatefulWidget {
  const ConfirmLocationPage({super.key});

  @override
  State<ConfirmLocationPage> createState() => _ConfirmLocationPageState();
}

class _ConfirmLocationPageState extends State<ConfirmLocationPage> {
  bool _isLoading = true;
  double? _latitude;
  double? _longitude;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _captureLocation();
  }

  Future<void> _captureLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    Position? position;
    String? errorMessage;
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        errorMessage =
            'GPS atau layanan lokasi nonaktif. Aktifkan melalui pengaturan '
            'perangkat, lalu coba lagi.';
      } else {
        var permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }

        if (permission == LocationPermission.denied) {
          errorMessage =
              'Izin lokasi ditolak. Izinkan akses lokasi, lalu coba lagi.';
        } else if (permission == LocationPermission.deniedForever) {
          errorMessage =
              'Izin lokasi ditolak permanen. Aktifkan izin melalui '
              'Pengaturan > Aplikasi > Spark > Izin, lalu coba lagi.';
        } else {
          position = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              timeLimit: Duration(seconds: 20),
            ),
          );
        }
      }
    } catch (_) {
      errorMessage = 'Gagal mengambil lokasi. Silakan coba lagi.';
    }

    if (!mounted) return;

    if (position != null) {
      final appState = context.read<AppState>();
      final draft = appState.parkingDraft;
      if (draft != null) {
        draft.latitude = position.latitude;
        draft.longitude = position.longitude;
        appState.updateParkingDraft(draft);
      }
    }

    setState(() {
      _latitude = position?.latitude;
      _longitude = position?.longitude;
      _errorMessage = errorMessage;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Konfirmasi Lokasi')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _isLoading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_errorMessage != null) ...[
                      Text(_errorMessage!, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _captureLocation,
                        child: const Text('Coba Lagi'),
                      ),
                    ] else ...[
                      Text('Latitude: $_latitude'),
                      const SizedBox(height: 8),
                      Text('Longitude: $_longitude'),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
