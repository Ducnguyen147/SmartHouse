import 'package:stmart_home_elte/src/features/device/domain/entities/device_model.dart';

import '../domain/repositories/device_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deviceServiceProvider = Provider<DeviceService>((ref) {
  final repository = ref.watch(deviceRepositoryProvider);
  return DeviceService(repository);
});

class DeviceService {
  final DeviceRepository repository;

  DeviceService(this.repository);

  Future<void> update(DeviceModel device) async {
    await repository.update(device);
  }
}
