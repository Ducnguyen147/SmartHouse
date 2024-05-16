import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stmart_home_elte/src/features/device/domain/entities/device_model.dart';
import '/src/features/device/infrastructure/repositories/device_remote_repository.dart';
import '/src/features/device/infrastructure/repositories/device_local_repository.dart';

final deviceRepositoryProvider = Provider<DeviceRepository>((ref) {
  final remoteRepository = ref.watch(deviceRemoteRepositoryProvider);
  final localRepository = ref.watch(deviceLocalRepositoryProvider);
  return DeviceRepository(remoteRepository, localRepository);
});

class DeviceRepository {
  final DeviceRemoteRepository _remoteRepository;
  final DeviceLocalRepository _localRepository;
  DeviceRepository(this._remoteRepository, this._localRepository);

  Future<void> update(DeviceModel device) async {
    return _remoteRepository.update(device);
  }
}
