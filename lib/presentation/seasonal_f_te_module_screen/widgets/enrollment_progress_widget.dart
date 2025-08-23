import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class EnrollmentProgressWidget extends StatelessWidget {
  final int currentEnrollment;
  final int targetEnrollment;
  final List<Map<String, dynamic>> recentParticipants;

  const EnrollmentProgressWidget({
    Key? key,
    required this.currentEnrollment,
    required this.targetEnrollment,
    required this.recentParticipants,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progressPercentage =
        (currentEnrollment / targetEnrollment).clamp(0.0, 1.0);

    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
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
                  iconName: 'trending_up',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Progression Communautaire',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Participants inscrits',
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
                Text(
                  '$currentEnrollment/$targetEnrollment',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Container(
              width: double.infinity,
              height: 1.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(1.h),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progressPercentage,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.lightTheme.colorScheme.primary,
                        AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(1.h),
                  ),
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              '${(progressPercentage * 100).round()}% de l\'objectif atteint',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Derniers participants:',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            SizedBox(
              height: 8.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: recentParticipants.length,
                separatorBuilder: (context, index) => SizedBox(width: 2.w),
                itemBuilder: (context, index) {
                  final participant = recentParticipants[index];

                  return Column(
                    children: [
                      Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: CustomImageWidget(
                            imageUrl: participant["avatar"] as String,
                            width: 12.w,
                            height: 12.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      SizedBox(
                        width: 15.w,
                        child: Text(
                          participant["name"] as String,
                          style: AppTheme.lightTheme.textTheme.labelSmall,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 3.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade50,
                    Colors.blue.shade100,
                  ],
                ),
                borderRadius: BorderRadius.circular(2.w),
                border: Border.all(
                  color: Colors.blue.shade200,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'group',
                    color: Colors.blue.shade600,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Engagement Communautaire',
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Plus de participants = plus de cadeaux disponibles!',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: Colors.blue.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
