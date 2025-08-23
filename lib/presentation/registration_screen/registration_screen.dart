import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/personal_info_section.dart';
import './widgets/profile_photo_section.dart';
import './widgets/subscription_plans_section.dart';
import './widgets/terms_and_referral_section.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final PageController _pageController = PageController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Form controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _referralCodeController = TextEditingController();

  // Form state
  int _currentStep = 0;
  XFile? _capturedImage;
  String _selectedPlan = 'pro';
  bool _acceptedTerms = false;
  bool _isLoading = false;

  // Validation errors
  String? _firstNameError;
  String? _lastNameError;
  String? _emailError;
  String? _phoneError;
  String? _referralCodeError;

  @override
  void dispose() {
    _pageController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _referralCodeController.dispose();
    super.dispose();
  }

  // Validation methods
  String? _validateName(String value, String fieldName) {
    if (value.trim().isEmpty) {
      return '$fieldName est requis';
    }
    if (value.trim().length < 2) {
      return '$fieldName doit contenir au moins 2 caractères';
    }
    if (!RegExp(r'^[a-zA-ZÀ-ÿ\s-]+$').hasMatch(value.trim())) {
      return '$fieldName ne peut contenir que des lettres';
    }
    return null;
  }

  String? _validateEmail(String value) {
    if (value.trim().isEmpty) {
      return 'L\'adresse e-mail est requise';
    }
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value.trim())) {
      return 'Veuillez entrer une adresse e-mail valide';
    }
    return null;
  }

  String? _validatePhone(String value) {
    if (value.trim().isEmpty) {
      return 'Le numéro de téléphone est requis';
    }
    final cleanPhone = value.replaceAll(RegExp(r'[^\d+]'), '');
    if (cleanPhone.length < 8) {
      return 'Numéro de téléphone invalide';
    }
    return null;
  }

  String? _validateReferralCode(String value) {
    if (value.trim().isEmpty) return null;

    // Mock validation - in real app, this would check against database
    final validCodes = ['TONTINE2024', 'WELCOME123', 'FRIEND456', 'FAMILY789'];
    if (!validCodes.contains(value.trim().toUpperCase())) {
      return 'Code de parrainage invalide';
    }
    return null;
  }

  void _validateCurrentStep() {
    setState(() {
      switch (_currentStep) {
        case 0:
          _firstNameError =
              _validateName(_firstNameController.text, 'Le prénom');
          _lastNameError = _validateName(_lastNameController.text, 'Le nom');
          _emailError = _validateEmail(_emailController.text);
          _phoneError = _validatePhone(_phoneController.text);
          break;
        case 3:
          _referralCodeError =
              _validateReferralCode(_referralCodeController.text);
          break;
      }
    });
  }

  bool _isCurrentStepValid() {
    switch (_currentStep) {
      case 0:
        return _firstNameError == null &&
            _lastNameError == null &&
            _emailError == null &&
            _phoneError == null &&
            _firstNameController.text.trim().isNotEmpty &&
            _lastNameController.text.trim().isNotEmpty &&
            _emailController.text.trim().isNotEmpty &&
            _phoneController.text.trim().isNotEmpty;
      case 1:
        return _capturedImage != null;
      case 2:
        return _selectedPlan.isNotEmpty;
      case 3:
        return _acceptedTerms && (_referralCodeError == null);
      default:
        return false;
    }
  }

  void _nextStep() {
    _validateCurrentStep();

    if (_isCurrentStepValid()) {
      if (_currentStep < 3) {
        setState(() {
          _currentStep++;
        });
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _submitRegistration();
      }
    } else {
      _showValidationErrors();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showValidationErrors() {
    String errorMessage = '';

    switch (_currentStep) {
      case 0:
        if (_firstNameController.text.trim().isEmpty) {
          errorMessage = 'Veuillez remplir tous les champs obligatoires';
        } else if (_firstNameError != null ||
            _lastNameError != null ||
            _emailError != null ||
            _phoneError != null) {
          errorMessage = 'Veuillez corriger les erreurs dans le formulaire';
        }
        break;
      case 1:
        errorMessage = 'Veuillez ajouter une photo de profil';
        break;
      case 2:
        errorMessage = 'Veuillez sélectionner une formule d\'abonnement';
        break;
      case 3:
        if (!_acceptedTerms) {
          errorMessage = 'Vous devez accepter les conditions générales';
        } else if (_referralCodeError != null) {
          errorMessage = 'Code de parrainage invalide';
        }
        break;
    }

    if (errorMessage.isNotEmpty) {
      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        textColor: Colors.white,
      );
    }
  }

  Future<void> _submitRegistration() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock registration data
      final registrationData = {
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'profileImage': _capturedImage?.path,
        'subscriptionPlan': _selectedPlan,
        'referralCode': _referralCodeController.text.trim().isNotEmpty
            ? _referralCodeController.text.trim().toUpperCase()
            : null,
        'termsAccepted': _acceptedTerms,
        'registrationDate': DateTime.now().toIso8601String(),
      };

      debugPrint('Registration data: \$registrationData');

      // Show success message
      Fluttertoast.showToast(
        msg:
            'Inscription réussie ! Redirection vers la vérification d\'identité...',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.getSuccessColor(true),
        textColor: Colors.white,
      );

      // Navigate to identity verification
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        Navigator.pushReplacementNamed(
            context, '/identity-verification-screen');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Erreur lors de l\'inscription. Veuillez réessayer.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        textColor: Colors.white,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: List.generate(4, (index) {
          final isActive = index <= _currentStep;
          final isCompleted = index < _currentStep;

          return Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.w),
              child: Column(
                children: [
                  Container(
                    height: 1.h,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(1.h),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isCompleted)
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 4.w,
                        )
                      else
                        Container(
                          width: 4.w,
                          height: 4.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isActive
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.3),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: isActive
                                    ? Colors.white
                                    : AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                                fontSize: 8.sp,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return PersonalInfoSection(
          firstNameController: _firstNameController,
          lastNameController: _lastNameController,
          emailController: _emailController,
          phoneController: _phoneController,
          firstNameError: _firstNameError,
          lastNameError: _lastNameError,
          emailError: _emailError,
          phoneError: _phoneError,
          onFirstNameChanged: (value) {
            setState(() {
              _firstNameError = _validateName(value, 'Le prénom');
            });
          },
          onLastNameChanged: (value) {
            setState(() {
              _lastNameError = _validateName(value, 'Le nom');
            });
          },
          onEmailChanged: (value) {
            setState(() {
              _emailError = _validateEmail(value);
            });
          },
          onPhoneChanged: (value) {
            setState(() {
              _phoneError = _validatePhone(value);
            });
          },
        );
      case 1:
        return ProfilePhotoSection(
          capturedImage: _capturedImage,
          onImageCaptured: (image) {
            setState(() {
              _capturedImage = image;
            });
          },
        );
      case 2:
        return SubscriptionPlansSection(
          selectedPlan: _selectedPlan,
          onPlanSelected: (plan) {
            setState(() {
              _selectedPlan = plan;
            });
          },
        );
      case 3:
        return TermsAndReferralSection(
          acceptedTerms: _acceptedTerms,
          onTermsChanged: (value) {
            setState(() {
              _acceptedTerms = value ?? false;
            });
          },
          referralCodeController: _referralCodeController,
          referralCodeError: _referralCodeError,
          onReferralCodeChanged: (value) {
            setState(() {
              _referralCodeError = _validateReferralCode(value);
            });
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Inscription'),
        leading: _currentStep > 0
            ? IconButton(
                onPressed: _previousStep,
                icon: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 6.w,
                ),
              )
            : IconButton(
                onPressed: () => Navigator.pop(context),
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 6.w,
                ),
              ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: Center(
              child: Text(
                '${_currentStep + 1}/4',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressIndicator(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.all(4.w),
                    child: _buildStepContent(),
                  ),
                  SingleChildScrollView(
                    padding: EdgeInsets.all(4.w),
                    child: _buildStepContent(),
                  ),
                  SingleChildScrollView(
                    padding: EdgeInsets.all(4.w),
                    child: _buildStepContent(),
                  ),
                  SingleChildScrollView(
                    padding: EdgeInsets.all(4.w),
                    child: _buildStepContent(),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow,
                    blurRadius: 2.w,
                    offset: Offset(0, -1.w),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        child: Text('Précédent'),
                      ),
                    ),
                  if (_currentStep > 0) SizedBox(width: 4.w),
                  Expanded(
                    flex: _currentStep > 0 ? 1 : 1,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _nextStep,
                      child: _isLoading
                          ? SizedBox(
                              height: 5.w,
                              width: 5.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 0.5.w,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(_currentStep == 3
                              ? 'Créer mon compte'
                              : 'Continuer'),
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
