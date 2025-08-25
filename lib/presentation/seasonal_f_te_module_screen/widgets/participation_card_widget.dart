import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class ParticipationCardWidget extends StatefulWidget {
  final bool isEnrolled;
  final Function(bool) onEnrollmentToggle;
  final VoidCallback onPayment;

  const ParticipationCardWidget({
    Key? key,
    required this.isEnrolled,
    required this.onEnrollmentToggle,
    required this.onPayment,
  }) : super(key: key);

  @override
  State<ParticipationCardWidget> createState() =>
      _ParticipationCardWidgetState();
}

class _ParticipationCardWidgetState extends State<ParticipationCardWidget> {
  bool _isVoluntaryParticipation = false;

  @override
  void initState() {
    super.initState();
    _isVoluntaryParticipation = widget.isEnrolled;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 1.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3.w),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'card_giftcard',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Participation Volontaire',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.w),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Montant de contribution',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    '4 200 FCFA',
                    style:
                        AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.w),
                border: Border.all(
                  color: Colors.amber.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: Colors.amber.shade700,
                    size: 5,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Participation entièrement volontaire - Aucune obligation',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.amber.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Switch(
                  value: _isVoluntaryParticipation,
                  onChanged: (value) {
                    setState(() {
                      _isVoluntaryParticipation = value;
                    });
                    widget.onEnrollmentToggle(value);
                  },
                  activeThumbColor: AppTheme.lightTheme.colorScheme.primary,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    _isVoluntaryParticipation
                        ? 'Participation activée'
                        : 'Activer la participation',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isVoluntaryParticipation ? widget.onPayment : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isVoluntaryParticipation
                      ? AppTheme.lightTheme.colorScheme.primary
                      : Colors.grey.shade300,
                  foregroundColor: _isVoluntaryParticipation
                      ? Colors.white
                      : Colors.grey.shade600,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'payment',
                      color: _isVoluntaryParticipation
                          ? Colors.white
                          : Colors.grey.shade600,
                      size: 5,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Procéder au paiement',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: _isVoluntaryParticipation
                            ? Colors.white
                            : Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
