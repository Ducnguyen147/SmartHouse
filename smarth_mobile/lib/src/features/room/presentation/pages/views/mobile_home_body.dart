import 'dart:developer';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stmart_home_elte/src/features/room/domain/entities/room_model.dart';
import 'package:stmart_home_elte/src/features/room/presentation/components/room_info_card.dart';
import 'package:stmart_home_elte/src/features/room/presentation/providers/active_page_provider.dart';

import '../../../../device/presentation/providers/device_provider.dart';
import '../../providers/room_provider.dart';
import '../../../../../core/theme/themes.dart';
import '../../components/device_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MobileHomePageBody extends HookConsumerWidget {
  final PageController pageController;
  final int crossAxisCount;
  const MobileHomePageBody({this.crossAxisCount = 2, required this.pageController, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<RoomModel> rooms = [];
    ref.listen(roomsProvider, (_, rms) {
      if (rooms.isNotEmpty) {
        rooms = rms;
      }
    });
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Builder(builder: (context) {
        final rooms = ref.watch(roomsProvider);
        // ignore: avoid_function_literals_in_foreach_calls
        for (final room in rooms) {
          log("rooms temperature : ${room.temperature}");
        }
        if (rooms.isEmpty) {
          return _buildWhenErrorWidget(ref);
        }
        return Column(
          children: [
            Expanded(
                child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: _buildTabViewBar(rooms, ref, pageController),
                  ),
                  Expanded(
                    child: PageView(
                        controller: pageController,
                        onPageChanged: (index) {
                          // currentPage.value = index;
                          ref.read(activeRoomProvider.notifier).changePage(index);
                        },
                        children: List.generate(rooms.length, (index) {
                          final room = rooms[index];
                          final devices = room.devices;
                          return Builder(builder: (context) {
                            return EasyRefresh(
                              onRefresh: () async {
                                await ref.read(roomsProvider.notifier).get();
                              },
                              child: Builder(builder: (context) {
                                return CustomScrollView(
                                  slivers: <Widget>[
                                    SliverToBoxAdapter(
                                      child: RoomInfoCard(room: room),
                                    ),
                                    SliverPadding(
                                      padding: const EdgeInsets.only(top: 10),
                                      sliver: SliverMasonryGrid.count(
                                        crossAxisCount: crossAxisCount,
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10,
                                        childCount: devices.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          final device = devices[index];
                                          return DeviceInfoWidget(
                                              device: device,
                                              onChanged: (value) async {
                                                await ref
                                                    .read(deviceProvider.notifier)
                                                    .update(device.copyWith(status: !(device.status ?? false)));
                                              });
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            );
                          });
                        })),
                  )
                ],
              ),
            )),
          ],
        );
      }),
    );
  }

  SizedBox _buildWhenErrorWidget(WidgetRef ref) {
    return SizedBox.expand(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(FluentIcons.info_48_regular, size: 48, color: AppColors.text),
          const Text('No rooms found', style: TextStyle(color: AppColors.text, fontSize: 16)),
          const SizedBox(height: 4),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Refresh"),
            onPressed: () {
              ref.read(roomsProvider.notifier).get();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabViewBar(List<RoomModel> rooms, WidgetRef ref, PageController pageController) {
    final currentPage = ref.watch(activeRoomProvider);
    return SizedBox(
      height: 40,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          for (final room in rooms)
            Builder(builder: (context) {
              final selected = currentPage == rooms.indexOf(room);
              final selectedTextStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16); // const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

              final unselectedTextStyle = selectedTextStyle?.copyWith(
                  color: AppColors.text,
                  fontWeight: FontWeight.normal,
                  fontSize: 16); // const TextStyle(fontSize: 16, fontWeight: FontWeight.normal);

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  showCheckmark: false,
                  selectedColor: AppColors.primaryColor,
                  onSelected: (selected) {
                    ref.read(activeRoomProvider.notifier).changePage(rooms.indexOf(room));
                    pageController.animateToPage(
                      rooms.indexOf(room),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  label: Text(room.name!, style: selected ? selectedTextStyle : unselectedTextStyle),
                  selected: currentPage == rooms.indexOf(room),
                ),
              );
            }),
        ],
      ),
    );
  }
}
