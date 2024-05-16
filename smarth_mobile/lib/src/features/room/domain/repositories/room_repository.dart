import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stmart_home_elte/src/features/room/domain/entities/room_model.dart';
import '/src/features/room/infrastructure/repositories/room_remote_repository.dart';
import '/src/features/room/infrastructure/repositories/room_local_repository.dart';

final roomRepositoryProvider = Provider<RoomRepository>((ref) {
  final remoteRepository = ref.watch(roomRemoteRepositoryProvider);
  final localRepository = ref.watch(roomLocalRepositoryProvider);
  return RoomRepository(remoteRepository, localRepository);
});

class RoomRepository {
  final RoomRemoteRepository _remoteRepository;
  // ignore: unused_field
  final RoomLocalRepository _localRepository;
  RoomRepository(this._remoteRepository, this._localRepository);

  Future<List<RoomModel>> getRooms() {
    // if (!_ref.read(connectivityStateProvider)) {
    // return _localRepository.getRooms();
    // }
    return _remoteRepository.getRooms();
  }

  Future<void> update(RoomModel room) async {
    return _remoteRepository.update(room);
  }
}
