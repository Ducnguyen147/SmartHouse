import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ResponsiveView extends ConsumerWidget {
  final Widget mobile;
  final Widget tablet;
  const ResponsiveView({
    required this.mobile,
    required this.tablet,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      if (sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
        return tablet;
      }
      return mobile;
    });
  }
}
