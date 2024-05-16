import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stmart_home_elte/src/features/device/domain/entities/device_model.dart';
import 'package:stmart_home_elte/src/features/room/presentation/providers/room_provider.dart';

import '../../application/device_service.dart';

final deviceProvider = StateNotifierProvider<DeviceNotifier, void>((ref) {
  final service = ref.watch(deviceServiceProvider);
  return DeviceNotifier(ref, service);
});

class DeviceNotifier extends StateNotifier<void> {
  final DeviceService service;
  final Ref _ref;

  DeviceNotifier(this._ref, this.service) : super(null);

  Future<void> update(DeviceModel device) async {
    await service.update(device);
    await _ref.read(roomsProvider.notifier).get();
  }
}
