import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/group_statistics_widget.dart';
import './widgets/notification_center_widget.dart';
import './widgets/payment_status_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/tontine_progress_widget.dart';
import './widgets/user_greeting_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isRefreshing = false;

  // Mock user data
  final Map<String, dynamic> _userData = {
    "name": "Marie Kouassi",
    "profileImage":
        "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
    "currentPosition": 7,
    "groupName": "Groupe Espoir",
  };

  // Mock tontine progress data
  final List<Map<String, dynamic>> _memberProgress = [
    {"position": 1, "name": "Aminata", "isPaid": true},
    {"position": 2, "name": "Fatou", "isPaid": true},
    {"position": 3, "name": "Koffi", "isPaid": true},
    {"position": 4, "name": "Adjoa", "isPaid": true},
    {"position": 5, "name": "Yao", "isPaid": true},
    {"position": 6, "name": "Akissi", "isPaid": false},
    {"position": 7, "name": "Marie", "isPaid": false},
    {"position": 8, "name": "Konan", "isPaid": false},
    {"position": 9, "name": "Aya", "isPaid": false},
    {"position": 10, "name": "Brou", "isPaid": false},
    {"position": 11, "name": "Adjoua", "isPaid": false},
    {"position": 12, "name": "Kouame", "isPaid": false},
    {"position": 13, "name": "Affoue", "isPaid": false},
    {"position": 14, "name": "Didier", "isPaid": false},
    {"position": 15, "name": "Mariam", "isPaid": false},
    {"position": 16, "name": "Sekou", "isPaid": false},
    {"position": 17, "name": "Aissata", "isPaid": false},
    {"position": 18, "name": "Ibrahim", "isPaid": false},
    {"position": 19, "name": "Fatoumata", "isPaid": false},
    {"position": 20, "name": "Moussa", "isPaid": false},
  ];

  // Mock payment data
  final Map<String, dynamic> _paymentData = {
    "nextPaymentDate": DateTime.now().add(const Duration(days: 3)),
    "paymentAmount": 5500.0,
    "daysRemaining": 3,
    "isOverdue": false,
    "paymentStatus": "pending",
  };

  // Mock statistics data
  final Map<String, dynamic> _statisticsData = {
    "totalContributions": 275000.0,
    "remainingCycles": 15,
    "participationRate": 85.5,
  };

  // Mock monthly data for chart
  final List<Map<String, dynamic>> _monthlyData = [
    {"month": "Jan", "amount": 45000.0},
    {"month": "Fév", "amount": 52000.0},
    {"month": "Mar", "amount": 48000.0},
    {"month": "Avr", "amount": 55000.0},
    {"month": "Mai", "amount": 50000.0},
    {"month": "Jun", "amount": 58000.0},
  ];

  // Mock notifications data
  final List<Map<String, dynamic>> _notifications = [
    {
      "type": "payment",
      "title": "Paiement confirmé",
      "message": "Votre paiement de 5 500 FCFA a été confirmé avec succès.",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "isRead": false,
    },
    {
      "type": "info",
      "title": "Nouveau bénéficiaire",
      "message": "Akissi sera la prochaine bénéficiaire du cycle.",
      "timestamp": DateTime.now().subtract(const Duration(hours: 5)),
      "isRead": false,
    },
    {
      "type": "warning",
      "title": "Rappel de paiement",
      "message": "N'oubliez pas votre paiement dans 3 jours.",
      "timestamp": DateTime.now().subtract(const Duration(days: 1)),
      "isRead": true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _handleMakePayment() {
    // Navigate to payment screen or show payment dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Redirection vers le paiement...'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _handleViewHistory() {
    // Navigate to payment history screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Affichage de l\'historique...'),
        backgroundColor: AppTheme.getSuccessColor(true),
      ),
    );
  }

  void _handleContactSupport() {
    // Navigate to support screen or open chat
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Ouverture du support client...'),
        backgroundColor: AppTheme.getWarningColor(true),
      ),
    );
  }

  void _handleReferFriends() {
    // Navigate to referral screen
    Navigator.pushNamed(context, '/referral-system-screen');
  }

  void _handleViewAllNotifications() {
    // Navigate to notifications screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Affichage de toutes les notifications...'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'Tontine Pro',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: _handleViewAllNotifications,
                icon: CustomIconWidget(
                  iconName: 'notifications',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              ),
              if (_notifications.any((n) => !(n['isRead'] as bool? ?? true)))
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 2.w),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tableau de bord'),
            Tab(text: 'Paiements'),
            Tab(text: 'Groupes'),
            Tab(text: 'Profil'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildDashboardTab(),
            _buildPaymentsTab(),
            _buildGroupsTab(),
            _buildProfileTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardTab() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppTheme.lightTheme.primaryColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserGreetingWidget(
              userName: _userData['name'] as String,
              profileImageUrl: _userData['profileImage'] as String,
              currentPosition: _userData['currentPosition'] as int,
              groupName: _userData['groupName'] as String,
            ),
            SizedBox(height: 2.h),
            TontineProgressWidget(
              currentCycle: 5,
              totalCycles: 20,
              currentBeneficiary: 6,
              beneficiaryName: 'Akissi',
              memberProgress: _memberProgress,
            ),
            SizedBox(height: 2.h),
            PaymentStatusWidget(
              nextPaymentDate: _paymentData['nextPaymentDate'] as DateTime,
              paymentAmount: _paymentData['paymentAmount'] as double,
              daysRemaining: _paymentData['daysRemaining'] as int,
              isOverdue: _paymentData['isOverdue'] as bool,
              paymentStatus: _paymentData['paymentStatus'] as String,
            ),
            SizedBox(height: 2.h),
            GroupStatisticsWidget(
              totalContributions:
                  _statisticsData['totalContributions'] as double,
              remainingCycles: _statisticsData['remainingCycles'] as int,
              participationRate: _statisticsData['participationRate'] as double,
              monthlyData: _monthlyData,
            ),
            SizedBox(height: 2.h),
            QuickActionsWidget(
              onMakePayment: _handleMakePayment,
              onViewHistory: _handleViewHistory,
              onContactSupport: _handleContactSupport,
              onReferFriends: _handleReferFriends,
            ),
            SizedBox(height: 2.h),
            NotificationCenterWidget(
              notifications: _notifications,
              onViewAll: _handleViewAllNotifications,
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'payment',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Section Paiements',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Gérez vos paiements et consultez votre historique',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGroupsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'groups',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Gestion des Groupes',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Consultez et gérez vos groupes de tontine',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/group-management-screen');
            },
            child: const Text('Gérer les Groupes'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.lightTheme.primaryColor,
                width: 3,
              ),
            ),
            child: ClipOval(
              child: CustomImageWidget(
                imageUrl: _userData['profileImage'] as String,
                width: 20.w,
                height: 20.w,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            _userData['name'] as String,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Position ${_userData['currentPosition']} • ${_userData['groupName']}',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/identity-verification-screen');
            },
            child: const Text('Vérification d\'Identité'),
          ),
          SizedBox(height: 1.h),
          OutlinedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/seasonal-f-te-module-screen');
            },
            child: const Text('Module Fête Saisonnière'),
          ),
        ],
      ),
    );
  }
}
