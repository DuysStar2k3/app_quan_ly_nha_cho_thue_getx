import 'package:get/get.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_page.dart';
import '../modules/auth/views/register_page.dart';
import '../modules/landlord/bindings/landlord_binding_page.dart';
import '../modules/landlord/views/rooms_view/add_room_view.dart';
import '../modules/landlord/views/services_view/services_view.dart';
import '../modules/splash/splash_page.dart';
import '../modules/landlord/views/landlord_page.dart';
import '../modules/tenant/bindings/tenant_binding_page.dart';
import '../modules/tenant/views/tenant_page.dart';
import '../modules/tenant/views/room_search/room_search_view.dart';
import '../modules/tenant/views/room_details/room_details_view.dart';
import '../modules/landlord/views/room_requests/room_requests_view.dart';
import '../modules/tenant/views/requests/tenant_requests_view.dart';
import '../modules/tenant/views/payment_view/payment_view.dart';
import '../modules/landlord/views/contract/contract_view.dart';
import '../modules/landlord/views/bill/bill_view.dart';
import '../modules/landlord/views/bill/bill_details_view.dart';

// Định nghĩa các routes
abstract class Routes {
  static const SPLASH = '/';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const LANDLORD = '/landlord';
  static const TENANT = '/tenant';
  static const ADD_ROOM = '/add-room';
  static const TENANT_ROOM_SEARCH = '/tenant/room-search';
  static const TENANT_ROOM_DETAILS = '/tenant/room-details';
  static const LANDLORD_ROOM_REQUESTS = '/landlord/room-requests';
  static const TENANT_REQUESTS = '/tenant/requests';
  static const LANDLORD_SERVICES = '/landlord/services';
  static const TENANT_PAYMENT = '/tenant/payment';
  static const LANDLORD_CONTRACTS = '/landlord/contracts';
  static const LANDLORD_BILLS = '/landlord/bills';
  static const LANDLORD_BILL = '/landlord/bill';
  static const BILL_DETAILS = '/landlord/bill-details';
  static const TENANT_BILLS = '/tenant/bills';
  static const TENANT_SERVICES_VIEW = '/tenant/services-view';
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
      page: () => AddRoomView(),
    ),
    GetPage(
      name: Routes.TENANT_ROOM_SEARCH,
      page: () => const RoomSearchView(),
      binding: TenantBindingPage(),
    ),
    GetPage(
      name: Routes.TENANT_ROOM_DETAILS,
      page: () => const RoomDetailsView(),
      binding: TenantBindingPage(),
    ),
    GetPage(
      name: Routes.LANDLORD_ROOM_REQUESTS,
      page: () => const RoomRequestsView(),
      binding: LandlordBindingPage(),
    ),
    GetPage(
      name: Routes.TENANT_REQUESTS,
      page: () => const TenantRequestsView(),
      binding: TenantBindingPage(),
    ),
    GetPage(
      name: Routes.LANDLORD_SERVICES,
      page: () => const ServicesView(),
      binding: LandlordBindingPage(),
    ),
    GetPage(
      name: Routes.TENANT_PAYMENT,
      page: () => const PaymentView(),
      binding: TenantBindingPage(),
    ),
    GetPage(
      name: Routes.LANDLORD_CONTRACTS,
      page: () => const ContractView(),
      binding: LandlordBindingPage(),
    ),
    GetPage(
      name: Routes.LANDLORD_BILLS,
      page: () => const BillView(),
      binding: LandlordBindingPage(),
    ),
    GetPage(
      name: Routes.LANDLORD_BILL,
      page: () => const BillView(),
      binding: LandlordBindingPage(),
    ),
    GetPage(
      name: Routes.BILL_DETAILS,
      page: () => BillDetailsView(
        bill: Get.arguments,
      ),
      binding: LandlordBindingPage(),
    ),
    GetPage(
      name: Routes.TENANT_BILLS,
      page: () => const BillView(),
      binding: TenantBindingPage(),
    ),
    GetPage(
      name: Routes.TENANT_SERVICES_VIEW,
      page: () => const ServicesView(),
      binding: TenantBindingPage(),
    ),
  ];
}
