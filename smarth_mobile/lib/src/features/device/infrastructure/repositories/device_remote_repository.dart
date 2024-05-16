import 'package:fpdart/fpdart.dart';
import 'package:stmart_home_elte/src/core/api/failure_or_ok.dart';
import 'package:stmart_home_elte/src/features/device/domain/entities/device_model.dart';
import 'package:stmart_home_elte/src/shared/services/remote_service.dart';

import '/src/features/device/domain/repositories/device_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deviceRemoteRepositoryProvider = Provider<DeviceRemoteRepository>((ref) {
  final remoteService = ref.watch(remoteServiceProvider);
  return DeviceRemoteRepository(remoteService);
});

class DeviceRemoteRepository implements DeviceRepository {
  final RemoteService _remoteService;

  DeviceRemoteRepository(this._remoteService);
  @override
  Future<void> update(DeviceModel device) async {
    final Either<Failure, void> respEither = await _remoteService.put('/devices/${device.deviceId}', body: device.toJson());
    return respEither.match<void>(
      (l) => throw Exception('Failed to update data'),
      (r) => r,
    );
  }
}
