import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class VideoRecordingWidget extends StatefulWidget {
  final Function(String?) onVideoRecorded;

  const VideoRecordingWidget({
    Key? key,
    required this.onVideoRecorded,
  }) : super(key: key);

  @override
  State<VideoRecordingWidget> createState() => _VideoRecordingWidgetState();
}

class _VideoRecordingWidgetState extends State<VideoRecordingWidget>
    with TickerProviderStateMixin {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isRecording = false;
  int _recordingDuration = 0;
  String? _recordedVideoPath;
  String? _errorMessage;

  late AnimationController _timerAnimationController;
  late AnimationController _pulseAnimationController;

  final int _maxRecordingDuration = 30; // 30 seconds

  @override
  void initState() {
    super.initState();
    _timerAnimationController = AnimationController(
      duration: Duration(seconds: _maxRecordingDuration),
      vsync: this,
    );
    _pulseAnimationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _initializeCamera();
  }

  @override
  void dispose() {
    _timerAnimationController.dispose();
    _pulseAnimationController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<bool> _requestPermissions() async {
    if (kIsWeb) return true;

    final cameraStatus = await Permission.camera.request();
    final microphoneStatus = await Permission.microphone.request();

    return cameraStatus.isGranted && microphoneStatus.isGranted;
  }

  Future<void> _initializeCamera() async {
    try {
      final hasPermissions = await _requestPermissions();
      if (!hasPermissions) {
        setState(() {
          _errorMessage = 'Permissions caméra et microphone requises';
        });
        return;
      }

      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() {
          _errorMessage = 'Aucune caméra disponible';
        });
        return;
      }

      final frontCamera = _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
        enableAudio: true,
      );

      await _cameraController!.initialize();

      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur d\'initialisation de la caméra';
      });
    }
  }

  Future<void> _startRecording() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      await _cameraController!.startVideoRecording();

      setState(() {
        _isRecording = true;
        _recordingDuration = 0;
      });

      _timerAnimationController.forward();
      _pulseAnimationController.repeat();

      // Start timer
      _startTimer();
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors du démarrage de l\'enregistrement';
      });
    }
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 1));
      if (!_isRecording) return false;

      setState(() {
        _recordingDuration++;
      });

      if (_recordingDuration >= _maxRecordingDuration) {
        _stopRecording();
        return false;
      }

      return true;
    });
  }

  Future<void> _stopRecording() async {
    if (_cameraController == null || !_isRecording) return;

    try {
      final videoFile = await _cameraController!.stopVideoRecording();

      setState(() {
        _isRecording = false;
        _recordedVideoPath = videoFile.path;
      });

      _timerAnimationController.stop();
      _pulseAnimationController.stop();

      widget.onVideoRecorded(videoFile.path);
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors de l\'arrêt de l\'enregistrement';
        _isRecording = false;
      });

      _timerAnimationController.stop();
      _pulseAnimationController.stop();
    }
  }

  void _retakeVideo() {
    setState(() {
      _recordedVideoPath = null;
      _recordingDuration = 0;
    });
    _timerAnimationController.reset();
    widget.onVideoRecorded(null);
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Widget _buildCameraPreview() {
    if (_errorMessage != null) {
      return Container(
        height: 45.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.error,
            width: 1,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'error_outline',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 48,
              ),
              SizedBox(height: 2.h),
              Text(
                _errorMessage!,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.h),
              ElevatedButton(
                onPressed: _initializeCamera,
                child: Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isCameraInitialized || _cameraController == null) {
      return Container(
        height: 45.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppTheme.lightTheme.primaryColor,
              ),
              SizedBox(height: 2.h),
              Text(
                'Initialisation de la caméra...',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 45.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned.fill(
            child: CameraPreview(_cameraController!),
          ),
          // Recording indicator
          if (_isRecording)
            Positioned(
              top: 2.h,
              left: 4.w,
              child: AnimatedBuilder(
                animation: _pulseAnimationController,
                builder: (context, child) {
                  return Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(
                        alpha: 0.8 + 0.2 * _pulseAnimationController.value,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'REC ${_formatDuration(_recordingDuration)}',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          // Timer progress
          if (_isRecording)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _timerAnimationController,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: _timerAnimationController.value,
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    minHeight: 4,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVideoPreview() {
    return Container(
      height: 45.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.getSuccessColor(true),
          width: 2,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'video_library',
              color: AppTheme.getSuccessColor(true),
              size: 64,
            ),
            SizedBox(height: 2.h),
            Text(
              'Vidéo enregistrée',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.getSuccessColor(true),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Durée: ${_formatDuration(_recordingDuration)}',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'videocam',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Enregistrement vidéo',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'Enregistrez une vidéo de 30 secondes maximum pour confirmer votre acceptation des règles.',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),
          _recordedVideoPath == null
              ? _buildCameraPreview()
              : _buildVideoPreview(),
          SizedBox(height: 3.h),
          if (_recordedVideoPath == null) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isCameraInitialized && !_isRecording
                    ? _startRecording
                    : _isRecording
                        ? _stopRecording
                        : null,
                icon: CustomIconWidget(
                  iconName: _isRecording ? 'stop' : 'play_arrow',
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(_isRecording ? 'Arrêter' : 'Commencer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isRecording
                      ? Colors.red
                      : AppTheme.lightTheme.primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
              ),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _retakeVideo,
                    icon: CustomIconWidget(
                      iconName: 'refresh',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 20,
                    ),
                    label: Text('Reprendre'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: CustomIconWidget(
                      iconName: 'check',
                      color: Colors.white,
                      size: 20,
                    ),
                    label: Text('Valider'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (_isRecording) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: Colors.red,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Enregistrement en cours... Parlez clairement pour confirmer votre acceptation des règles.',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}