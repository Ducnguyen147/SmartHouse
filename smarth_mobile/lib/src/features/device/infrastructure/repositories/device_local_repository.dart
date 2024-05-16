import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stmart_home_elte/src/features/device/domain/entities/device_model.dart';
import '/src/features/device/domain/repositories/device_repository.dart';

final deviceLocalRepositoryProvider = Provider<DeviceLocalRepository>((ref) {
  return DeviceLocalRepository();
});

class DeviceLocalRepository implements DeviceRepository {
  // TODO: Implement local repository methods
  @override
  Future<void> update(DeviceModel device) {
    throw UnimplementedError();
  }
}
