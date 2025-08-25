import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class PickupSchedulingWidget extends StatefulWidget {
  final List<Map<String, dynamic>> availableSlots;
  final Function(Map<String, dynamic>) onSlotSelect;

  const PickupSchedulingWidget({
    Key? key,
    required this.availableSlots,
    required this.onSlotSelect,
  }) : super(key: key);

  @override
  State<PickupSchedulingWidget> createState() => _PickupSchedulingWidgetState();
}

class _PickupSchedulingWidgetState extends State<PickupSchedulingWidget> {
  Map<String, dynamic>? _selectedSlot;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
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
                  iconName: 'schedule',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Planifier le Retrait',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3),
            Text(
              'Créneaux disponibles:',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.availableSlots.length,
              separatorBuilder: (context, index) => SizedBox(height: 1),
              itemBuilder: (context, index) {
                final slot = widget.availableSlots[index];
                final isSelected = _selectedSlot?["id"] == slot["id"];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedSlot = slot;
                    });
                    widget.onSlotSelect(slot);
                  },
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1)
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(2.w),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.primary
                                : Colors.grey.shade300,
                            shape: BoxShape.circle,
                          ),
                          child: CustomIconWidget(
                            iconName: 'location_on',
                            color: isSelected
                                ? Colors.white
                                : Colors.grey.shade600,
                            size: 4,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                slot["location"] as String,
                                style: AppTheme.lightTheme.textTheme.titleSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? AppTheme.lightTheme.colorScheme.primary
                                      : null,
                                ),
                              ),
                              SizedBox(height: 0.5),
                              Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'access_time',
                                    color: Colors.grey.shade600,
                                    size: 3,
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    '${slot["date"]} - ${slot["timeSlot"]}',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 0.5),
                              Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'people',
                                    color: Colors.grey.shade600,
                                    size: 3,
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    '${slot["availableSpots"]} places disponibles',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          CustomIconWidget(
                            iconName: 'check_circle',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 5,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            if (_selectedSlot != null) ...[
              SizedBox(height: 3),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(2.w),
                  border: Border.all(
                    color: Colors.green.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: Colors.green.shade600,
                      size: 5,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Créneau sélectionné',
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: Colors.green.shade600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${_selectedSlot!["location"]} - ${_selectedSlot!["date"]}',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
