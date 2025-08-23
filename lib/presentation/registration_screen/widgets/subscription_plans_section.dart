import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SubscriptionPlansSection extends StatelessWidget {
  final String selectedPlan;
  final Function(String) onPlanSelected;

  const SubscriptionPlansSection({
    super.key,
    required this.selectedPlan,
    required this.onPlanSelected,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> subscriptionPlans = [
      {
        "id": "mini_pro",
        "name": "Mini Pro",
        "price": "2 500",
        "currency": "FCFA",
        "duration": "mois",
        "features": [
          "Groupes de 10 membres",
          "Cycles de 15 jours",
          "Support de base",
          "Notifications SMS"
        ],
        "color": AppTheme.lightTheme.colorScheme.secondary,
        "popular": false,
      },
      {
        "id": "pro",
        "name": "Pro",
        "price": "5 000",
        "currency": "FCFA",
        "duration": "mois",
        "features": [
          "Groupes de 20 membres",
          "Cycles de 10 jours",
          "Support prioritaire",
          "Notifications push",
          "Historique complet"
        ],
        "color": AppTheme.lightTheme.colorScheme.primary,
        "popular": true,
      },
      {
        "id": "pro_max",
        "name": "Pro Max",
        "price": "8 500",
        "currency": "FCFA",
        "duration": "mois",
        "features": [
          "Groupes illimités",
          "Cycles personnalisés",
          "Support 24/7",
          "Analytics avancées",
          "Référencement premium"
        ],
        "color": AppTheme.lightTheme.colorScheme.tertiary,
        "popular": false,
      },
      {
        "id": "pro_gold",
        "name": "Pro Gold",
        "price": "15 000",
        "currency": "FCFA",
        "duration": "mois",
        "features": [
          "Accès complet",
          "Gestion multi-groupes",
          "API personnalisée",
          "Formation dédiée",
          "Commission maximale"
        ],
        "color": Color(0xFFFFD700),
        "popular": false,
      },
    ];

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choisissez votre formule',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 35.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: subscriptionPlans.length,
              separatorBuilder: (context, index) => SizedBox(width: 3.w),
              itemBuilder: (context, index) {
                final plan = subscriptionPlans[index];
                final isSelected = selectedPlan == plan["id"];
                final isPopular = plan["popular"] as bool;

                return GestureDetector(
                  onTap: () => onPlanSelected(plan["id"] as String),
                  child: Container(
                    width: 70.w,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (plan["color"] as Color).withValues(alpha: 0.1)
                          : AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(3.w),
                      border: Border.all(
                        color: isSelected
                            ? (plan["color"] as Color)
                            : AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                        width: isSelected ? 0.5.w : 0.25.w,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: (plan["color"] as Color)
                                    .withValues(alpha: 0.2),
                                blurRadius: 2.w,
                                offset: Offset(0, 1.w),
                              ),
                            ]
                          : null,
                    ),
                    child: Stack(
                      children: [
                        if (isPopular)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 3.w,
                                vertical: 1.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(3.w),
                                  bottomLeft: Radius.circular(2.w),
                                ),
                              ),
                              child: Text(
                                'POPULAIRE',
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 8.sp,
                                ),
                              ),
                            ),
                          ),
                        Padding(
                          padding: EdgeInsets.all(4.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: isPopular ? 3.h : 1.h),
                              Row(
                                children: [
                                  Container(
                                    width: 1.w,
                                    height: 6.h,
                                    decoration: BoxDecoration(
                                      color: plan["color"] as Color,
                                      borderRadius: BorderRadius.circular(1.w),
                                    ),
                                  ),
                                  SizedBox(width: 3.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          plan["name"] as String,
                                          style: AppTheme
                                              .lightTheme.textTheme.titleMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: plan["color"] as Color,
                                          ),
                                        ),
                                        SizedBox(height: 0.5.h),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: plan["price"] as String,
                                                style: AppTheme.lightTheme
                                                    .textTheme.headlineSmall
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w800,
                                                  color: AppTheme.lightTheme
                                                      .colorScheme.onSurface,
                                                ),
                                              ),
                                              TextSpan(
                                                text: ' ${plan["currency"]}',
                                                style: AppTheme.lightTheme
                                                    .textTheme.bodyMedium
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: AppTheme
                                                      .lightTheme
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '/${plan["duration"]}',
                                                style: AppTheme.lightTheme
                                                    .textTheme.bodySmall
                                                    ?.copyWith(
                                                  color: AppTheme
                                                      .lightTheme
                                                      .colorScheme
                                                      .onSurfaceVariant,
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
                              SizedBox(height: 2.h),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Fonctionnalités incluses :',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    Expanded(
                                      child: ListView.separated(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount:
                                            (plan["features"] as List).length,
                                        separatorBuilder: (context, index) =>
                                            SizedBox(height: 0.5.h),
                                        itemBuilder: (context, featureIndex) {
                                          return Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 0.5.h),
                                                child: CustomIconWidget(
                                                  iconName: 'check_circle',
                                                  color: plan["color"] as Color,
                                                  size: 4.w,
                                                ),
                                              ),
                                              SizedBox(width: 2.w),
                                              Expanded(
                                                child: Text(
                                                  (plan["features"]
                                                          as List)[featureIndex]
                                                      as String,
                                                  style: AppTheme.lightTheme
                                                      .textTheme.bodySmall
                                                      ?.copyWith(
                                                    color: AppTheme.lightTheme
                                                        .colorScheme.onSurface,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(vertical: 1.h),
                                  decoration: BoxDecoration(
                                    color: plan["color"] as Color,
                                    borderRadius: BorderRadius.circular(2.w),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomIconWidget(
                                        iconName: 'check',
                                        color: Colors.white,
                                        size: 4.w,
                                      ),
                                      SizedBox(width: 2.w),
                                      Text(
                                        'Sélectionné',
                                        style: AppTheme
                                            .lightTheme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
