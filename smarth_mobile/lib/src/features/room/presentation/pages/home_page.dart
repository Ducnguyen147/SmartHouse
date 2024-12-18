import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stmart_home_elte/src/features/room/presentation/providers/simulator_provider.dart';
import 'package:stmart_home_elte/src/shared/presentation/components/responsive_view.dart';
import 'package:stmart_home_elte/src/shared/presentation/providers/conntectivity_providers.dart';

import '../providers/room_provider.dart';
import '../../../../core/theme/themes.dart';
import 'views/mobile_home_body.dart';
import 'views/simulator_view.dart';
import 'views/iframe_screen.dart';

class HomePage extends StatefulHookConsumerWidget {
  const HomePage({super.key});
  @override
  ConsumerState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(roomsProvider.notifier).get();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(connectivityStreamProvider).when(
          error: (eror, str) =>
              ref.read(connectivityStateProvider.notifier).state = false,
          data: (results) => ref
              .read(connectivityStateProvider.notifier)
              .state = results.contains(ConnectivityResult.none),
          loading: () => null, //do nothing
        );

    final pageController = usePageController();
    return Scaffold(
      backgroundColor: AppColors.background,
      drawerScrimColor:
          Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
      appBar: AppBar(
        backgroundColor: AppColors.background,
        centerTitle: false,
        leadingWidth: 56,
        title: const Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/avatar.jpeg'),
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Duc',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(
                  'Welcome back,',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xffA0A0A0),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          const Icon(Icons.notifications,
              color: AppColors.primaryColor, size: 32),
          const SizedBox(width: 16),
          ResponsiveBuilder(builder: (context, sizingInformation) {
            if (!sizingInformation.isMobile) {
              return ElevatedButton(
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  ref.read(simulatorProvider.notifier).toggle();
                },
                // icon: const Icon(Icons.add, color: AppColors.white, size: 28),
                child: Text(
                  ref.watch(simulatorProvider).isVisibile
                      ? "Hide Simulator"
                      : "Show Simulator",
                ),
              );
            }

            return const SizedBox();
          }),
          const SizedBox(width: 16),
        ],
      ),
      body: ResponsiveView(
          mobile: MobileHomePageBody(
            pageController: pageController,
          ),
          tablet: Builder(builder: (context) {
            final simulator = ref.watch(simulatorProvider);

            return (Row(
              children: [
                Expanded(
                  child: MobileHomePageBody(
                    pageController: pageController,
                    crossAxisCount:
                        _getCrossAxisCount(simulator.isVisibile, context),
                  ),
                ),
                if (simulator.isVisibile)
                  SizedBox(
                    width: 400,
                    child: SimulatorView(pageController: pageController),
                  ),
                SizedBox(
                  width: 400,
                  height: 600,
                  child: IframeScreen(
                      // Embedding the chatbot
                      pageController: pageController),
                )
              ],
            ));
          })),
    );
  }

  int _getCrossAxisCount(bool isVisible, BuildContext context) {
    final bool isPortraint =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    if (!isVisible || (isVisible && isPortraint)) {
      return 6;
    }
    return 2;
  }
}
