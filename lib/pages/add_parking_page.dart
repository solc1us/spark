import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/parking_draft.dart';
import '../routes/app_routes.dart';
import '../state/app_state.dart';

class AddParkingPage extends StatelessWidget {
  const AddParkingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final draft = appState.parkingDraft;

    return Scaffold(
      appBar: AppBar(title: const Text('Add Parking')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              initialValue: draft?.cityId,
              decoration: const InputDecoration(labelText: 'Kota'),
              items: [
                for (final city in appState.cities)
                  DropdownMenuItem(
                    value: city.id,
                    child: Text(city.name),
                  ),
              ],
              onChanged: (cityId) {
                final updatedDraft = draft ?? ParkingDraft();
                if (updatedDraft.cityId != cityId) {
                  updatedDraft.cityId = cityId;
                  updatedDraft.mallId = null;
                  appState.updateParkingDraft(updatedDraft);
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: draft?.mode,
              decoration: const InputDecoration(
                labelText: 'Metode pencatatan',
              ),
              items: const [
                DropdownMenuItem(
                  value: 'structured',
                  child: Text('Terstruktur'),
                ),
                DropdownMenuItem(
                  value: 'free',
                  child: Text('Bebas'),
                ),
              ],
              onChanged: (mode) {
                final updatedDraft = draft ?? ParkingDraft();
                if (updatedDraft.mode != mode) {
                  updatedDraft.mode = mode;
                  updatedDraft.category = null;
                  updatedDraft.mallId = null;
                  updatedDraft.placeName = null;
                  appState.updateParkingDraft(updatedDraft);
                }
              },
            ),
            const SizedBox(height: 16),
            if (draft?.mode == 'structured') ...[
              DropdownButtonFormField<String>(
                initialValue: draft?.category,
                decoration: const InputDecoration(labelText: 'Kategori tempat'),
                items: const [
                  DropdownMenuItem(value: 'mall', child: Text('Mall')),
                  DropdownMenuItem(value: 'event', child: Text('Event')),
                  DropdownMenuItem(value: 'other', child: Text('Lainnya')),
                ],
                onChanged: (category) {
                  final updatedDraft = draft ?? ParkingDraft();
                  if (updatedDraft.category != category) {
                    updatedDraft.category = category;
                    updatedDraft.mallId = null;
                    updatedDraft.placeName = null;
                    appState.updateParkingDraft(updatedDraft);
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
            if (draft?.mode == 'structured' && draft?.category == 'mall') ...[
              DropdownButtonFormField<String>(
                key: ValueKey(draft?.cityId),
                initialValue: draft?.mallId,
                decoration: const InputDecoration(labelText: 'Mall'),
                items: [
                  if (draft?.cityId != null)
                    for (final mall in appState.getMallsByCity(draft!.cityId!))
                      DropdownMenuItem(value: mall.id, child: Text(mall.name)),
                ],
                onChanged: draft?.cityId == null
                    ? null
                    : (mallId) {
                        final updatedDraft = draft ?? ParkingDraft();
                        updatedDraft.mallId = mallId;
                        appState.updateParkingDraft(updatedDraft);
                      },
              ),
              if (draft?.cityId == null)
                const Text('Pilih kota terlebih dahulu.'),
              if (draft?.cityId != null &&
                  appState.getMallsByCity(draft!.cityId!).isEmpty)
                const Text('Tidak ada mall di kota ini.'),
              const SizedBox(height: 16),
            ],
            TextButton(
              onPressed: () {
                final currentDraft = appState.parkingDraft;
                if (currentDraft?.cityId == null ||
                    currentDraft?.mode == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pilih kota dan metode pencatatan.'),
                    ),
                  );
                  return;
                }
                if (currentDraft?.mode == 'structured') {
                  if (currentDraft?.category == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pilih kategori tempat.')),
                    );
                    return;
                  }
                  if (currentDraft?.category == 'mall' &&
                      currentDraft?.mallId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pilih mall.')),
                    );
                    return;
                  }
                  if (currentDraft?.category != 'mall') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Input nama tempat belum tersedia.'),
                      ),
                    );
                    return;
                  }
                }
                Navigator.pushNamed(context, AppRoutes.capturePhoto);
              },
              child: const Text('Capture Photo'),
            ),
          ],
        ),
      ),
    );
  }
}