import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TontineProgressWidget extends StatelessWidget {
  final int currentCycle;
  final int totalCycles;
  final int currentBeneficiary;
  final String beneficiaryName;
  final List<Map<String, dynamic>> memberProgress;

  const TontineProgressWidget({
    Key? key,
    required this.currentCycle,
    required this.totalCycles,
    required this.currentBeneficiary,
    required this.beneficiaryName,
    required this.memberProgress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progression du Cycle',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Cycle $currentCycle/$totalCycles',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.getSuccessColor(true),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'star',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bénéficiaire Actuel',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        '$beneficiaryName (Position $currentBeneficiary)',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppTheme.lightTheme.primaryColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Progression des Membres',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          SizedBox(
            height: 25.h,
            child: ListView.builder(
              itemCount: (memberProgress.length / 4).ceil(),
              itemBuilder: (context, rowIndex) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 1.h),
                  child: Row(
                    children: List.generate(4, (colIndex) {
                      final memberIndex = rowIndex * 4 + colIndex;
                      if (memberIndex >= memberProgress.length) {
                        return Expanded(child: Container());
                      }

                      final member = memberProgress[memberIndex];
                      final position = member['position'] as int;
                      final isPaid = member['isPaid'] as bool;
                      final isCurrent = position == currentBeneficiary;

                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                          child: Column(
                            children: [
                              Container(
                                width: 12.w,
                                height: 12.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isCurrent
                                      ? AppTheme.lightTheme.primaryColor
                                      : isPaid
                                          ? AppTheme.getSuccessColor(true)
                                          : AppTheme
                                              .lightTheme.colorScheme.outline,
                                  border: Border.all(
                                    color: isCurrent
                                        ? AppTheme.lightTheme.primaryColor
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: isCurrent
                                      ? CustomIconWidget(
                                          iconName: 'star',
                                          color: Colors.white,
                                          size: 16,
                                        )
                                      : isPaid
                                          ? CustomIconWidget(
                                              iconName: 'check',
                                              color: Colors.white,
                                              size: 16,
                                            )
                                          : Text(
                                              '$position',
                                              style: AppTheme.lightTheme
                                                  .textTheme.labelSmall
                                                  ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                member['name'] as String,
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  fontSize: 8.sp,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
