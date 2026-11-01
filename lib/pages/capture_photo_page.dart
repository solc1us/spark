import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../routes/app_routes.dart';
import '../state/app_state.dart';

class CapturePhotoPage extends StatefulWidget {
  const CapturePhotoPage({super.key});

  @override
  State<CapturePhotoPage> createState() => _CapturePhotoPageState();
}

class _CapturePhotoPageState extends State<CapturePhotoPage> {
  bool _isCapturing = false;

  Future<void> _capturePhoto() async {
    final appState = context.read<AppState>();
    final draft = appState.parkingDraft;
    if (draft == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mulai pencatatan parkir terlebih dahulu.'),
        ),
      );
      return;
    }

    setState(() => _isCapturing = true);
    try {
      final photo = await ImagePicker().pickImage(source: ImageSource.camera);
      if (!mounted || photo == null) return;

      draft.photoPath = photo.path;
      appState.updateParkingDraft(draft);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak dapat membuka kamera. Silakan coba lagi.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final photoPath = context.watch<AppState>().parkingDraft?.photoPath;
    final photoFile = photoPath == null ? null : File(photoPath);
    final hasPhoto = photoFile?.existsSync() ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text('Capture Photo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: hasPhoto
                  ? Image.file(photoFile!, fit: BoxFit.contain)
                  : const Center(child: Text('Belum ada foto parkir.')),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isCapturing ? null : _capturePhoto,
              child: Text(hasPhoto ? 'Foto Ulang' : 'Ambil Foto'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: hasPhoto && !_isCapturing
                  ? () =>
                        Navigator.pushNamed(context, AppRoutes.confirmLocation)
                  : null,
              child: const Text('Lanjut'),
            ),
          ],
        ),
      ),
    );
  }
}
