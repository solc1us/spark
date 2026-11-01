import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../routes/app_routes.dart';
import '../state/app_state.dart';

class ConfirmLocationPage extends StatefulWidget {
  const ConfirmLocationPage({super.key});

  @override
  State<ConfirmLocationPage> createState() => _ConfirmLocationPageState();
}

class _ConfirmLocationPageState extends State<ConfirmLocationPage> {
  bool _isLoading = true;
  bool _isSaving = false;
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

  void _saveParking() {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    String? saveError;
    try {
      final appState = context.read<AppState>();
      final draft = appState.parkingDraft;
      if (draft == null) {
        throw StateError('Data parkir belum tersedia. Isi form parkir dahulu.');
      }
      if (_isLoading ||
          _errorMessage != null ||
          _latitude == null ||
          _longitude == null) {
        throw StateError(
          'Lokasi belum tersedia. Ambil lokasi terlebih dahulu.',
        );
      }
      final photoPath = draft.photoPath?.trim();
      if (photoPath == null ||
          photoPath.isEmpty ||
          !File(photoPath).existsSync()) {
        throw ArgumentError('Foto tidak tersedia. Silakan ambil foto ulang.');
      }

      draft.latitude = _latitude;
      draft.longitude = _longitude;
      appState.addParking(draft);
    } on ArgumentError catch (error) {
      saveError = error.message.toString();
    } on StateError catch (error) {
      saveError = error.message;
    } catch (_) {
      saveError = 'Gagal menyimpan parkir. Silakan coba lagi.';
    }

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(content: Text(saveError ?? 'Parkir berhasil disimpan.')),
    );
    if (saveError != null) {
      setState(() => _isSaving = false);
      return;
    }

    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Konfirmasi Lokasi')),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed:
                !_isLoading &&
                    !_isSaving &&
                    _errorMessage == null &&
                    _latitude != null &&
                    _longitude != null
                ? _saveParking
                : null,
            child: const Text('Simpan Parkir'),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _isLoading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_errorMessage != null) ...[
                      Text(_errorMessage!, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _captureLocation,
                        child: const Text('Coba Lagi'),
                      ),
                    ] else ...[
                      Expanded(
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: LatLng(_latitude!, _longitude!),
                            initialZoom: 18,
                            maxZoom: 19,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.spark',
                            ),
                            DragMarkers(
                              markers: [
                                DragMarker(
                                  point: LatLng(_latitude!, _longitude!),
                                  size: const Size(48, 48),
                                  alignment: Alignment.topCenter,
                                  builder: (context, point, isDragging) =>
                                      const Icon(
                                        Icons.location_on,
                                        size: 48,
                                        color: Colors.red,
                                        semanticLabel: 'Lokasi parkir',
                                      ),
                                  onDragUpdate: (details, point) {
                                    setState(() {
                                      _latitude = point.latitude;
                                      _longitude = point.longitude;
                                    });
                                    final appState = context.read<AppState>();
                                    final draft = appState.parkingDraft;
                                    if (draft != null) {
                                      draft.latitude = point.latitude;
                                      draft.longitude = point.longitude;
                                      appState.updateParkingDraft(draft);
                                    }
                                  },
                                ),
                              ],
                            ),
                            const SimpleAttributionWidget(
                              source: Text(
                                'OpenStreetMap contributors\n'
                                'openstreetmap.org/copyright',
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Geser pin untuk menyesuaikan lokasi parkir.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
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
