import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class ReferralHistoryList extends StatelessWidget {
  const ReferralHistoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> referralHistory = [
      {
        "id": 1,
        "name": "Marie Kouassi",
        "email": "marie.kouassi@email.com",
        "type": "internal",
        "status": "earning",
        "inviteDate": DateTime.now().subtract(const Duration(days: 15)),
        "registrationDate": DateTime.now().subtract(const Duration(days: 12)),
        "commission": 2500.0,
        "avatar":
            "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400"
      },
      {
        "id": 2,
        "name": "Jean Baptiste Traoré",
        "email": "jean.traore@email.com",
        "type": "external",
        "status": "registered",
        "inviteDate": DateTime.now().subtract(const Duration(days: 8)),
        "registrationDate": DateTime.now().subtract(const Duration(days: 5)),
        "commission": 1500.0,
        "avatar":
            "https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=400"
      },
      {
        "id": 3,
        "name": "Fatou Diallo",
        "email": "fatou.diallo@email.com",
        "type": "internal",
        "status": "active",
        "inviteDate": DateTime.now().subtract(const Duration(days: 25)),
        "registrationDate": DateTime.now().subtract(const Duration(days: 20)),
        "commission": 2500.0,
        "avatar":
            "https://images.pexels.com/photos/1181686/pexels-photo-1181686.jpeg?auto=compress&cs=tinysrgb&w=400"
      },
      {
        "id": 4,
        "name": "Amadou Sanogo",
        "email": "amadou.sanogo@email.com",
        "type": "external",
        "status": "pending",
        "inviteDate": DateTime.now().subtract(const Duration(days: 3)),
        "registrationDate": null,
        "commission": 0.0,
        "avatar":
            "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=400"
      },
      {
        "id": 5,
        "name": "Aissatou Kone",
        "email": "aissatou.kone@email.com",
        "type": "internal",
        "status": "earning",
        "inviteDate": DateTime.now().subtract(const Duration(days: 45)),
        "registrationDate": DateTime.now().subtract(const Duration(days: 40)),
        "commission": 2500.0,
        "avatar":
            "https://images.pexels.com/photos/1130626/pexels-photo-1130626.jpeg?auto=compress&cs=tinysrgb&w=400"
      },
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'history',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  "Historique des parrainages",
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: referralHistory.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final referral = referralHistory[index];
              return _buildReferralHistoryItem(referral);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReferralHistoryItem(Map<String, dynamic> referral) {
    final String status = referral["status"] as String;
    final String type = referral["type"] as String;
    final double commission = referral["commission"] as double;

    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (status) {
      case 'earning':
        statusColor = AppTheme.lightTheme.colorScheme.tertiary;
        statusText = 'Génère des revenus';
        statusIcon = Icons.monetization_on;
        break;
      case 'active':
        statusColor = AppTheme.lightTheme.colorScheme.primary;
        statusText = 'Actif';
        statusIcon = Icons.check_circle;
        break;
      case 'registered':
        statusColor = AppTheme.lightTheme.colorScheme.secondary;
        statusText = 'Inscrit';
        statusIcon = Icons.person_add;
        break;
      case 'pending':
      default:
        statusColor = AppTheme.lightTheme.colorScheme.outline;
        statusText = 'En attente';
        statusIcon = Icons.schedule;
        break;
    }

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          // Avatar
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: CustomImageWidget(
              imageUrl: referral["avatar"] as String,
              width: 12.w,
              height: 12.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 3.w),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  referral["name"] as String,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  referral["email"] as String,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: type == 'internal'
                            ? AppTheme.lightTheme.colorScheme.primaryContainer
                            : AppTheme
                                .lightTheme.colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        type == 'internal' ? 'Interne' : 'Externe',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: type == 'internal'
                              ? AppTheme
                                  .lightTheme.colorScheme.onPrimaryContainer
                              : AppTheme
                                  .lightTheme.colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    CustomIconWidget(
                      iconName: statusIcon.codePoint.toString(),
                      color: statusColor,
                      size: 3.w,
                    ),
                    SizedBox(width: 1.w),
                    Expanded(
                      child: Text(
                        statusText,
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Commission
          if (commission > 0)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${commission.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ').trim()} FCFA",
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  "Commission",
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
