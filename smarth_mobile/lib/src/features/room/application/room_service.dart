import 'package:stmart_home_elte/src/features/room/domain/entities/room_model.dart';
import '../domain/repositories/room_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final roomServiceProvider = Provider<RoomService>((ref) {
  final repository = ref.watch(roomRepositoryProvider);
  return RoomService(repository);
});

class RoomService {
  final RoomRepository _repository;

  RoomService(this._repository);

  Future<List<RoomModel>> getRooms() {
    return _repository.getRooms();
  }

  Future<void> update(RoomModel copyWith) async {
    await _repository.update(copyWith);
  }
}
