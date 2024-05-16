import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stmart_home_elte/src/features/room/domain/entities/room_model.dart';
import '/src/features/room/domain/repositories/room_repository.dart';

final roomLocalRepositoryProvider = Provider<RoomLocalRepository>((ref) {
  return RoomLocalRepository();
});

class RoomLocalRepository implements RoomRepository {
  @override
  Future<List<RoomModel>> getRooms() async {
    return [];
  }

  @override
  Future<void> update(RoomModel room) {
    throw UnimplementedError();
  }
}
