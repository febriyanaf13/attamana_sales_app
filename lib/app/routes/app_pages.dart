import 'package:get/get.dart';

import '../modules/account/bindings/account_binding.dart';
import '../modules/account/views/account_view.dart';
import '../modules/customer/bindings/customer_binding.dart';
import '../modules/customer/views/customer_view.dart';
import '../modules/cuti/bindings/cuti_binding.dart';
import '../modules/cuti/views/ajukan_cuti_view.dart';
import '../modules/cuti/views/cuti_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/fixedasset/bindings/fixedasset_binding.dart';
import '../modules/fixedasset/views/fixedasset_view.dart';
import '../modules/grafik/bindings/grafik_binding.dart';
import '../modules/grafik/views/grafik_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/izin/bindings/izin_binding.dart';
import '../modules/izin/views/izin_view.dart';
import '../modules/kasbon/bindings/kasbon_binding.dart';
import '../modules/kasbon/views/kasbon_view.dart';
import '../modules/kendaraan/bindings/kendaraan_binding.dart';
import '../modules/kendaraan/views/add_bensin_view.dart';
import '../modules/kendaraan/views/bensin_view.dart';
import '../modules/kendaraan/views/kendaraan_view.dart';
import '../modules/laporan/bindings/laporan_binding.dart';
import '../modules/laporan/views/laporan_view.dart';
import '../modules/lembur/bindings/lembur_binding.dart';
import '../modules/lembur/views/lembur_view.dart';
import '../modules/login/views/login_view.dart';
import '../modules/maintenance/bindings/maintenance_binding.dart';
import '../modules/maintenance/views/add_maintenance_view.dart';
import '../modules/maintenance/views/maintenance_view.dart';
import '../modules/maps/bindings/maps_binding.dart';
import '../modules/maps/views/maps_view.dart';
import '../modules/permohonan_ijin/bindings/permohonan_ijin_binding.dart';
import '../modules/permohonan_ijin/views/permohonan_ijin_view.dart';
import '../modules/reimburse/bindings/reimburse_binding.dart';
import '../modules/reimburse/views/reimburse_view.dart';
import '../modules/sales_module/activity/bindings/activity_binding.dart';
import '../modules/sales_module/activity/views/activity_view.dart';
import '../modules/sales_module/activity/views/add_activity_view.dart';
import '../modules/sales_module/activity/views/lead_view.dart';
import '../modules/sales_module/activity/views/presensi_activity_view.dart';
import '../modules/sales_module/agenda/bindings/agenda_binding.dart';
import '../modules/sales_module/agenda/views/agenda_view.dart';
import '../modules/sales_module/assign_sales/bindings/assign_sales_binding.dart';
import '../modules/sales_module/assign_sales/views/assign_sales_view.dart';
import '../modules/sales_module/assign_sales/views/edit_assign_sales_view.dart';
import '../modules/sales_module/inventory/bindings/inventory_binding.dart';
import '../modules/sales_module/inventory/views/inventory_view.dart';
import '../modules/sales_module/report_visit/bindings/report_visit_binding.dart';
import '../modules/sales_module/report_visit/views/report_visit_view.dart';
import '../modules/sales_module/sales_order/bindings/sales_order_binding.dart';
import '../modules/sales_module/sales_order/views/sales_order_view.dart';
import '../modules/sample_and_pricing/bindings/sample_and_pricing_binding.dart';
import '../modules/sample_and_pricing/views/sample_and_pricing_view.dart';
import '../modules/slip_gaji/bindings/slip_gaji_binding.dart';
import '../modules/slip_gaji/views/detail_slip_gaji_view.dart';
import '../modules/slip_gaji/views/slip_gaji_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/staff_home/bindings/staff_home_binding.dart';
import '../modules/staff_home/views/staff_home_view.dart';
import '../modules/teams/bindings/teams_binding.dart';
import '../modules/teams/views/teams_view.dart';
import '../modules/terlambat/bindings/terlambat_binding.dart';
import '../modules/terlambat/views/add_terlambat_view.dart';
import '../modules/terlambat/views/terlambat_view.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      bindings: [
        HomeBinding(),
        MapsBinding(),
        LaporanBinding(),
        GrafikBinding()
      ],
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LAPORAN,
      page: () => const LaporanView(),
      binding: LaporanBinding(),
    ),
    GetPage(
      name: _Paths.GRAFIK,
      page: () => const GrafikView(),
      binding: GrafikBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT,
      page: () => const AccountView(),
      binding: AccountBinding(),
    ),
    GetPage(
      name: _Paths.PERMOHONAN_IJIN,
      page: () => const PermohonanIjinView(),
      binding: PermohonanIjinBinding(),
    ),
    GetPage(
      name: _Paths.AGENDA,
      page: () => const AgendaView(),
      binding: AgendaBinding(),
    ),
    GetPage(
      name: _Paths.MAPS_VIEW,
      page: () => const MapsView(),
      binding: MapsBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      bindings: [
        DashboardBinding(),
        HomeBinding(),
        StaffHomeBinding(),
        MapsBinding(),
        CutiBinding(),
        AccountBinding()
      ],
    ),
    GetPage(
      name: _Paths.STAFF_HOME,
      page: () => const StaffHomeView(),
      binding: StaffHomeBinding(),
    ),
    GetPage(
      name: _Paths.ACTIVITY,
      page: () => const ActivityView(),
      binding: ActivityBinding(),
    ),
    GetPage(
      name: _Paths.ADD_ACTIVITY,
      page: () => const AddActivityView(),
      binding: ActivityBinding(),
    ),
    GetPage(
      name: _Paths.PRESENSI_ACTIVITY,
      page: () => const PresensiActivityView(),
      binding: ActivityBinding(),
    ),
    GetPage(
      name: _Paths.LEAD,
      page: () => const LeadView(),
      binding: ActivityBinding(),
    ),
    GetPage(
      name: _Paths.TEAMS,
      page: () => const TeamsView(),
      binding: TeamsBinding(),
    ),
    GetPage(
      name: _Paths.CUTI,
      page: () => const CutiView(),
      binding: CutiBinding(),
    ),
    GetPage(
      name: _Paths.AJUKAN_CUTI,
      page: () => const AjukanCutiView(),
      binding: CutiBinding(),
    ),
    GetPage(
      name: _Paths.IZIN,
      page: () => const IzinView(),
      binding: IzinBinding(),
    ),
    GetPage(
      name: _Paths.LEMBUR,
      page: () => LemburView(),
      binding: LemburBinding(),
    ),
    GetPage(
      name: _Paths.REIMBURSE,
      page: () => const ReimburseView(),
      binding: ReimburseBinding(),
    ),
    GetPage(
      name: _Paths.KASBON,
      page: () => const KasbonView(),
      binding: KasbonBinding(),
    ),
    GetPage(
      name: _Paths.TERLAMBAT,
      page: () => const TerlambatView(),
      binding: TerlambatBinding(),
    ),
    GetPage(
      name: _Paths.ADD_TERLAMBAT,
      page: () => const AddTerlambatView(),
      binding: TerlambatBinding(),
    ),
    GetPage(
      name: _Paths.REPORT_VISIT,
      page: () => const ReportVisitView(),
      binding: ReportVisitBinding(),
    ),
    GetPage(
      name: _Paths.INVENTORY,
      page: () => const InventoryView(),
      binding: InventoryBinding(),
    ),
    GetPage(
      name: _Paths.SO_MONITORING,
      page: () => const SalesOrderView(),
      binding: SalesOrderBinding(),
    ),
    GetPage(
      name: _Paths.SLIP_GAJI,
      page: () => const SlipGajiView(),
      binding: SlipGajiBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_SLIP_GAJI,
      page: () => const DetailSlipGajiView(),
      binding: SlipGajiBinding(),
    ),
    GetPage(
      name: _Paths.KENDARAAN,
      page: () => const KendaraanView(),
      binding: KendaraanBinding(),
    ),
    GetPage(
      name: _Paths.BENSIN,
      page: () => const BensinView(),
      binding: KendaraanBinding(),
    ),
    GetPage(
      name: _Paths.ADD_BENSIN,
      page: () => const AddBensinView(),
      binding: KendaraanBinding(),
    ),
    GetPage(
      name: _Paths.CUSTOMER,
      page: () => const CustomerView(),
      binding: CustomerBinding(),
    ),
    GetPage(
      name: _Paths.FIXEDASSET,
      page: () => const FixedassetView(),
      binding: FixedassetBinding(),
    ),
    GetPage(
      name: _Paths.MAINTENANCE,
      page: () => const MaintenanceView(),
      binding: MaintenanceBinding(),
    ),
    GetPage(
      name: _Paths.ADD_MAINTENANCE,
      page: () => const AddMaintenanceView(),
      binding: MaintenanceBinding(),
    ),
    GetPage(
      name: _Paths.ASSIGN_SALES,
      page: () => const AssignSalesView(),
      binding: AssignSalesBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_ASSIGN_SALES,
      page: () => const EditAssignSalesView(),
      binding: AssignSalesBinding(),
    ),
    GetPage(
      name: _Paths.SAMPLE_AND_PRICING,
      page: () => const SampleAndPricingView(),
      binding: SampleAndPricingBinding(),
    ),
  ];
}

class PresensiActivity {
  const PresensiActivity();
}
