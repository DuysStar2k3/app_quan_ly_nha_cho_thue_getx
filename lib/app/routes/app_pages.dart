import 'package:get/get.dart';
import 'package:quan_ly_nha_thue/app/modules/landlord/bindings/edit_profile_binding.dart';
import 'package:quan_ly_nha_thue/app/modules/landlord/views/home_landlord_view/home_landlord_view.dart';
import 'package:quan_ly_nha_thue/app/modules/landlord/views/notifications_landlord/notifications_landlord_view.dart';
import 'package:quan_ly_nha_thue/app/modules/landlord/views/rooms_landlord_view/rooms_landlord_view.dart';
import 'package:quan_ly_nha_thue/app/modules/landlord/views/rooms_landlord_view/update_service_landlord_view.dart';
import 'package:quan_ly_nha_thue/app/modules/landlord/views/rooms_landlord_view/update_tenant_view__landlord.dart';
import 'package:quan_ly_nha_thue/app/modules/landlord/views/settings_landlord_view/edit_profile_landlord_view.dart';
import 'package:quan_ly_nha_thue/app/modules/landlord/views/settings_landlord_view/settings_landlord_view.dart';
import 'package:quan_ly_nha_thue/app/modules/landlord/views/tenant_landlord_view/tenant_landlord_view.dart';
import 'package:quan_ly_nha_thue/app/modules/tenant/views/bill_tenant/bill_tenant_view.dart';
import 'package:quan_ly_nha_thue/app/modules/tenant/views/home_tenant_view/home-tenant_view.dart';
import 'package:quan_ly_nha_thue/app/modules/tenant/views/notifications_tenant/notifications_tenant_view.dart';
import 'package:quan_ly_nha_thue/app/modules/tenant/views/settings_tenant_view/edit_profile_tenant_view.dart';
import 'package:quan_ly_nha_thue/app/modules/tenant/views/settings_tenant_view/settings_tenant_view.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_page.dart';
import '../modules/auth/views/register_page.dart';
import '../modules/landlord/bindings/landlord_binding_page.dart';
import '../modules/landlord/views/rooms_landlord_view/add_room_landlord_view.dart';
import '../modules/landlord/views/services_landlord_view/services_landlord_view.dart';
import '../modules/splash/splash_page.dart';
import '../modules/landlord/views/landlord_page.dart';
import '../modules/tenant/bindings/tenant_binding_page.dart';
import '../modules/tenant/views/tenant_page.dart';
import '../modules/tenant/views/room_search/room_search_view.dart';
import '../modules/tenant/views/room_details_tenant/room_details_tenant_view.dart';
import '../modules/landlord/views/room_requests_landlord/room_requests_landlord_view.dart';
import '../modules/tenant/views/requests_tenant/requests_tenant_view.dart';
import '../modules/tenant/views/payment_tenant_view/payment_tenant_view.dart';
import '../modules/landlord/views/contract_landlord/contract_landlord_view.dart';
import '../modules/landlord/views/bill_landlord/bill_landlord_view.dart';
import '../modules/landlord/views/bill_landlord/bill_details_landlord_view.dart';
import '../modules/tenant/views/profile_tenant_view/profile_tenant_view.dart';

// Định nghĩa các routes
abstract class Routes {
  //đường dẫn của auth
  static const LOGIN = '/login';
  static const REGISTER = '/register';

  //đường dẫn của chủ nhà
  static const LANDLORD_PAGE = '/landlord-page';
  static const LANDLORD_BILL = '/landlord/bill';
  static const LANDLORD_BILL_VIEW = '/landlord/bills-view';
  static const LANDLORD_BILL_DETAILS_VIEW = '/landlord/bill-details-view';
  static const LANDLORD_CONTRACTS_VIEW = '/landlord/contracts-view';
  static const LANDLORD_HOME_VIEW = '/landlord/home-view';
  static const LANDLORD_NOTIFICATIONS_VIEW = '/landlord/notifications-view';
  static const LANDLORD_ROOM_REQUESTS_VIEW = '/landlord/room-requests-view';
  static const LANDLORD_ADD_ROOM_VIEW = '/landlord/add-room-view';
  static const LANDLORD_ROOMS_VIEW = '/landlord/rooms-view';
  static const LANDLORD_UPDATE_SERVICE_VIEW = '/landlord/update-service-view';
  static const LANDLORD_UPDATE_TENANT_VIEW = '/landlord/update-tenant-view';
  static const LANDLORD_SERVICE_VIEW = '/landlord/service-view';
  static const LANDLORD_EDIT_PROFILE_VIEW = '/landlord/edit-profile-view';
  static const LANDLORD_SETTINGS_VIEW = '/landlord/settings-view';
  static const LANDLORD_TENANT_VIEW = '/landlord/tenant-view';

  //đường dẫn của trang splash
  static const SPLASH = '/';

  //đường dẫn của khách thuê nhà
  static const TENANT_PAGE = '/tenant-page';
  static const TENANT_BILL_DETAILS_VIEW = '/tenant/bill-details-view';
  static const TENANT_BILL_VIEW = '/tenant/bill-view';
  static const TENANT_HOME_VIEW = '/tenant/home-view';
  static const TENANT_NOTIFICATIONS_VIEW = '/tenant/notifications-view';
  static const TENANT_PAYMENT_VIEW = '/tenant/payment-view';
  static const TENANT_REQUESTS_VIEW = '/tenant/requests-view';
  static const TENANT_ROOM_DETAILS_VIEW = '/tenant/room-details-view';
  static const TENANT_ROOM_SEARCH = '/tenant/room-search';
  static const TENANT_EDIT_PROFILE_VIEW = '/tenant/edit-profile-view';
  static const TENANT_SETTINGS_VIEW = '/tenant/settings-view';
  static const TENANT_PROFILE_VIEW = '/tenant/profile-view';
}

