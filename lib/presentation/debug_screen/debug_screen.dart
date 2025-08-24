import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

// Couleurs TONTINE PRO
class TontineColors {
  static const Color primaryPurple = Color(0xFF6B3AA0);
  static const Color goldStart = Color(0xFFFFD700);
  static const Color goldEnd = Color(0xFFFF8C00);
}

class DebugScreen extends StatelessWidget {
  const DebugScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              TontineColors.primaryPurple,
              Color(0xFF9C27B0),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                SizedBox(height: 4.h),
                
                // Logo et titre
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.developer_mode,
                        size: 15.w,
                        color: Colors.white,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'TONTINE PRO',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Mode Développement',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 4.h),
                
                // Menu des écrans - Version scrollable
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 2.h),
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Navigation des écrans',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: TontineColors.primaryPurple,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          
                          // Cards de navigation
                          _buildNavigationCard(
                            context,
                            icon: Icons.person_add,
                            title: 'Inscription',
                            subtitle: 'Formulaire d\'inscription utilisateur',
                            route: '/registration-screen',
                            color: Colors.blue,
                          ),
                          
                          _buildNavigationCard(
                            context,
                            icon: Icons.verified_user,
                            title: 'Vérification d\'identité',
                            subtitle: 'OTP et vérification des documents',
                            route: '/identity-verification-screen',
                            color: Colors.green,
                          ),
                          
                          _buildNavigationCard(
                            context,
                            icon: Icons.group,
                            title: 'Gestion des groupes',
                            subtitle: 'Choix et gestion des bulles',
                            route: '/group-management-screen',
                            color: Colors.orange,
                          ),
                          
                          _buildNavigationCard(
                            context,
                            icon: Icons.dashboard,
                            title: 'Dashboard',
                            subtitle: 'Tableau de bord principal',
                            route: '/dashboard-screen',
                            color: TontineColors.primaryPurple,
                          ),
                          
                          _buildNavigationCard(
                            context,
                            icon: Icons.card_giftcard,
                            title: 'Module Fête',
                            subtitle: 'Événements saisonniers',
                            route: '/seasonal-f-te-module-screen',
                            color: Colors.pink,
                          ),
                          
                          _buildNavigationCard(
                            context,
                            icon: Icons.people,
                            title: 'Système de Parrainage',
                            subtitle: 'Gestion des parrains et filleuls',
                            route: '/referral-system-screen',
                            color: Colors.teal,
                          ),
                          
                          SizedBox(height: 2.h),
                          
                          // Info développement
                          Container(
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.grey[600],
                                  size: 5.w,
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: Text(
                                    'Utilisez ce menu pour naviguer facilement entre les écrans pendant le développement.',
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String route,
    required Color color,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, route);
          },
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[200]!),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 6.w,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 4.w,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}