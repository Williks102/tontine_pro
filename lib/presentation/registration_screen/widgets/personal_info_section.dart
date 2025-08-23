import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PersonalInfoSection extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final String? firstNameError;
  final String? lastNameError;
  final String? emailError;
  final String? phoneError;
  final Function(String) onFirstNameChanged;
  final Function(String) onLastNameChanged;
  final Function(String) onEmailChanged;
  final Function(String) onPhoneChanged;

  const PersonalInfoSection({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    this.firstNameError,
    this.lastNameError,
    this.emailError,
    this.phoneError,
    required this.onFirstNameChanged,
    required this.onLastNameChanged,
    required this.onEmailChanged,
    required this.onPhoneChanged,
  });

  @override
  Widget build(BuildContext context) {
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
            'Informations personnelles',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: firstNameController,
                      onChanged: onFirstNameChanged,
                      decoration: InputDecoration(
                        labelText: 'Prénom *',
                        hintText: 'Entrez votre prénom',
                        errorText: firstNameError,
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'person',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 5.w,
                          ),
                        ),
                      ),
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.name,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: lastNameController,
                      onChanged: onLastNameChanged,
                      decoration: InputDecoration(
                        labelText: 'Nom *',
                        hintText: 'Entrez votre nom',
                        errorText: lastNameError,
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'person_outline',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 5.w,
                          ),
                        ),
                      ),
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.name,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          TextFormField(
            controller: emailController,
            onChanged: onEmailChanged,
            decoration: InputDecoration(
              labelText: 'Adresse e-mail *',
              hintText: 'exemple@email.com',
              errorText: emailError,
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'email',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 5.w,
                ),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
          ),
          SizedBox(height: 2.h),
          TextFormField(
            controller: phoneController,
            onChanged: onPhoneChanged,
            decoration: InputDecoration(
              labelText: 'Numéro de téléphone *',
              hintText: '+225 XX XX XX XX XX',
              errorText: phoneError,
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'phone',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 5.w,
                ),
              ),
            ),
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }
}
