import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class QrCodeGenerator extends StatefulWidget {
  final String referralCode;

  const QrCodeGenerator({
    Key? key,
    required this.referralCode,
  }) : super(key: key);

  @override
  State<QrCodeGenerator> createState() => _QrCodeGeneratorState();
}

class _QrCodeGeneratorState extends State<QrCodeGenerator> {
  bool _isQrVisible = false;

  void _toggleQrVisibility() {
    setState(() {
      _isQrVisible = !_isQrVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                iconName: 'qr_code',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  "Code QR de parrainage",
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            "Partagez votre code de parrainage en personne avec un code QR",
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),
          if (_isQrVisible) ...[
            Center(
              child: Container(
                width: 50.w,
                height: 50.w,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // QR Code placeholder - In real implementation, use qr_flutter package
                    Container(
                      width: 35.w,
                      height: 35.w,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'qr_code_2',
                          color: Colors.white,
                          size: 20.w,
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      widget.referralCode,
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _toggleQrVisibility,
                    icon: CustomIconWidget(
                      iconName: 'visibility_off',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 4.w,
                    ),
                    label: Text(
                      "Masquer QR",
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // In real implementation, save QR code to gallery
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              const Text("Code QR sauvegardé dans la galerie"),
                          backgroundColor:
                              AppTheme.lightTheme.colorScheme.tertiary,
                        ),
                      );
                    },
                    icon: CustomIconWidget(
                      iconName: 'download',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 4.w,
                    ),
                    label: Text(
                      "Sauvegarder",
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            Center(
              child: ElevatedButton.icon(
                onPressed: _toggleQrVisibility,
                icon: CustomIconWidget(
                  iconName: 'qr_code_scanner',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 5.w,
                ),
                label: Text(
                  "Générer le code QR",
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
