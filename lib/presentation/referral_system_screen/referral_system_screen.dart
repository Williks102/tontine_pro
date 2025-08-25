import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/commission_calculator_card.dart';
import './widgets/invitation_link_card.dart';
import './widgets/qr_code_generator.dart';
import './widgets/referral_history_list.dart';
import './widgets/referral_stats_card.dart';

class ReferralSystemScreen extends StatefulWidget {
  const ReferralSystemScreen({Key? key}) : super(key: key);

  @override
  State<ReferralSystemScreen> createState() => _ReferralSystemScreenState();
}

class _ReferralSystemScreenState extends State<ReferralSystemScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;

  // Mock user referral data
  final Map<String, dynamic> _userReferralData = {
    "totalInvites": 12,
    "successfulRegistrations": 8,
    "totalCommissions": 18500.0,
    "pendingCommissions": 3500.0,
    "referralCode": "TPRO2025-USER123",
    "invitationLink": "https://tontinepro.app/invite/TPRO2025-USER123",
    "internalReferrals": 5,
    "externalReferrals": 3,
    "monthlyEarnings": 12500.0,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _shareInvitationLink() async {
    try {
      // In real implementation, use share_plus package
      await Clipboard.setData(ClipboardData(
          text:
              "Rejoignez Tontine Pro avec mon code de parrainage ! ${_userReferralData['invitationLink']}"));

      Fluttertoast.showToast(
        msg: "Lien de parrainage copié et prêt à partager",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        textColor: AppTheme.lightTheme.colorScheme.onTertiary,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Erreur lors du partage",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        textColor: AppTheme.lightTheme.colorScheme.onError,
      );
    }
  }

  String _formatCurrency(double amount) {
    return "${amount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ').trim()} FCFA";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6,
          ),
        ),
        title: Text(
          "Système de Parrainage",
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/dashboard-screen');
            },
            icon: CustomIconWidget(
              iconName: 'dashboard',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.lightTheme.colorScheme.primary,
          unselectedLabelColor:
              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          indicatorColor: AppTheme.lightTheme.colorScheme.primary,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: "Parrainages"),
            Tab(text: "Historique"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildReferralsTab(),
          _buildHistoryTab(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildReferralsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.lightTheme.colorScheme.primary,
                  AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'people',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 8,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        "Invitez vos proches",
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  "Gagnez des commissions en parrainant de nouveaux membres dans Tontine Pro. Plus vous parrainez, plus vous gagnez !",
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary
                        .withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Stats Cards Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ReferralStatsCard(
                title: "Invitations envoyées",
                value: "${_userReferralData['totalInvites']}",
                subtitle: "Ce mois-ci",
                accentColor: AppTheme.lightTheme.colorScheme.primary,
                iconData: Icons.send,
              ),
              ReferralStatsCard(
                title: "Inscriptions réussies",
                value: "${_userReferralData['successfulRegistrations']}",
                subtitle:
                    "Taux: ${((_userReferralData['successfulRegistrations'] as int) / (_userReferralData['totalInvites'] as int) * 100).toInt()}%",
                accentColor: AppTheme.lightTheme.colorScheme.tertiary,
                iconData: Icons.person_add,
              ),
            ],
          ),

          SizedBox(height: 2.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ReferralStatsCard(
                title: "Commissions totales",
                value: _formatCurrency(
                    _userReferralData['totalCommissions'] as double),
                subtitle: "Depuis le début",
                accentColor: AppTheme.lightTheme.colorScheme.secondary,
                iconData: Icons.monetization_on,
              ),
              ReferralStatsCard(
                title: "En attente",
                value: _formatCurrency(
                    _userReferralData['pendingCommissions'] as double),
                subtitle: "À recevoir",
                accentColor: AppTheme.lightTheme.colorScheme.outline,
                iconData: Icons.schedule,
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Invitation Link Card
          InvitationLinkCard(
            invitationLink: _userReferralData['invitationLink'] as String,
            onShare: _shareInvitationLink,
          ),

          SizedBox(height: 3.h),

          // Commission Calculator
          const CommissionCalculatorCard(),

          SizedBox(height: 3.h),

          // QR Code Generator
          QrCodeGenerator(
            referralCode: _userReferralData['referralCode'] as String,
          ),

          SizedBox(height: 3.h),

          // Referral Program Info
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info',
                      color:
                          AppTheme.lightTheme.colorScheme.onTertiaryContainer,
                      size: 5,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      "Comment ça marche ?",
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color:
                            AppTheme.lightTheme.colorScheme.onTertiaryContainer,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                _buildInfoItem("Parrainage interne",
                    "2 500 FCFA par personne qui rejoint une tontine"),
                SizedBox(height: 1.h),
                _buildInfoItem("Parrainage externe",
                    "1 500 FCFA par personne qui s'inscrit seulement"),
                SizedBox(height: 1.h),
                _buildInfoItem(
                    "Paiement", "Commissions versées chaque fin de mois"),
              ],
            ),
          ),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          const ReferralHistoryList(),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 1.5,
          height: 1.5,
          margin: EdgeInsets.only(top: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.onTertiaryContainer,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onTertiaryContainer,
                ),
              ),
              Text(
                description,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onTertiaryContainer
                      .withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
      unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      currentIndex: 3, // Referral system is at index 3
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/dashboard-screen');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/group-management-screen');
            break;
          case 2:
            Navigator.pushReplacementNamed(
                context, '/seasonal-f-te-module-screen');
            break;
          case 3:
            // Current screen - do nothing
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'dashboard',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 6,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'dashboard',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 6,
          ),
          label: 'Tableau de bord',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'group',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 6,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'group',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 6,
          ),
          label: 'Groupes',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'celebration',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 6,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'celebration',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 6,
          ),
          label: 'Fête',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'people',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 6,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'people',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 6,
          ),
          label: 'Parrainages',
        ),
      ],
    );
  }
}
