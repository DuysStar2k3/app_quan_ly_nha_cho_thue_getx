import 'package:get/get.dart';
import 'package:quan_ly_nha_thue/app/modules/auth/bindings/auth_binding.dart';
import 'package:quan_ly_nha_thue/app/modules/auth/views/login_page.dart';
import 'package:quan_ly_nha_thue/app/modules/auth/views/register_page.dart';
import 'package:quan_ly_nha_thue/app/modules/chat/bindings/chat_binding.dart';
import 'package:quan_ly_nha_thue/app/modules/chat/views/chat_room_view.dart';
import 'package:quan_ly_nha_thue/app/modules/landlord/bindings/edit_profile_binding.dart';
import 'package:quan_ly_nha_thue/app/modules/landlord/bindings/landlord_binding_page.dart';
import 'package:quan_ly_nha_thue/app/modules/landlord/views/bill_landlord/bill_details_landlord_view.dart';
import 'package:quan_ly_nha_thue/app/modules/landlord/views/bill_landlord/bill_landlord_view.dart';
import 'package:quan_ly_nha_thue/app/modules/landlord/views/chat_landlord/chat_landlord_view.dart';
import 'package:quan_ly_nha_thue/app/modules/landlord/views/contract_landlord/contract_landlord_view.dart';
import 'package:quan_ly_nha_thue/app/modules/landlord/views/home_landlord_view/home_landlord_view.dart';
import 'package:quan_ly_nha_thue/app/modules/landlord/views/landlord_page.dart';
import 'package:quan_ly_nha_thue/app/modules/landlord/views/notifications_landlord/notifications_landlord_view.dart';
import 'package:quan_ly_nha_thue/app/modules/landlord/views/room_requests_landlord/room_requests_landlord_view.dart';
import 'package:quan_ly_nha_thue/app/modules/landlord/views/rooms_landlord_view/add_room_landlord_view.dart';
import 'package:quan_ly_nha_thue/app/modules/landlord/views/rooms_landlord_view/rooms_landlord_view.dart';
import 'package:quan_ly_nha_thue/app/modules/landlord/views/rooms_landlord_view/update_service_landlord_view.dart';
import 'package:quan_ly_nha_thue/app/modules/landlord/views/rooms_landlord_view/update_tenant_view__landlord.dart';
import 'package:quan_ly_nha_thue/app/modules/landlord/views/services_landlord_view/services_landlord_view.dart';
import 'package:quan_ly_nha_thue/app/modules/landlord/views/settings_landlord_view/edit_profile_landlord_view.dart';
import 'package:quan_ly_nha_thue/app/modules/landlord/views/settings_landlord_view/settings_landlord_view.dart';
import 'package:quan_ly_nha_thue/app/modules/landlord/views/statistics_landlord/statistics_landlord_view.dart';
import 'package:quan_ly_nha_thue/app/modules/landlord/views/tenant_landlord_view/tenant_landlord_view.dart';
import 'package:quan_ly_nha_thue/app/modules/splash/splash_page.dart';
import 'package:quan_ly_nha_thue/app/modules/tenant/bindings/tenant_binding_page.dart';
import 'package:quan_ly_nha_thue/app/modules/tenant/views/bill_tenant/bill_tenant_view.dart';
import 'package:quan_ly_nha_thue/app/modules/tenant/views/bill_tenant/bindings/bill_tenant_binding.dart';
import 'package:quan_ly_nha_thue/app/modules/tenant/views/chat_tenant/bindings/chat_tenant_binding.dart';
import 'package:quan_ly_nha_thue/app/modules/tenant/views/chat_tenant/chat_tenant_view.dart';
import 'package:quan_ly_nha_thue/app/modules/tenant/views/contract_list_tenant_view/bindings/contract_binding.dart';
import 'package:quan_ly_nha_thue/app/modules/tenant/views/contract_list_tenant_view/contract_details_tenant_view.dart';
import 'package:quan_ly_nha_thue/app/modules/tenant/views/contract_list_tenant_view/contract_list_tenant_view.dart';
import 'package:quan_ly_nha_thue/app/modules/tenant/views/home_tenant_view/home-tenant_view.dart';
import 'package:quan_ly_nha_thue/app/modules/tenant/views/notifications_tenant/notifications_tenant_view.dart';
import 'package:quan_ly_nha_thue/app/modules/tenant/views/payment_tenant_view/payment_tenant_view.dart';
import 'package:quan_ly_nha_thue/app/modules/tenant/views/profile_tenant_view/profile_tenant_view.dart';
import 'package:quan_ly_nha_thue/app/modules/tenant/views/requests_tenant/bindings/tenant_requests_binding.dart';
import 'package:quan_ly_nha_thue/app/modules/tenant/views/requests_tenant/requests_tenant_view.dart';
import 'package:quan_ly_nha_thue/app/modules/tenant/views/room_details_tenant/room_details_tenant_view.dart';
import 'package:quan_ly_nha_thue/app/modules/tenant/views/room_search/bindings/room_search_tenant_binding.dart';
import 'package:quan_ly_nha_thue/app/modules/tenant/views/room_search/room_search_view.dart';
import 'package:quan_ly_nha_thue/app/modules/tenant/views/services_tenant_view/bindings/service_tenant_binding.dart';
import 'package:quan_ly_nha_thue/app/modules/tenant/views/services_tenant_view/services_tenant_view.dart';
import 'package:quan_ly_nha_thue/app/modules/tenant/views/settings_tenant_view/edit_profile_tenant_view.dart';
import 'package:quan_ly_nha_thue/app/modules/tenant/views/settings_tenant_view/settings_tenant_view.dart';
import 'package:quan_ly_nha_thue/app/modules/tenant/views/tenant_page.dart';

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
  static const LANDLORD_STATISTICS_VIEW = '/landlord/statistics-view';
  static const LANDLORD_TENANT_VIEW = '/landlord/tenant-view';
  static const LANDLORD_CHAT = '/landlord/chat';

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
  static const TENANT_STATISTICS_VIEW = '/tenant/statistics-view';
  static const TENANT_PROFILE_VIEW = '/tenant/profile-view';
  static const CHAT_ROOM = '/chat-room';
  static const TENANT_CHAT = '/tenant/chat';
  static const TENANT_CONTRACTS = '/tenant/contracts';
  static const TENANT_CONTRACT_DETAILS = '/tenant/contract-details';
  static const SERVICES_TENANT = '/tenant/services-tenant';
}

