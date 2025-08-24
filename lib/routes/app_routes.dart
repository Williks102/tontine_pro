import 'package:flutter/material.dart';
import '../presentation/dashboard_screen/dashboard_screen.dart';
import '../presentation/referral_system_screen/referral_system_screen.dart';
import '../presentation/group_management_screen/group_management_screen.dart';
import '../presentation/identity_verification_screen/identity_verification_screen.dart';
import '../presentation/seasonal_f_te_module_screen/seasonal_f_te_module_screen.dart';
import '../presentation/registration_screen/registration_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String dashboard = '/dashboard-screen';
  static const String referralSystem = '/referral-system-screen';
  static const String groupManagement = '/group-management-screen';
  static const String identityVerification = '/identity-verification-screen';
  static const String seasonalFTeModule = '/seasonal-f-te-module-screen';
  static const String registration = '/registration-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const DashboardScreen(),
    dashboard: (context) => const DashboardScreen(),
    referralSystem: (context) => const ReferralSystemScreen(),
    groupManagement: (context) => const GroupManagementScreen(),
    identityVerification: (context) => const IdentityVerificationScreen(),
    seasonalFTeModule: (context) => const SeasonalFTeModuleScreen(),
    registration: (context) => const RegistrationScreen(),
   
  };
}
