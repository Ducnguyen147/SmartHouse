import 'dart:developer';

import 'package:fpdart/fpdart.dart';
import 'package:stmart_home_elte/src/core/api/failure_or_ok.dart';
import 'package:stmart_home_elte/src/features/room/domain/entities/room_model.dart';
import 'package:stmart_home_elte/src/shared/services/remote_service.dart';
import '/src/features/room/domain/repositories/room_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final roomRemoteRepositoryProvider = Provider<RoomRemoteRepository>((ref) {
  final remoteService = ref.watch(remoteServiceProvider);
  return RoomRemoteRepository(remoteService);
});

class RoomRemoteRepository implements RoomRepository {
  final RemoteService _remoteService;
  RoomRemoteRepository(this._remoteService);
  @override
  Future<List<RoomModel>> getRooms() async {
    final Either<Failure, List<RoomModel>> respEither = await _remoteService.get(
      '/rooms',
      transformer: (json) {
        return List<RoomModel>.from(
          json['data'].map((x) => RoomModel.fromJson(x)),
        );
      },
    );
    return respEither.match<List<RoomModel>>(
      (l) => throw Exception('Failed to load data'),
      (r) => r,
    );
  }

  @override
  Future<void> update(RoomModel room) async {
    log("room.toJson(), ${room.toJson()}");
    final Either<Failure, void> respEither = await _remoteService.put(
      '/rooms/${room.roomId}',
      body: room.toJson(),
    );
    return respEither.match<void>(
      (l) => throw Exception('Failed to update data'),
      (r) => r,
    );
  }
}
