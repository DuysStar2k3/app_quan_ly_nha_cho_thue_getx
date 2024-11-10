import 'package:get/get.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_page.dart';
import '../modules/auth/views/register_page.dart';
import '../modules/landlord/bindings/landlord_binding_page.dart';
import '../modules/landlord/views/rooms_view/add_room_view.dart';
import '../modules/splash/splash_page.dart';
import '../modules/landlord/views/landlord_page.dart';
import '../modules/tenant/bindings/tenant_binding_page.dart';
import '../modules/tenant/views/tenant_page.dart';

// Định nghĩa các routes
abstract class Routes {
  static const SPLASH = '/';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const LANDLORD = '/landlord';
  static const TENANT = '/tenant';
  static const ADD_ROOM = '/add-room';
}

// Định nghĩa các pages
class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashPage(),
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
      binding: LandlordBindingPage(),
    ),
    GetPage(
      name: Routes.TENANT,
      page: () => const TenantPage(),
      binding: TenantBindingPage(),
    ),
    GetPage(
      name: Routes.ADD_ROOM,
      page: () =>  AddRoomView(),
    ),
  ];
}
