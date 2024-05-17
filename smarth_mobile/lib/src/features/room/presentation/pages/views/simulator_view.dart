import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stmart_home_elte/src/core/theme/themes.dart';
import 'package:stmart_home_elte/src/features/room/domain/entities/room_model.dart';
import 'package:stmart_home_elte/src/features/room/presentation/providers/active_page_provider.dart';
import 'package:stmart_home_elte/src/features/room/presentation/providers/simulator_provider.dart';

import '../../components/sensor_value_slider.dart';
import '../../providers/room_provider.dart';

class SimulatorView extends StatefulHookConsumerWidget {
  final PageController pageController;
  const SimulatorView({required this.pageController, Key? key}) : super(key: key);

  @override
  ConsumerState<SimulatorView> createState() => _SimulatorViewState();
}

class _SimulatorViewState extends ConsumerState<SimulatorView> {
  RoomModel? getCurrentRoom(int index) {
    final rooms = ref.read(roomsProvider);
    if (rooms.isEmpty) return null;
    return rooms[index];
  }

  doubleParseValue(int? value) {
    return double.parse(value.toString());
  }

  void initSimulatorState(RoomModel room) => ref.read(simulatorProvider.notifier).init(
        brightness: room.brightness,
        occupancy: room.occupancy,
        oxygenLevel: room.oxygenLevel,
        temperature: room.temperature,
      );

  SimulatorState get simulationState => ref.watch(simulatorProvider);
  @override
  Widget build(BuildContext context) {
    final rooms = ref.watch(roomsProvider);
    ref.listen(activeRoomProvider, (_, currentRoomIndex) {
      if (rooms.isNotEmpty) {
        final currentRoom = getCurrentRoom(currentRoomIndex);
        if (currentRoom == null) return;
        initSimulatorState(currentRoom);
      } else {
        ref.read(simulatorProvider.notifier).reset();
      }
    });

    ref.listen(roomsProvider, (_, rooms) {
      if (rooms.isNotEmpty) {
        final currentRoom = getCurrentRoom(ref.read(activeRoomProvider));
        if (currentRoom == null) return;
        initSimulatorState(currentRoom);
      } else {
        ref.read(simulatorProvider.notifier).reset();
      }
    });

    return Scaffold(
        backgroundColor: AppColors.background,
        body: Builder(builder: (context) {
          if (rooms.isEmpty) {
            return SizedBox.expand(
              child: Row(
                children: [
                  const VerticalDivider(),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(FluentIcons.building_32_regular, size: 100, color: AppColors.primaryColor),
                        const SizedBox(height: 16),
                        Text(
                          'Waiting for a room to be selected',
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16).copyWith(left: 0.0),
            children: [
              Text(
                'Simulator',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                'Please select a room to simulate',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 2),
              DecoratedBox(
                decoration: AppTheme.primaryDecoration,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: rooms[ref.watch(activeRoomProvider)].roomId,
                      items: rooms
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.roomId,
                              child: Text(e.name ?? ''),
                            ),
                          )
                          .toList(),
                      onChanged: (roomId) {
                        final newPageIndex = rooms.indexWhere((element) => element.roomId == roomId);
                        ref.read(activeRoomProvider.notifier).changePage(
                              newPageIndex,
                            );
                        widget.pageController.animateToPage(
                          newPageIndex,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DecoratedBox(
                  decoration: AppTheme.primaryDecoration,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SensorValueSlider(
                          title: "Brightness",
                          valueSymbol: "%",
                          value: doubleParseValue(simulationState.brightness),
                          min: 0,
                          max: 100,
                          onChanged: (value) => ref.read(simulatorProvider.notifier).changeBrightness(value.toInt()),
                        ),
                        const SizedBox(height: 16),
                        SensorValueSlider(
                          title: "Temperature",
                          valueSymbol: "°C",
                          value: doubleParseValue(simulationState.temperature),
                          min: 0,
                          max: 60,
                          onChanged: (value) => ref.read(simulatorProvider.notifier).changeTemperature(value.toInt()),
                        ),
                        const SizedBox(height: 16),
                        SensorValueSlider(
                          title: "Oxygen Level",
                          valueSymbol: "%",
                          value: doubleParseValue(simulationState.oxygenLevel),
                          min: 0,
                          max: 100,
                          onChanged: (value) => ref.read(simulatorProvider.notifier).changeOxygenLevel(value.toInt()),
                        ),
                        const SizedBox(height: 16),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Occupancy", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            Row(
                              // minus and plus and in the center a numbeer(valur)
                              children: [
                                IconButton(
                                    padding: EdgeInsets.zero,
                                    style: IconButton.styleFrom(
                                      backgroundColor: AppColors.primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (simulationState.occupancy > 0) {
                                        ref.read(simulatorProvider.notifier).changeOccupancy(simulationState.occupancy - 1);
                                      }
                                    },
                                    // q: what is the name of substrct icon in the material
                                    // a: Icons.minus
                                    icon: const Icon(Icons.remove, color: AppColors.white, size: 28)),
                                const SizedBox(width: 20),
                                Text("${simulationState.occupancy}",
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 20),
                                IconButton(
                                    padding: EdgeInsets.zero,
                                    style: IconButton.styleFrom(
                                      backgroundColor: AppColors.primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (simulationState.occupancy <= 100) {
                                        ref.read(simulatorProvider.notifier).changeOccupancy(simulationState.occupancy + 1);
                                      }
                                    },
                                    icon: const Icon(Icons.add, color: AppColors.white, size: 28))
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.white,
                            foregroundColor: AppColors.primaryColor,
                            minimumSize: const Size(100, 48),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(color: AppColors.primaryColor, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            ref.read(simulatorProvider.notifier).randomize();
                          },
                          child: const Text("Ramdomize"),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: AppColors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            final index = ref.read(activeRoomProvider);
                            ref.read(simulatorProvider.notifier).simulate(getCurrentRoom(index));
                          },
                          child: const Text("Simulate"),
                        ),
                      ],
                    ),
                  )),
            ],
          );
        }));
  }
}
