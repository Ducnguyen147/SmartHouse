import 'dart:developer';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stmart_home_elte/src/core/theme/themes.dart';

import '../../domain/entities/room_model.dart';

class RoomInfoCard extends StatelessWidget {
  final RoomModel room;

  const RoomInfoCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    log("new val : ${room.name}");
    final infos = [
      _buildRoomInfo(context, 'Brightness: ${room.brightness}%', FluentIcons.brightness_low_48_regular, AppColors.palYellow),
      _buildRoomInfo(context, 'Temperature: ${room.temperature}°C', FluentIcons.temperature_24_regular, AppColors.palRed),
      _buildRoomInfo(context, 'Occupancy: ${room.occupancy}', FluentIcons.people_20_regular, AppColors.palGreen),
      _buildRoomInfo(
          context, 'Oxygen Level: ${room.oxygenLevel}%', FluentIcons.table_freeze_column_16_filled, AppColors.primaryColor),
    ];
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      return Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(top: 8),
        decoration: AppTheme.primaryDecoration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${room.name} current status",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.text,
                  fontWeight: FontWeight.bold,
                  fontSize: 19), // const TextStyle(fontSize: 16, color: AppColors.text),
            ),
            Divider(color: Colors.grey.shade300),
            Text(
              room.description!,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.text,
                  fontWeight: FontWeight.w600,
                  fontSize: 16), // const TextStyle(fontSize: 16, color: AppColors.text),
            ),
            const SizedBox(height: 4),
            if (sizingInformation.isMobile)
              ...infos
            else
              StaggeredGrid.count(crossAxisCount: 2, children: infos.map((e) => e).toList())
          ],
        ),
      );
    });
  }

  Widget _buildRoomInfo(
    BuildContext context,
    String infoText,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.white, size: 24)),
          const SizedBox(width: 8),
          Text(infoText,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: AppColors.text, fontSize: 16)), // const TextStyle(fontSize: 16, color: AppColors.text),
        ],
      ),
    );
  }
}