// Định nghĩa các pages
class AppPages {
  //đường dẫn mặc định

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    //đường dẫn của auth

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

    //đường dẫn của chủ nhà
    GetPage(
      name: Routes.LANDLORD_PAGE,
      page: () => const LandlordPage(),
      binding: LandlordBindingPage(),
    ),
    GetPage(
      name: Routes.LANDLORD_BILL,
      page: () => const BillLandlordView(),
      binding: LandlordBindingPage(),
    ),
    GetPage(
      name: Routes.LANDLORD_BILL_VIEW,
      page: () => const BillLandlordView(),
      binding: LandlordBindingPage(),
    ),
    GetPage(
      name: Routes.LANDLORD_BILL_DETAILS_VIEW,
      page: () => BillDetailsLandlordView(
        bill: Get.arguments,
      ),
      binding: LandlordBindingPage(),
    ),
    GetPage(
      name: Routes.LANDLORD_CONTRACTS_VIEW,
      page: () => const ContractLandlordView(),
      binding: LandlordBindingPage(),
    ),
    GetPage(
      name: Routes.LANDLORD_HOME_VIEW,
      page: () => HomeLandlordView(),
      binding: LandlordBindingPage(),
    ),
    GetPage(
      name: Routes.LANDLORD_NOTIFICATIONS_VIEW,
      page: () => const NotificationsLandlordView(),
      binding: LandlordBindingPage(),
    ),
    GetPage(
      name: Routes.LANDLORD_ROOM_REQUESTS_VIEW,
      page: () => const RoomRequestsLandlordView(),
      binding: LandlordBindingPage(),
    ),
    GetPage(
      name: Routes.LANDLORD_ADD_ROOM_VIEW,
      page: () => AddRoomLandlordView(),
    ),
    GetPage(
      name: Routes.LANDLORD_ROOMS_VIEW,
      page: () => const RoomsLandlordView(),
      binding: LandlordBindingPage(),
    ),
    GetPage(
      name: Routes.LANDLORD_UPDATE_SERVICE_VIEW,
      page: () => const UpdateServiceLandlordView(),
      binding: LandlordBindingPage(),
    ),
    GetPage(
      name: Routes.LANDLORD_UPDATE_TENANT_VIEW,
      page: () => const UpdateTenantLandlordView(),
      binding: LandlordBindingPage(),
    ),
    GetPage(
      name: Routes.LANDLORD_SERVICE_VIEW,
      page: () => const ServicesLandlordView(),
      binding: LandlordBindingPage(),
    ),
    GetPage(
      name: Routes.LANDLORD_EDIT_PROFILE_VIEW,
      page: () => EditProfileLandlordView(),
      binding: LandlordBindingPage(),
    ),
    GetPage(
      name: Routes.LANDLORD_SETTINGS_VIEW,
      page: () => const SettingsLandlordView(),
      binding: LandlordBindingPage(),
    ),
    GetPage(
      name: Routes.LANDLORD_TENANT_VIEW,
      page: () => const TenantLandlordView(),
      binding: LandlordBindingPage(),
    ),

    //đường dẫn của trang splash

    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashPage(),
    ),

    //đường dẫn của khách thuê nhà

    GetPage(
      name: Routes.TENANT_PAGE,
      page: () => const TenantPage(),
      binding: TenantBindingPage(),
    ),
    GetPage(
      name: Routes.TENANT_BILL_DETAILS_VIEW,
      page: () => BillDetailsLandlordView(
        bill: Get.arguments,
      ),
      binding: LandlordBindingPage(),
    ),
    GetPage(
      name: Routes.TENANT_BILL_VIEW,
      page: () => const BillTenantView(),
      binding: TenantBindingPage(),
    ),
    GetPage(
      name: Routes.TENANT_HOME_VIEW,
      page: () => const HomeTenantView(),
      binding: TenantBindingPage(),
    ),
    GetPage(
      name: Routes.TENANT_NOTIFICATIONS_VIEW,
      page: () => const NotificationsTenantView(),
      binding: TenantBindingPage(),
    ),
    GetPage(
      name: Routes.TENANT_PAYMENT_VIEW,
      page: () => const PaymentTenantView(),
      binding: TenantBindingPage(),
    ),
    GetPage(
      name: Routes.TENANT_REQUESTS_VIEW,
      page: () => const RequestsTenantView(),
      binding: TenantBindingPage(),
    ),
    GetPage(
      name: Routes.TENANT_ROOM_DETAILS_VIEW,
      page: () => const RoomDetailsTenantView(),
      binding: TenantBindingPage(),
    ),
    GetPage(
      name: Routes.TENANT_ROOM_SEARCH,
      page: () => const RoomSearchView(),
      binding: TenantBindingPage(),
    ),
    GetPage(
      name: Routes.TENANT_EDIT_PROFILE_VIEW,
      page: () => EditProfileTenantView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: Routes.TENANT_SETTINGS_VIEW,
      page: () => const SettingsTenantView(),
      binding: TenantBindingPage(),
    ),
    GetPage(
      name: Routes.TENANT_PROFILE_VIEW,
      page: () => const ProfileTenantView(),
    ),
  ];
}
