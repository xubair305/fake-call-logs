import 'package:get/get.dart';

import '../modules/call_history/bindings/call_history_binding.dart';
import '../modules/call_history/views/call_history_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.CALL_HISTORY;

  static final routes = [
    GetPage(name: _Paths.HOME, page: () => const HomeView(), binding: HomeBinding()),
    GetPage(name: _Paths.CALL_HISTORY, page: () => const CallHistoryView(), binding: CallHistoryBinding()),
  ];
}
