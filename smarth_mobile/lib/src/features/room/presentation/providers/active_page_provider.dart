import 'package:hooks_riverpod/hooks_riverpod.dart';

final activeRoomProvider = StateNotifierProvider<ActiveRoomNotifier, int>((ref) {
  return ActiveRoomNotifier();
});

class ActiveRoomNotifier extends StateNotifier<int> {
  ActiveRoomNotifier() : super(0);

  void changePage(int index) {
    state = index;
  }
}
