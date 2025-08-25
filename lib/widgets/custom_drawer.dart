// lib/widgets/custom_drawer.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../theme/app_theme.dart';
import 'custom_icon_widget.dart';

class CustomDrawer extends StatelessWidget {
  final Map<String, dynamic> userProfile;
  
  const CustomDrawer({
    Key? key,
    required this.userProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      elevation: 16,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header avec profil utilisateur
          _buildDrawerHeader(context),
          
          // Statistiques de présence
          _buildAttendanceStats(),
          
          // Menu items
          Expanded(
            child: _buildMenuItems(context),
          ),
          
          // Footer avec logout
          _buildDrawerFooter(context),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(4, 12, 4, 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.lightTheme.colorScheme.primary,
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // Photo de profil avec animation
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 8,
              backgroundColor: Colors.white,
              backgroundImage: userProfile['avatar'] != null
                  ? NetworkImage(userProfile['avatar'])
                  : null,
              child: userProfile['avatar'] == null
                  ? CustomIconWidget(
                      iconName: 'person',
                      size: 8,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    )
                  : null,
            ),
          ),
          
          SizedBox(height: 2),
          
          // Nom et statut
          Text(
            userProfile['name'] ?? 'Utilisateur',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          SizedBox(height: 0.5),
          
          Text(
            userProfile['role'] ?? 'Employé',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceStats() {
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            value: userProfile['presentDays']?.toString() ?? '22',
            label: 'Présent',
            color: AppTheme.lightTheme.colorScheme.tertiary,
            icon: 'check_circle',
          ),
          _buildStatItem(
            value: userProfile['lateDays']?.toString() ?? '3',
            label: 'Retard',
            color: Colors.orange,
            icon: 'schedule',
          ),
          _buildStatItem(
            value: userProfile['absentDays']?.toString() ?? '5',
            label: 'Absent',
            color: AppTheme.lightTheme.colorScheme.error,
            icon: 'cancel',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    required Color color,
    required String icon,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: CustomIconWidget(
            iconName: icon,
            size: 6,
            color: color,
          ),
        ),
        
        SizedBox(height: 1),
        
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    final menuItems = [
      {
        'icon': 'person',
        'title': 'Employee Profile',
        'route': '/employee-profile-screen',
        'color': AppTheme.lightTheme.colorScheme.primary,
      },
      {
        'icon': 'video_call',
        'title': 'Live Video Calling & Charting',
        'route': '/video-call-screen',
        'color': Colors.blue,
      },
      {
        'icon': 'notifications',
        'title': 'Notification',
        'route': '/notifications-screen',
        'color': Colors.orange,
      },
      {
        'icon': 'description',
        'title': 'Terms & Conditions',
        'route': '/terms-conditions-screen',
        'color': Colors.green,
      },
      {
        'icon': 'privacy_tip',
        'title': 'Privacy Policy',
        'route': '/privacy-policy-screen',
        'color': Colors.purple,
      },
    ];

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      children: menuItems.map((item) => _buildMenuItem(
        context,
        icon: item['icon'] as String,
        title: item['title'] as String,
        route: item['route'] as String,
        color: item['color'] as Color,
      )).toList(),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String icon,
    required String title,
    required String route,
    required Color color,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0.5),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            Navigator.pop(context); // Ferme le drawer
            Navigator.pushNamed(context, route);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 3,
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: icon,
                    size: 5,
                    color: color,
                  ),
                ),
                
                SizedBox(width: 4.w),
                
                Expanded(
                  child: Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                ),
                
                CustomIconWidget(
                  iconName: 'arrow_forward_ios',
                  size: 4,
                  color: Colors.grey[400]!,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _showLogoutDialog(context);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 3,
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'logout',
                    size: 5,
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                ),
                
                SizedBox(width: 4.w),
                
                Text(
                  'Logout',
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Déconnexion'),
          content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/splash-screen',
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
              ),
              child: const Text('Déconnexion'),
            ),
          ],
        );
      },
    );
  }
}