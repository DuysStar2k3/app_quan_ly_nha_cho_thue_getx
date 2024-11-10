import 'package:get/get.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_page.dart';
import '../modules/auth/views/register_page.dart';
import '../modules/landlord/bindings/rooms_binding.dart';
import '../modules/landlord/views/rooms_view/add_room_view.dart';
import '../modules/splash/splash_page.dart';
import '../modules/landlord/views/landlord_page.dart';
import '../modules/landlord/bindings/landlord_binding.dart';
import '../modules/splash/bindings/splash_binding.dart';

// Định nghĩa các routes
abstract class Routes {
  static const SPLASH = '/';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const TENANT = '/tenant';
  static const LANDLORD = '/landlord';
  static const ADD_ROOM = '/add-room';
}

// Định nghĩa các pages
class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => RegisterPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.LANDLORD,
      page: () => const LandlordPage(),
      binding: LandlordBinding(),
    ),
    GetPage(
      name: Routes.ADD_ROOM,
      page: () => AddRoomView(),
      binding: RoomsBinding(),
    ),
  ];
}
