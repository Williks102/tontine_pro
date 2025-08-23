import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class NotificationSettingsCard extends StatefulWidget {
  final Map<String, dynamic> notificationSettings;
  final Function(String, bool) onSettingChanged;

  const NotificationSettingsCard({
    Key? key,
    required this.notificationSettings,
    required this.onSettingChanged,
  }) : super(key: key);

  @override
  State<NotificationSettingsCard> createState() =>
      _NotificationSettingsCardState();
}

class _NotificationSettingsCardState extends State<NotificationSettingsCard> {
  late Map<String, bool> _settings;

  @override
  void initState() {
    super.initState();
    _settings = Map<String, bool>.from(widget.notificationSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
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
                iconName: 'notifications',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                'Paramètres de Notification',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildNotificationItem(
            'Rappels de Paiement',
            'paymentReminders',
            'Recevoir des rappels avant l\'échéance',
            'payment',
          ),
          _buildNotificationItem(
            'Annonces de Bénéficiaire',
            'beneficiaryAnnouncements',
            'Être notifié des nouveaux bénéficiaires',
            'person_pin',
          ),
          _buildNotificationItem(
            'Activité du Groupe',
            'groupActivity',
            'Notifications sur l\'activité générale',
            'group_work',
          ),
          _buildNotificationItem(
            'Messages Administrateur',
            'adminMessages',
            'Messages importants de l\'administrateur',
            'admin_panel_settings',
          ),
          _buildNotificationItem(
            'Mises à Jour Système',
            'systemUpdates',
            'Nouvelles fonctionnalités et mises à jour',
            'system_update',
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
    String title,
    String key,
    String description,
    String iconName,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.primaryColor,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          Switch(
            value: _settings[key] ?? false,
            onChanged: (bool value) {
              setState(() {
                _settings[key] = value;
              });
              widget.onSettingChanged(key, value);
            },
            activeColor: AppTheme.lightTheme.primaryColor,
            inactiveThumbColor:
                AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            inactiveTrackColor:
                AppTheme.lightTheme.colorScheme.primaryContainer,
          ),
        ],
      ),
    );
  }
}
