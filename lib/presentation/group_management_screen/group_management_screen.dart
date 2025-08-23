import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/group_info_card.dart';
import './widgets/group_statistics_card.dart';
import './widgets/member_list_item.dart';
import './widgets/notification_settings_card.dart';

class GroupManagementScreen extends StatefulWidget {
  const GroupManagementScreen({Key? key}) : super(key: key);

  @override
  State<GroupManagementScreen> createState() => _GroupManagementScreenState();
}

class _GroupManagementScreenState extends State<GroupManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isRefreshing = false;

  // Mock data for the group
  final Map<String, dynamic> _groupData = {
    'id': 'G001',
    'name': 'Groupe Solidarité Dakar',
    'status': 'active',
    'currentMembers': 18,
    'totalMembers': 20,
    'currentDay': 7,
    'nextBeneficiary': 'Aminata D.',
    'announcement':
        'Rappel: Paiement dû dans 2 jours. Merci de respecter les délais.',
  };

  // Mock statistics data
  final Map<String, dynamic> _statisticsData = {
    'completionRate': 92,
    'averagePaymentTime': 6,
    'healthScore': 85,
    'paymentHistory': [15, 18, 16, 19, 17, 20, 18, 19, 16, 18],
  };

  // Mock notification settings
  Map<String, dynamic> _notificationSettings = {
    'paymentReminders': true,
    'beneficiaryAnnouncements': true,
    'groupActivity': false,
    'adminMessages': true,
    'systemUpdates': false,
  };

  // Mock members data
  final List<Map<String, dynamic>> _membersData = [
    {
      'id': 1,
      'name': 'Aminata Diallo',
      'avatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
      'position': 1,
      'paymentStatus': 'paid',
      'paymentStreak': 7,
      'completedPayments': 18,
    },
    {
      'id': 2,
      'name': 'Mamadou Sow',
      'avatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
      'position': 2,
      'paymentStatus': 'paid',
      'paymentStreak': 6,
      'completedPayments': 17,
    },
    {
      'id': 3,
      'name': 'Fatou Ndiaye',
      'avatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
      'position': 3,
      'paymentStatus': 'pending',
      'paymentStreak': 5,
      'completedPayments': 15,
    },
    {
      'id': 4,
      'name': 'Ousmane Ba',
      'avatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
      'position': 4,
      'paymentStatus': 'paid',
      'paymentStreak': 8,
      'completedPayments': 19,
    },
    {
      'id': 5,
      'name': 'Aissatou Cissé',
      'avatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
      'position': 5,
      'paymentStatus': 'late',
      'paymentStreak': 0,
      'completedPayments': 12,
    },
    {
      'id': 6,
      'name': 'Ibrahima Fall',
      'avatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
      'position': 6,
      'paymentStatus': 'paid',
      'paymentStreak': 4,
      'completedPayments': 16,
    },
    {
      'id': 7,
      'name': 'Mariam Touré',
      'avatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
      'position': 7,
      'paymentStatus': 'paid',
      'paymentStreak': 9,
      'completedPayments': 20,
    },
    {
      'id': 8,
      'name': 'Cheikh Diop',
      'avatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
      'position': 8,
      'paymentStatus': 'pending',
      'paymentStreak': 3,
      'completedPayments': 14,
    },
    {
      'id': 9,
      'name': 'Khady Sarr',
      'avatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
      'position': 9,
      'paymentStatus': 'paid',
      'paymentStreak': 6,
      'completedPayments': 17,
    },
    {
      'id': 10,
      'name': 'Moussa Diouf',
      'avatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
      'position': 10,
      'paymentStatus': 'paid',
      'paymentStreak': 7,
      'completedPayments': 18,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Gestion du Groupe'),
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: _showMoreOptions,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Membres'),
            Tab(text: 'Statistiques'),
            Tab(text: 'Notifications'),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            GroupInfoCard(groupData: _groupData),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildMembersTab(),
                  _buildStatisticsTab(),
                  _buildNotificationsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMembersTab() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Rechercher un membre...',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'search',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: CustomIconWidget(
                        iconName: 'clear',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshMembers,
            child: _filteredMembers.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: _filteredMembers.length,
                    itemBuilder: (context, index) {
                      final member = _filteredMembers[index];
                      return MemberListItem(
                        memberData: member,
                        isAdmin: true,
                        onTap: () => _showMemberDetails(member),
                        onViewProfile: () => _viewMemberProfile(member),
                        onSendMessage: () => _sendMessageToMember(member),
                        onReportIssue: () => _reportMemberIssue(member),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsTab() {
    return SingleChildScrollView(
      child: GroupStatisticsCard(statisticsData: _statisticsData),
    );
  }

  Widget _buildNotificationsTab() {
    return SingleChildScrollView(
      child: NotificationSettingsCard(
        notificationSettings: _notificationSettings,
        onSettingChanged: _updateNotificationSetting,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'group_off',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            _searchQuery.isNotEmpty
                ? 'Aucun membre trouvé'
                : 'Aucun membre dans ce groupe',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            _searchQuery.isNotEmpty
                ? 'Essayez avec un autre terme de recherche'
                : 'Les membres apparaîtront ici une fois ajoutés',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
          if (_searchQuery.isEmpty) ...[
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/referral-system-screen');
              },
              child: const Text('Inviter des Membres'),
            ),
          ],
        ],
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredMembers {
    if (_searchQuery.isEmpty) {
      return _membersData;
    }
    return _membersData.where((member) {
      final name = (member['name'] as String).toLowerCase();
      final position = member['position'].toString();
      return name.contains(_searchQuery) || position.contains(_searchQuery);
    }).toList();
  }

  Future<void> _refreshMembers() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Données mises à jour'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showMemberDetails(Map<String, dynamic> member) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 3.h),
              CircleAvatar(
                radius: 8.w,
                backgroundImage: NetworkImage(member['avatar'] as String),
              ),
              SizedBox(height: 2.h),
              Text(
                member['name'] as String,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                'Position ${member['position']}e',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
              ),
              SizedBox(height: 3.h),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _buildDetailItem(
                        'Statut de Paiement',
                        _getPaymentStatusText(
                            member['paymentStatus'] as String)),
                    _buildDetailItem('Série de Paiements',
                        '${member['paymentStreak']} jours'),
                    _buildDetailItem('Paiements Complétés',
                        '${member['completedPayments']}/20'),
                    _buildDetailItem('Taux de Réussite',
                        '${((member['completedPayments'] as int) / 20 * 100).toInt()}%'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  void _viewMemberProfile(Map<String, dynamic> member) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profil de ${member['name']} ouvert'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _sendMessageToMember(Map<String, dynamic> member) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Message envoyé à ${member['name']}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _reportMemberIssue(Map<String, dynamic> member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Signaler un Problème'),
        content:
            Text('Voulez-vous signaler un problème avec ${member['name']} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Problème signalé pour ${member['name']}'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Signaler'),
          ),
        ],
      ),
    );
  }

  void _updateNotificationSetting(String key, bool value) {
    setState(() {
      _notificationSettings[key] = value;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Paramètre de notification mis à jour'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'dashboard',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: const Text('Tableau de Bord'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/dashboard-screen');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: const Text('Système de Parrainage'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/referral-system-screen');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'celebration',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 24,
              ),
              title: const Text('Module Fête'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/seasonal-f-te-module-screen');
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  String _getPaymentStatusText(String status) {
    switch (status) {
      case 'paid':
        return 'Payé';
      case 'pending':
        return 'En attente';
      case 'late':
        return 'En retard';
      default:
        return 'Inconnu';
    }
  }
}
