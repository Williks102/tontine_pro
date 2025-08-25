import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/document_capture_widget.dart';
import './widgets/legal_message_widget.dart';
import './widgets/photo_verification_widget.dart';
import './widgets/upload_progress_widget.dart';
import './widgets/verification_progress_widget.dart';
import './widgets/video_recording_widget.dart';

class IdentityVerificationScreen extends StatefulWidget {
  const IdentityVerificationScreen({Key? key}) : super(key: key);

  @override
  State<IdentityVerificationScreen> createState() =>
      _IdentityVerificationScreenState();
}

class _IdentityVerificationScreenState
    extends State<IdentityVerificationScreen> {
  int _currentStep = 0;
  final int _totalSteps = 5;

  // Step completion states
  XFile? _capturedDocument;
  bool _photoVerificationComplete = false;
  String? _recordedVideo;
  bool _legalAcknowledged = false;

  // Upload states
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  bool _uploadComplete = false;
  bool _uploadError = false;
  String? _uploadErrorMessage;

  final List<String> _stepTitles = [
    'Capture du document d\'identité',
    'Vérification photo',
    'Enregistrement vidéo',
    'Acceptation légale',
    'Finalisation',
  ];

  // Mock user data
  final Map<String, dynamic> _mockUserData = {
    "registrationPhoto":
        "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "firstName": "Aminata",
    "lastName": "Diallo",
    "email": "aminata.diallo@email.com",
  };

  @override
  void initState() {
    super.initState();
  }

  void _onDocumentCaptured(XFile? document) {
    setState(() {
      _capturedDocument = document;
    });
    if (document != null) {
      _nextStep();
    }
  }

  void _onPhotoVerificationComplete(bool isComplete) {
    setState(() {
      _photoVerificationComplete = isComplete;
    });
    if (isComplete) {
      _nextStep();
    }
  }

  void _onVideoRecorded(String? videoPath) {
    setState(() {
      _recordedVideo = videoPath;
    });
    if (videoPath != null) {
      _nextStep();
    }
  }

  void _onLegalAcknowledgmentChanged(bool acknowledged) {
    setState(() {
      _legalAcknowledged = acknowledged;
    });
    if (acknowledged) {
      _nextStep();
    }
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });

      // Start upload process on final step
      if (_currentStep == _totalSteps - 1) {
        _startUploadProcess();
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Future<void> _startUploadProcess() async {
    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
      _uploadError = false;
      _uploadErrorMessage = null;
    });

    try {
      // Simulate upload progress
      for (int i = 0; i <= 100; i += 10) {
        await Future.delayed(Duration(milliseconds: 200));
        if (mounted) {
          setState(() {
            _uploadProgress = i / 100;
          });
        }
      }

      // Simulate processing time
      await Future.delayed(Duration(seconds: 2));

      setState(() {
        _isUploading = false;
        _uploadComplete = true;
      });

      // Show success message
      _showSuccessDialog();
    } catch (e) {
      setState(() {
        _isUploading = false;
        _uploadError = true;
        _uploadErrorMessage = 'Erreur lors du téléchargement des documents';
      });
    }
  }

  void _retryUpload() {
    _startUploadProcess();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.getSuccessColor(true),
                size: 28,
              ),
              SizedBox(width: 2.w),
              Text(
                'Vérification soumise',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Votre demande de vérification d\'identité a été soumise avec succès.',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Temps de traitement estimé:',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5),
                    Text(
                      '24 à 48 heures ouvrables',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, '/dashboard-screen');
                },
                child: Text('Continuer'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return DocumentCaptureWidget(
          onDocumentCaptured: _onDocumentCaptured,
          documentType: 'CNI/Passeport',
        );
      case 1:
        return PhotoVerificationWidget(
          registrationPhotoUrl: (_mockUserData["registrationPhoto"] as String),
          onVerificationComplete: _onPhotoVerificationComplete,
        );
      case 2:
        return VideoRecordingWidget(
          onVideoRecorded: _onVideoRecorded,
        );
      case 3:
        return LegalMessageWidget(
          onAcknowledgmentChanged: _onLegalAcknowledgmentChanged,
        );
      case 4:
        return UploadProgressWidget(
          isUploading: _isUploading,
          progress: _uploadProgress,
          isComplete: _uploadComplete,
          hasError: _uploadError,
          errorMessage: _uploadErrorMessage,
          onRetry: _retryUpload,
        );
      default:
        return Container();
    }
  }

  bool _canProceedToNextStep() {
    switch (_currentStep) {
      case 0:
        return _capturedDocument != null;
      case 1:
        return _photoVerificationComplete;
      case 2:
        return _recordedVideo != null;
      case 3:
        return _legalAcknowledged;
      case 4:
        return _uploadComplete;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Vérification d\'identité'),
        leading: _currentStep > 0 && _currentStep < _totalSteps - 1
            ? IconButton(
                onPressed: _previousStep,
                icon: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              )
            : IconButton(
                onPressed: () => Navigator.pop(context),
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              ),
        actions: [
          if (_currentStep < _totalSteps - 1)
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/dashboard-screen');
              },
              child: Text(
                'Ignorer',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: VerificationProgressWidget(
                currentStep: _currentStep,
                totalSteps: _totalSteps,
                stepTitles: _stepTitles,
              ),
            ),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  children: [
                    SizedBox(height: 2),
                    _buildCurrentStepContent(),
                    SizedBox(height: 4),
                  ],
                ),
              ),
            ),

            // Bottom navigation
            if (_currentStep < _totalSteps - 1 && !_isUploading) ...[
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    if (_currentStep > 0) ...[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _previousStep,
                          child: Text('Précédent'),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 2),
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                    ],
                    Expanded(
                      flex: _currentStep > 0 ? 1 : 2,
                      child: ElevatedButton(
                        onPressed: _canProceedToNextStep() ? _nextStep : null,
                        child: Text(_currentStep == _totalSteps - 2
                            ? 'Finaliser'
                            : 'Suivant'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 2),
                        ),
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
