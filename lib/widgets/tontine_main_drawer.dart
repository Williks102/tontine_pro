// lib/widgets/tontine_main_drawer.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'custom_icon_widget.dart';

class TontineMainDrawer extends StatelessWidget {
  final Map<String, dynamic> userProfile;
  final int currentSelectedIndex;
  
  const TontineMainDrawer({
    Key? key,
    required this.userProfile,
    this.currentSelectedIndex = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      elevation: 16,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          _buildDrawerHeader(context),
          Expanded(
            child: _buildMainNavigation(context),
          ),
          _buildDrawerFooter(context),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 80, 16, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF6B73FF),
            Color(0x996B73FF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 32,
              backgroundColor: Colors.white,
              backgroundImage: userProfile['avatar'] != null
                  ? NetworkImage(userProfile['avatar'])
                  : null,
              child: userProfile['avatar'] == null
                  ? const CustomIconWidget(
                      iconName: 'person',
                      size: 32,
                      color: Color(0xFF6B73FF),
                    )
                  : null,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            userProfile['name'] ?? 'Utilisateur',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 4),
          
          Text(
            'ID: ${userProfile['id'] ?? 'TN-001'}',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.greenAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Membre Actif',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainNavigation(BuildContext context) {
    final mainSections = [
      {
        'icon': 'dashboard',
        'title': 'Tableau',
        'subtitle': 'Vue d\'ensemble et progression',
        'route': '/dashboard-screen',
        'index': 0,
        'color': const Color(0xFF6B73FF),
      },
      {
        'icon': 'payment',
        'title': 'Paiement',
        'subtitle': 'Cotisations et transactions',
        'route': '/payment-screen',
        'index': 1,
        'color': const Color(0xFF51CF66),
      },
      {
        'icon': 'group',
        'title': 'Groupes',
        'subtitle': 'Gestion des bulles',
        'route': '/group-management-screen',
        'index': 2,
        'color': const Color(0xFFFFD43B),
      },
      {
        'icon': 'people',
        'title': 'Parrainages',
        'subtitle': 'Système de parrainage',
        'route': '/referral-system-screen',
        'index': 3,
        'color': const Color(0xFF9C27B0),
      },
    ];

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(
            'Navigation Principale',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 0.5,
            ),
          ),
        ),
        
        ...mainSections.map((section) => _buildNavigationItem(
          context,
          icon: section['icon'] as String,
          title: section['title'] as String,
          subtitle: section['subtitle'] as String,
          route: section['route'] as String,
          color: section['color'] as Color,
          isSelected: currentSelectedIndex == section['index'],
        )),
        
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ),
        
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Options',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 0.5,
            ),
          ),
        ),
        
        _buildNavigationItem(
          context,
          icon: 'celebration',
          title: 'Fêtes',
          subtitle: 'Événements saisonniers',
          route: '/seasonal-f-te-module-screen',
          color: const Color(0xFFFF9800),
        ),
        
        _buildNavigationItem(
          context,
          icon: 'notifications',
          title: 'Notifications',
          subtitle: 'Alertes et rappels',
          route: '/notifications-screen',
          color: const Color(0xFF00BCD4),
        ),
        
        _buildNavigationItem(
          context,
          icon: 'support',
          title: 'Support',
          subtitle: 'Aide et assistance',
          route: '/support-screen',
          color: const Color(0xFF795548),
        ),
      ],
    );
  }

  Widget _buildNavigationItem(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    required String route,
    required Color color,
    bool isSelected = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: isSelected 
            ? color.withValues(alpha: 0.1) 
            : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        border: isSelected 
            ? Border.all(color: color.withValues(alpha: 0.3), width: 1.5)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            if (!isSelected) {
              Navigator.pushReplacementNamed(context, route);
            }
          },
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? color 
                        : color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ] : null,
                  ),
                  child: CustomIconWidget(
                    iconName: icon,
                    size: 20,
                    color: isSelected ? Colors.white : color,
                  ),
                ),
                
                const SizedBox(width: 16),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: isSelected 
                              ? FontWeight.bold 
                              : FontWeight.w600,
                          color: isSelected 
                              ? color 
                              : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    child: const CustomIconWidget(
                      iconName: 'check',
                      size: 12,
                      color: Colors.white,
                    ),
                  )
                else
                  const CustomIconWidget(
                    iconName: 'arrow_forward_ios',
                    size: 16,
                    color: Colors.grey,
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
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings-screen');
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: const Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'settings',
                      size: 20,
                      color: Colors.grey,
                    ),
                    
                    SizedBox(width: 16),
                    
                    Text(
                      'Paramètres',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                _showLogoutDialog(context);
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: const Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'logout',
                      size: 20,
                      color: Color(0xFFFF6B6B),
                    ),
                    
                    SizedBox(width: 16),
                    
                    Text(
                      'Déconnexion',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFF6B6B),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Row(
            children: [
              CustomIconWidget(
                iconName: 'logout',
                size: 24,
                color: Color(0xFFFF6B6B),
              ),
              SizedBox(width: 12),
              Text('Déconnexion'),
            ],
          ),
          content: const Text(
            'Êtes-vous sûr de vouloir vous déconnecter de TONTINE PRO ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Annuler',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/',
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B6B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Déconnexion'),
            ),
          ],
        );
      },
    );
  }
}