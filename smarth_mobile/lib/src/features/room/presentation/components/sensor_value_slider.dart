import 'package:flutter/cupertino.dart' show CupertinoSlider;
import 'package:flutter/material.dart';
import 'package:stmart_home_elte/src/core/theme/themes.dart';

class SensorValueSlider extends StatelessWidget {
  final String title;
  final double value;
  final double min;
  final double max;
  final String valueSymbol;
  final ValueChanged<double> onChanged;
  const SensorValueSlider({
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    super.key,
    required this.valueSymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          sliderTheme: const SliderThemeData(
        showValueIndicator: ShowValueIndicator.always,
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$title $value", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          Row(
            children: [
              Text("$min$valueSymbol"),
              Expanded(
                child: Slider(
                  label: "$value$valueSymbol",
                  thumbColor: AppColors.primaryColor,
                  activeColor: AppColors.primaryColor,
                  inactiveColor: AppColors.text.withOpacity(0.3),
                  divisions: 100,
                  value: normalize(value, max),
                  min: min,
                  max: max,
                  onChanged: onChanged,
                ),
              ),
              Text("$max$valueSymbol"),
            ],
          ),
        ],
      ),
    );
  }

  normalize(double value, double max) {
    return value > max ? max : value;
  }
}
