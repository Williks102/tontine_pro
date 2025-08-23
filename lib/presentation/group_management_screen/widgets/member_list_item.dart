import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class MemberListItem extends StatelessWidget {
  final Map<String, dynamic> memberData;
  final bool isAdmin;
  final VoidCallback? onTap;
  final VoidCallback? onViewProfile;
  final VoidCallback? onSendMessage;
  final VoidCallback? onReportIssue;

  const MemberListItem({
    Key? key,
    required this.memberData,
    this.isAdmin = false,
    this.onTap,
    this.onViewProfile,
    this.onSendMessage,
    this.onReportIssue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('member_${memberData['id']}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 4.w),
        color: AppTheme.lightTheme.colorScheme.primaryContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (onViewProfile != null) ...[
              CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
              SizedBox(width: 2.w),
            ],
            if (isAdmin && onSendMessage != null) ...[
              CustomIconWidget(
                iconName: 'message',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
              SizedBox(width: 2.w),
            ],
            if (onReportIssue != null) ...[
              CustomIconWidget(
                iconName: 'report',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 20,
              ),
            ],
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        _showActionSheet(context);
        return false;
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.lightTheme.dividerColor,
            width: 1,
          ),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          leading: Stack(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _getPaymentStatusColor(),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: CustomImageWidget(
                    imageUrl: memberData['avatar'] as String,
                    width: 12.w,
                    height: 12.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 4.w,
                  height: 4.w,
                  decoration: BoxDecoration(
                    color: _getPaymentStatusColor(),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      width: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  memberData['name'] as String,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${memberData['position']}e',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 1.h),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'payments',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Série: ${memberData['paymentStreak']} jours',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const Spacer(),
                  Text(
                    _getPaymentStatusText(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getPaymentStatusColor(),
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              _buildProgressIndicator(),
            ],
          ),
          trailing: CustomIconWidget(
            iconName: 'chevron_right',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final int completedPayments = memberData['completedPayments'] as int;
    final int totalPayments = 20;
    final double progress = completedPayments / totalPayments;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progression',
              style: TextStyle(
                fontSize: 10.sp,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              '$completedPayments/$totalPayments',
              style: TextStyle(
                fontSize: 10.sp,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppTheme.lightTheme.colorScheme.primaryContainer,
          valueColor: AlwaysStoppedAnimation<Color>(
            _getPaymentStatusColor(),
          ),
          minHeight: 4,
        ),
      ],
    );
  }

  Color _getPaymentStatusColor() {
    final String status = memberData['paymentStatus'] as String;
    switch (status) {
      case 'paid':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'pending':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'late':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _getPaymentStatusText() {
    final String status = memberData['paymentStatus'] as String;
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

  void _showActionSheet(BuildContext context) {
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
            Text(
              memberData['name'] as String,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 3.h),
            if (onViewProfile != null)
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'person',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
                title: const Text('Voir le profil'),
                onTap: () {
                  Navigator.pop(context);
                  onViewProfile?.call();
                },
              ),
            if (isAdmin && onSendMessage != null)
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'message',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
                title: const Text('Envoyer un message'),
                onTap: () {
                  Navigator.pop(context);
                  onSendMessage?.call();
                },
              ),
            if (onReportIssue != null)
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'report',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 24,
                ),
                title: const Text('Signaler un problème'),
                onTap: () {
                  Navigator.pop(context);
                  onReportIssue?.call();
                },
              ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
