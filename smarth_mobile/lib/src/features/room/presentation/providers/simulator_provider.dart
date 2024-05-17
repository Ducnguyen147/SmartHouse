import 'dart:math';
import 'dart:developer' as dev;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stmart_home_elte/src/features/room/application/room_service.dart';
import 'package:stmart_home_elte/src/features/room/domain/entities/room_model.dart';
import 'package:stmart_home_elte/src/features/room/presentation/providers/room_provider.dart';

final simulatorProvider = StateNotifierProvider<SimulatorNotifier, SimulatorState>((ref) {
  final roomService = ref.watch(roomServiceProvider);
  return SimulatorNotifier(roomService, ref);
});

class SimulatorState {
  int brightness = 0;
  int occupancy = 0;
  int oxygenLevel = 0;
  int temperature = 0;
  bool isVisibile = false;
  SimulatorState();

  SimulatorState copyWith({
    int? brightness,
    int? occupancy,
    int? oxygenLevel,
    int? temperature,
    bool? isVisibile,
  }) {
    return SimulatorState()
      ..brightness = brightness ?? this.brightness
      ..occupancy = occupancy ?? this.occupancy
      ..oxygenLevel = oxygenLevel ?? this.oxygenLevel
      ..temperature = temperature ?? this.temperature
      ..isVisibile = isVisibile ?? this.isVisibile;
  }
}

class SimulatorNotifier extends StateNotifier<SimulatorState> {
  final RoomService _roomsService;
  final Ref _ref;
  SimulatorNotifier(this._roomsService, this._ref) : super(SimulatorState());

  void changeBrightness(int value) {
    state = state.copyWith(brightness: value);
  }

  void changeOccupancy(int value) {
    state = state.copyWith(occupancy: value);
  }

  void changeOxygenLevel(int value) {
    state = state.copyWith(oxygenLevel: value);
  }

  void changeTemperature(int value) {
    state = state.copyWith(temperature: value);
  }

  void reset() {
    state = SimulatorState();
  }

  void randomize() {
    state = state.copyWith(
      brightness: Random().nextInt(100),
      occupancy: Random().nextInt(100),
      oxygenLevel: Random().nextInt(100),
      temperature: Random().nextInt(100),
    );
  }

  init({
    int? brightness,
    int? occupancy,
    int? oxygenLevel,
    int? temperature,
    bool? isVisibile,
  }) {
    state = state.copyWith(
      brightness: brightness ?? 0,
      occupancy: occupancy ?? 0,
      oxygenLevel: oxygenLevel ?? 0,
      temperature: temperature ?? 0,
    );
  }

  Future<void> simulate(RoomModel? room) async {
    if (room == null) return;

    await _roomsService.update(
      room.copyWith(
        brightness: state.brightness,
        occupancy: state.occupancy,
        oxygenLevel: state.oxygenLevel,
        temperature: state.temperature,
      ),
    );

    _ref.read(roomsProvider.notifier).get();
  }

  void toggle() {
    state = state.copyWith(isVisibile: !state.isVisibile);
    dev.log("isVisibile, ${state.isVisibile}");
  }
}