// Định nghĩa các pages
class AppPages {
  //đường dẫn mặc định

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    //đường dn của auth

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
      name: Routes.LANDLORD_STATISTICS_VIEW,
      page: () => const StatisticsLandlordView(),
      binding: LandlordBindingPage(),
    ),
    GetPage(
      name: Routes.LANDLORD_TENANT_VIEW,
      page: () => const TenantLandlordView(),
      binding: LandlordBindingPage(),
    ),
    GetPage(
      name: Routes.LANDLORD_CHAT,
      page: () => const ChatLandlordView(),
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
      binding: BillTenantBinding(),
    ),
    GetPage(
      name: Routes.TENANT_HOME_VIEW,
      page: () => const HomeTenantView(),
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
      binding: TenantRequestsBinding(),
    ),
    GetPage(
      name: Routes.TENANT_ROOM_DETAILS_VIEW,
      page: () => const RoomDetailsTenantView(),
      binding: TenantBindingPage(),
    ),
    GetPage(
      name: Routes.TENANT_ROOM_SEARCH,
      page: () => const RoomSearchView(),
      binding: RoomSearchTenantBinding(),
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
    GetPage(
      name: Routes.CHAT_ROOM,
      page: () => const ChatRoomView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: Routes.TENANT_CHAT,
      page: () => const ChatTenantView(),
      binding: ChatTenantBinding(),
    ),
    GetPage(
      name: Routes.TENANT_CONTRACTS,
      page: () => const ContractListTenantView(),
      binding: ContractBinding(),
    ),
    GetPage(
      name: Routes.TENANT_CONTRACT_DETAILS,
      page: () => ContractDetailsTenantView(
        contract: Get.arguments,
      ),
      binding: ContractBinding(),
    ),
    GetPage(
      name: Routes.SERVICES_TENANT,
      page: () => const ServicesTenantView(),
      binding: ServiceTenantBinding(),
    ),
  ];
}
