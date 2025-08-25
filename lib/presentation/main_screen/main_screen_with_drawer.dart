// lib/presentation/main_screen/main_screen_with_drawer.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/custom_icon_widget.dart';

class MainScreenWithDrawer extends StatelessWidget {
  final Widget child;
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final int currentBottomNavIndex;

  const MainScreenWithDrawer({
    Key? key,
    required this.child,
    required this.title,
    this.actions,
    this.showBackButton = false,
    this.currentBottomNavIndex = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Données utilisateur simulées - à remplacer par votre système de gestion d'état
    final userProfile = {
      'name': 'Sahidul Islam',
      'role': 'Employee',
      'avatar': 'https://via.placeholder.com/150',
      'presentDays': 22,
      'lateDays': 3,
      'absentDays': 5,
    };

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      
      // Drawer personnalisé
      drawer: CustomDrawer(userProfile: userProfile),
      
      // AppBar avec bouton menu ou retour
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: showBackButton
            ? IconButton(
                onPressed: () => Navigator.pop(context),
                icon: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 6,
                ),
              )
            : Builder(
                builder: (context) => IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: CustomIconWidget(
                    iconName: 'menu',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 6,
                  ),
                ),
              ),
        title: Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        actions: actions,
        centerTitle: true,
      ),
      
      // Contenu de l'écran
      body: child,
      
      // Bottom navigation bar
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
      unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      currentIndex: currentBottomNavIndex,
      onTap: (index) {
        _handleBottomNavTap(context, index);
      },
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'dashboard',
            color: currentBottomNavIndex == 0
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 6,
          ),
          label: 'Tableau de bord',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'group',
            color: currentBottomNavIndex == 1
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 6,
          ),
          label: 'Groupes',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'celebration',
            color: currentBottomNavIndex == 2
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 6,
          ),
          label: 'Fête',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'people',
            color: currentBottomNavIndex == 3
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 6,
          ),
          label: 'Parrainages',
        ),
      ],
    );
  }

  void _handleBottomNavTap(BuildContext context, int index) {
    String route = '';
    
    switch (index) {
      case 0:
        route = '/dashboard-screen';
        break;
      case 1:
        route = '/group-management-screen';
        break;
      case 2:
        route = '/seasonal-f-te-module-screen';
        break;
      case 3:
        route = '/referral-system-screen';
        break;
    }

    if (route.isNotEmpty && currentBottomNavIndex != index) {
      Navigator.pushReplacementNamed(context, route);
    }
  }
}


// Exemple d'utilisation dans vos écrans existants :

// lib/presentation/dashboard_screen/dashboard_screen_updated.dart
class DashboardScreenUpdated extends StatelessWidget {
  const DashboardScreenUpdated({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScreenWithDrawer(
      title: 'Tableau de Bord',
      currentBottomNavIndex: 0,
      actions: [
        IconButton(
          onPressed: () {
            // Action de notification
          },
          icon: CustomIconWidget(
            iconName: 'notifications',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6,
          ),
        ),
      ],
      child: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header de bienvenue
            _buildWelcomeHeader(),
            
            SizedBox(height: 3),
            
            // Cards de statistiques rapides
            _buildQuickStatsCards(),
            
            SizedBox(height: 3),
            
            // Section des actions rapides
            _buildQuickActions(context),
            
            SizedBox(height: 3),
            
            // Section des activités récentes
            _buildRecentActivities(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.lightTheme.colorScheme.primary,
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bonjour ! 👋',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          
          SizedBox(height: 1),
          
          Text(
            'Bienvenue sur votre tableau de bord TONTINE PRO',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Bulles Actives',
            value: '3',
            icon: 'group',
            color: Colors.blue,
          ),
        ),
        
        SizedBox(width: 3.w),
        
        Expanded(
          child: _buildStatCard(
            title: 'Solde Total',
            value: '125 000 FCFA',
            icon: 'account_balance_wallet',
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: icon,
              size: 6,
              color: color,
            ),
          ),
          
          SizedBox(height: 2),
          
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actions Rapides',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        
        SizedBox(height: 2),
        
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context: context,
                title: 'Nouveau Paiement',
                icon: 'payment',
                color: Colors.orange,
                onTap: () {
                  Navigator.pushNamed(context, '/payment-screen');
                },
              ),
            ),
            
            SizedBox(width: 3.w),
            
            Expanded(
              child: _buildActionCard(
                context: context,
                title: 'Rejoindre Bulle',
                icon: 'add_circle',
                color: Colors.purple,
                onTap: () {
                  Navigator.pushNamed(context, '/group-management-screen');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String title,
    required String icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              CustomIconWidget(
                iconName: icon,
                size: 8,
                color: color,
              ),
              
              SizedBox(height: 2),
              
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activités Récentes',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        
        SizedBox(height: 2),
        
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildActivityItem(
                title: 'Paiement effectué',
                subtitle: 'Bulle Famille - 25 000 FCFA',
                time: 'Il y a 2h',
                icon: 'payment',
                color: Colors.green,
              ),
              
              _buildActivityItem(
                title: 'Nouveau membre',
                subtitle: 'Aïcha Diallo a rejoint votre bulle',
                time: 'Il y a 1 jour',
                icon: 'person_add',
                color: Colors.blue,
              ),
              
              _buildActivityItem(
                title: 'Rappel de paiement',
                subtitle: 'Échéance dans 3 jours',
                time: 'Il y a 2 jours',
                icon: 'schedule',
                color: Colors.orange,
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required String title,
    required String subtitle,
    required String time,
    required String icon,
    required Color color,
    bool isLast = false,
  }) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: isLast ? null : Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          Text(
            time,
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}