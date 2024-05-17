import 'dart:developer';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stmart_home_elte/src/core/data/devices_icons.dart';
import 'package:stmart_home_elte/src/core/functions/functions.dart';
import 'package:stmart_home_elte/src/core/theme/themes.dart';
import 'package:stmart_home_elte/src/features/device/domain/entities/device_model.dart';

class DeviceInfoWidget extends StatefulHookWidget {
  final DeviceModel device;
  // onChanged
  final void Function(bool) onChanged;
  const DeviceInfoWidget({required this.onChanged, required this.device, super.key});

  @override
  State<DeviceInfoWidget> createState() => _DeviceInfoWidgetState();
}

class _DeviceInfoWidgetState extends State<DeviceInfoWidget> {
  @override
  Widget build(BuildContext context) {
    const animationsDuration = Duration(milliseconds: 200);
    return GestureDetector(
      onTap: () => widget.onChanged(!widget.device.status!),
      onLongPress: () async {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            barrierColor: Colors.transparent,
            backgroundColor: AppColors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            constraints: const BoxConstraints(
              maxHeight: 150,
            ),
            builder: (innerContext) {
              return LightBulbSimulationConfigModalView(widget: widget);
            });
      },
      child: AnimatedContainer(
        duration: animationsDuration,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _getContainerBackgroundByState(widget.device.status ?? false),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: animationsDuration,
              decoration: BoxDecoration(
                color: _getIconContainerColorByState(widget.device.status ?? false),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  DevicesIcons.getIconByType(widget.device.type),
                  color: _getIconColorByState(widget.device.status ?? false),
                  size: 32,
                ),
              ),
            ),
            const SizedBox(height: 8),
            DefaultTextStyle(
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: _textColorByState(widget.device.status ?? false),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                child: Text(
                  formatNameByCapitalLetter(widget.device.type),
                )),
            const SizedBox(height: 6),
            // "numLevel": 0,
            // yse Text
            // if (!['LightBulb', 'Stove', 'VentilationSystem', 'ElectricPlug', 'Window'].contains(widget.device.type))
            //   Text(
            //     'Level: ${widget.device.numLevel}',
            //     style: Theme.of(context).textTheme.titleMedium!.copyWith(
            //           color: _textColorByState(widget.device.status ?? false),
            //           fontSize: 16,
            //         ),
            //   ),
            //  "status": false,
            Transform.translate(
              offset: const Offset(-4, 0),
              child: CupertinoSwitch(
                  activeColor: AppColors.palYellow,
                  trackColor: AppColors.offDeviceContainerBackground,
                  value: widget.device.status ?? false,
                  onChanged: widget.onChanged),
            ),
          ],
        ),
      ),
    );
  }

  Color _getIconContainerColorByState(bool isOn) =>
      isOn ? AppColors.palYellow : AppColors.offDeviceContainerBackground.withOpacity(0.4);
  Color _getIconColorByState(bool isOn) => isOn ? AppColors.white : AppColors.primaryColor;
  Color _textColorByState(bool isOn) => isOn ? AppColors.white : AppColors.primaryColor;
  Color _getContainerBackgroundByState(bool isOn) => !isOn ? AppColors.white : AppColors.primaryColor.withOpacity(0.95);
  IconData _getIconByState(bool isOn) => !isOn ? FluentIcons.lightbulb_20_regular : FluentIcons.lightbulb_20_filled;
}

class LightBulbSimulationConfigModalView extends HookWidget {
  const LightBulbSimulationConfigModalView({
    super.key,
    required this.widget,
  });

  final DeviceInfoWidget widget;

  @override
  Widget build(BuildContext context) {
    final brightness = useState(0.5);

    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.text.withOpacity(0.1),
            blurRadius: 16,
            spreadRadius: 8,
          ),
        ],
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Text(formatNameByCapitalLetter("${widget.device.type}, Simulator"),
                    style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(FluentIcons.dismiss_20_regular),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Brightness', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 16),
                      CupertinoSlider(
                        value: brightness.value,
                        onChanged: (v) => brightness.value = v,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 500,
                    width: double.maxFinite,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
