import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class GroupStatisticsCard extends StatelessWidget {
  final Map<String, dynamic> statisticsData;

  const GroupStatisticsCard({
    Key? key,
    required this.statisticsData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
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
                iconName: 'analytics',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                'Statistiques du Groupe',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          SizedBox(height: 3),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  'Taux de Completion',
                  '${statisticsData['completionRate']}%',
                  'check_circle',
                  AppTheme.lightTheme.colorScheme.tertiary,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context,
                  'Temps Moyen',
                  '${statisticsData['averagePaymentTime']}h',
                  'schedule',
                  AppTheme.lightTheme.colorScheme.secondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 3),
          Text(
            'Santé du Groupe',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 2),
          _buildHealthIndicator(context),
          SizedBox(height: 3),
          Text(
            'Progression des Paiements',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 2),
          Container(
            height: 30,
            child: _buildPaymentChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    String iconName,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 24,
          ),
          SizedBox(height: 1),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHealthIndicator(BuildContext context) {
    final double healthScore =
        (statisticsData['healthScore'] as num).toDouble();
    final Color healthColor = _getHealthColor(healthScore);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _getHealthText(healthScore),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: healthColor,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Text(
              '${healthScore.toInt()}/100',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: healthColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        SizedBox(height: 1),
        LinearProgressIndicator(
          value: healthScore / 100,
          backgroundColor: AppTheme.lightTheme.colorScheme.primaryContainer,
          valueColor: AlwaysStoppedAnimation<Color>(healthColor),
          minHeight: 8,
        ),
      ],
    );
  }

  Widget _buildPaymentChart() {
    final List<dynamic> chartData =
        statisticsData['paymentHistory'] as List<dynamic>;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 5,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppTheme.lightTheme.dividerColor,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (double value, TitleMeta meta) {
                const style = TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                );
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text('J${value.toInt() + 1}', style: style),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 5,
              reservedSize: 42,
              getTitlesWidget: (double value, TitleMeta meta) {
                const style = TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                );
                return Text('${value.toInt()}', style: style);
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: AppTheme.lightTheme.dividerColor,
            width: 1,
          ),
        ),
        minX: 0,
        maxX: 9,
        minY: 0,
        maxY: 20,
        lineBarsData: [
          LineChartBarData(
            spots: chartData.asMap().entries.map((entry) {
              return FlSpot(
                entry.key.toDouble(),
                (entry.value as num).toDouble(),
              );
            }).toList(),
            isCurved: true,
            gradient: LinearGradient(
              colors: [
                AppTheme.lightTheme.primaryColor,
                AppTheme.lightTheme.colorScheme.secondary,
              ],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: AppTheme.lightTheme.primaryColor,
                  strokeWidth: 2,
                  strokeColor: AppTheme.lightTheme.colorScheme.surface,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                  AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getHealthColor(double score) {
    if (score >= 80) {
      return AppTheme.lightTheme.colorScheme.tertiary;
    } else if (score >= 60) {
      return AppTheme.lightTheme.colorScheme.secondary;
    } else {
      return AppTheme.lightTheme.colorScheme.error;
    }
  }

  String _getHealthText(double score) {
    if (score >= 80) {
      return 'Excellent';
    } else if (score >= 60) {
      return 'Bon';
    } else if (score >= 40) {
      return 'Moyen';
    } else {
      return 'Faible';
    }
  }
}
