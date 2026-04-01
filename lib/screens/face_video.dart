import 'dart:async';
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:faceapp/config/api_config.dart';

class FaceCaptureScreen extends StatefulWidget {
  const FaceCaptureScreen({super.key});

  @override
  State<FaceCaptureScreen> createState() => _FaceCaptureScreenState();
}

class _FaceCaptureScreenState extends State<FaceCaptureScreen>
    with SingleTickerProviderStateMixin {
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;

  late final AnimationController _scanController;

  bool _isCameraReady = false;
  bool _isCapturing = false;
  bool _isCompleted = false;
  bool _showSuccessState = false;

  String? _successMessage;
  String? _statusMessage;
  Color _statusColor = const Color(0xFF14B8FF);

  double _autoProgress = 0.0;
  Timer? _autoTimer;

  final List<_CaptureStep> _steps = const [
    _CaptureStep(
      keyName: 'front',
      title: 'Look straight ahead',
      subtitle: 'Keep your face centered inside the frame',
    ),
    _CaptureStep(
      keyName: 'right',
      title: 'Turn your face right',
      subtitle: 'Rotate slightly to the right',
    ),
    _CaptureStep(
      keyName: 'left',
      title: 'Turn your face left',
      subtitle: 'Rotate slightly to the left',
    ),
    _CaptureStep(
      keyName: 'up',
      title: 'Look up',
      subtitle: 'Lift your head slightly upward',
    ),
    _CaptureStep(
      keyName: 'down',
      title: 'Look down',
      subtitle: 'Lower your head slightly downward',
    ),
  ];

  int _currentStep = 0;
  final Map<String, XFile> _capturedImages = {};

  double get _progress => _capturedImages.length / _steps.length;
  _CaptureStep get _activeStep => _steps[_currentStep];

  @override
  void initState() {
    super.initState();

    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _setupCamera();
  }

  Future<void> _setupCamera() async {
    try {
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        throw Exception('No cameras found on device');
      }

      CameraDescription? frontCamera;
      for (final camera in cameras) {
        if (camera.lensDirection == CameraLensDirection.front) {
          frontCamera = camera;
          break;
        }
      }

      final selectedCamera = frontCamera ?? cameras.first;

      final controller = CameraController(
        selectedCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      _cameraController = controller;
      _initializeControllerFuture = controller.initialize();

      await _initializeControllerFuture;

      if (!mounted) return;

      await controller.setFlashMode(FlashMode.off);

      setState(() {
        _isCameraReady = true;
        _statusMessage = 'Align your face for ${_activeStep.title.toLowerCase()}';
        _statusColor = const Color(0xFF14B8FF);
      });

      _startAutoProgress();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to initialize camera: $e'),
        ),
      );
    }
  }

  void _startAutoProgress() {
    _autoTimer?.cancel();

    if (!_isCameraReady || _isCapturing || _isCompleted || _showSuccessState) {
      return;
    }

    setState(() {
      _autoProgress = 0.0;
      _statusMessage ??= 'Align your face for ${_activeStep.title.toLowerCase()}';
      _statusColor = const Color(0xFF14B8FF);
    });

    _autoTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted ||
          !_isCameraReady ||
          _isCapturing ||
          _isCompleted ||
          _showSuccessState) {
        timer.cancel();
        return;
      }

      setState(() {
        _autoProgress += 0.05;

        if (_autoProgress >= 1.0) {
          _autoProgress = 1.0;
          timer.cancel();
          _captureCurrentStep();
        }
      });
    });
  }

  Future<Map<String, dynamic>?> _validateFace(XFile file, String step) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/ai/check-face-pose');

      final request = http.MultipartRequest('POST', uri)
        ..fields['step'] = step
        ..files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();
      final body = await response.stream.bytesToString();

      if (body.isEmpty) return null;

      return jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  String _buildFailureMessage(Map<String, dynamic>? data) {
    if (data == null) {
      return 'Could not verify face. Please try again.';
    }

    final faceDetected = data['face_detected'] == true;
    final insideFrame = data['inside_frame'] == true;
    final poseOk = data['pose_ok'] == true;
    final apiMessage = (data['message'] ?? '').toString().trim();

    if (!faceDetected) {
      return 'No face detected. Please place your face inside the frame.';
    }

    if (!insideFrame) {
      return 'Move your face inside the frame.';
    }

    if (!poseOk) {
      if (apiMessage.isNotEmpty) {
        return apiMessage;
      }
      return 'Wrong face position for ${_activeStep.keyName}. Please try again.';
    }

    return apiMessage.isNotEmpty ? apiMessage : 'Face validation failed.';
  }

  Future<void> _captureCurrentStep() async {
    final controller = _cameraController;

    if (controller == null ||
        !controller.value.isInitialized ||
        _isCapturing ||
        _isCompleted) {
      return;
    }

    _autoTimer?.cancel();

    try {
      setState(() {
        _isCapturing = true;
        _statusMessage = 'Checking ${_activeStep.keyName} pose...';
        _statusColor = const Color(0xFFF59E0B);
      });

      await _initializeControllerFuture;

      if (!mounted || _cameraController == null) return;

      final file = await controller.takePicture();

      if (!mounted || _cameraController == null) return;

      final validation = await _validateFace(file, _activeStep.keyName);
      final isValid = validation != null &&
          validation['face_detected'] == true &&
          validation['inside_frame'] == true &&
          validation['pose_ok'] == true;

      if (!isValid) {
        final failureMessage = _buildFailureMessage(validation);

        if (!mounted) return;

        setState(() {
          _statusMessage = failureMessage;
          _statusColor = const Color(0xFFEF4444);
          _autoProgress = 0.0;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failureMessage),
            backgroundColor: Colors.red,
          ),
        );

        return;
      }

      _capturedImages[_activeStep.keyName] = file;

      if (_currentStep < _steps.length - 1) {
        setState(() {
          _currentStep++;
          _autoProgress = 0.0;
          _statusMessage =
              '${_activeStep.keyName.toUpperCase()} captured. Move to next step.';
          _statusColor = const Color(0xFF22C55E);
        });

        await Future.delayed(const Duration(milliseconds: 700));

        if (!mounted) return;

        setState(() {
          _statusMessage =
              'Align your face for ${_activeStep.title.toLowerCase()}';
          _statusColor = const Color(0xFF14B8FF);
        });

        _startAutoProgress();
      } else {
        setState(() {
          _isCompleted = true;
          _showSuccessState = true;
          _successMessage = 'Face scan completed successfully';
          _statusMessage = 'All face angles captured successfully';
          _statusColor = const Color(0xFF22C55E);
          _autoProgress = 1.0;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _statusMessage = 'Capture failed. Please try again.';
        _statusColor = const Color(0xFFEF4444);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Capture failed: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });

        if (!_isCompleted && !_showSuccessState) {
          _startAutoProgress();
        }
      }
    }
  }

  void _goToPreviousStep() {
    if (_currentStep == 0 || _isCapturing || _showSuccessState) return;

    _autoTimer?.cancel();

    final currentStep = _steps[_currentStep];
    _capturedImages.remove(currentStep.keyName);

    setState(() {
      _currentStep--;
      _isCompleted = false;
      _showSuccessState = false;
      _successMessage = null;
      _statusMessage = 'Returned to previous step';
      _statusColor = const Color(0xFF14B8FF);
      _autoProgress = 0.0;
    });

    _startAutoProgress();
  }

  void _restartFlow() {
    if (_isCapturing) return;

    _autoTimer?.cancel();

    setState(() {
      _currentStep = 0;
      _isCompleted = false;
      _showSuccessState = false;
      _successMessage = null;
      _statusMessage = 'Scan restarted';
      _statusColor = const Color(0xFF14B8FF);
      _capturedImages.clear();
      _autoProgress = 0.0;
    });

    if (_isCameraReady) {
      _startAutoProgress();
    }
  }

  void _finishAndReturn() {
    Navigator.of(context).pop({
      'success': true,
      'message': _successMessage ?? 'Face scan completed successfully',
      'images': _capturedImages,
    });
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _scanController.dispose();

    final controller = _cameraController;
    _cameraController = null;
    _isCameraReady = false;

    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percent = (_progress * 100).round();

    return Scaffold(
      backgroundColor: const Color(0xFF020817),
      body: SafeArea(
        child: Stack(
          children: [
            const _BackgroundGrid(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Column(
                children: [
                  _buildTopBar(),
                  const SizedBox(height: 18),
                  Expanded(
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 0.62,
                        child: _buildCameraScannerCard(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  _buildBottomPanel(percent),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        _circleButton(
          icon: Icons.close,
          onTap: () => Navigator.of(context).pop(),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.10),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withOpacity(0.06),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _showSuccessState
                      ? const Color(0xFF22C55E)
                      : _isCapturing
                          ? const Color(0xFFFFB703)
                          : const Color(0xFFFF4D4D),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _showSuccessState
                    ? 'Completed'
                    : _isCapturing
                        ? 'Capturing'
                        : 'Scanning',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        _circleButton(
          icon: Icons.refresh,
          onTap: _restartFlow,
        ),
      ],
    );
  }

  Widget _buildCameraScannerCard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        final ovalWidth = width * 0.54;
        final ovalHeight = height * 0.40;

        return ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF081427),
                      Color(0xFF030B18),
                      Color(0xFF000000),
                    ],
                  ),
                ),
              ),
              if (_isCameraReady && _cameraController != null)
                FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _cameraController!.value.previewSize!.height,
                    height: _cameraController!.value.previewSize!.width,
                    child: CameraPreview(_cameraController!),
                  ),
                )
              else
                Container(
                  color: Colors.black,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(
                    color: Color(0xFF17D6FF),
                  ),
                ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF020817).withOpacity(0.26),
                      const Color(0xFF020817).withOpacity(0.06),
                      const Color(0xFF000000).withOpacity(0.50),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: CustomPaint(
                  painter: _CornerPainter(
                    color: _showSuccessState
                        ? const Color(0xFF22C55E)
                        : const Color(0xFF19D3FF),
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  width: width * 0.72,
                  height: height * 0.56,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: ovalWidth,
                        height: ovalHeight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(ovalWidth / 2.2),
                          boxShadow: [
                            BoxShadow(
                              color: (_showSuccessState
                                      ? const Color(0xFF22C55E)
                                      : const Color(0xFF18D2FF))
                                  .withOpacity(0.08),
                              blurRadius: 30,
                              spreadRadius: 8,
                            ),
                          ],
                        ),
                      ),
                      CustomPaint(
                        size: Size(ovalWidth, ovalHeight),
                        painter: _DottedOvalPainter(
                          color: _showSuccessState
                              ? const Color(0xFF22C55E)
                              : const Color(0xFF19D3FF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!_showSuccessState)
                AnimatedBuilder(
                  animation: _scanController,
                  builder: (context, child) {
                    final scanTop = (height * 0.25) +
                        ((height * 0.34) * _scanController.value);

                    return Positioned(
                      top: scanTop,
                      left: width * 0.10,
                      right: width * 0.10,
                      child: Column(
                        children: [
                          Container(
                            height: 3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: const LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Color(0xFF1CD9FF),
                                  Colors.transparent,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFF1CD9FF).withOpacity(0.65),
                                  blurRadius: 18,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 18,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  const Color(0xFF1CD9FF).withOpacity(0.20),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              Positioned(
                left: 24,
                right: 24,
                bottom: 32,
                child: Column(
                  children: [
                    if (_showSuccessState) ...[
                      const Icon(
                        Icons.verified_rounded,
                        color: Color(0xFF22C55E),
                        size: 42,
                      ),
                      const SizedBox(height: 10),
                    ],
                    Text(
                      _showSuccessState ? 'Scan Completed' : _activeStep.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _showSuccessState
                            ? const Color(0xFF22C55E)
                            : Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _showSuccessState
                          ? (_successMessage ??
                              'Face scan completed successfully')
                          : _activeStep.subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _showSuccessState
                            ? const Color(0xFFBBF7D0)
                            : Colors.white.withOpacity(0.75),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomPanel(int percent) {
    return Column(
      children: [
        Text(
          _showSuccessState
              ? 'All steps completed'
              : 'Step ${_currentStep + 1} of ${_steps.length}',
          style: TextStyle(
            color: _showSuccessState
                ? const Color(0xFF86EFAC)
                : Colors.white.withOpacity(0.72),
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: _showSuccessState ? 1.0 : _progress,
            minHeight: 8,
            backgroundColor: Colors.white.withOpacity(0.09),
            valueColor: AlwaysStoppedAnimation(
              _showSuccessState
                  ? const Color(0xFF22C55E)
                  : const Color(0xFF14B8FF),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          _showSuccessState ? '100%' : '$percent%',
          style: TextStyle(
            color: _showSuccessState
                ? const Color(0xFF22C55E)
                : const Color(0xFF14B8FF),
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _showSuccessState
              ? 'You can continue and complete the student information'
              : _isCapturing
                  ? 'Capturing image...'
                  : 'Hold still while we capture automatically',
          style: TextStyle(
            color: _showSuccessState
                ? const Color(0xFFBBF7D0)
                : Colors.white.withOpacity(0.55),
            fontSize: 13,
          ),
        ),
        if (_statusMessage != null) ...[
          const SizedBox(height: 10),
          Text(
            _statusMessage!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _statusColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _showSuccessState
                  ? ElevatedButton(
                      onPressed: _finishAndReturn,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(54),
                        backgroundColor: const Color(0xFF22C55E),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  : OutlinedButton(
                      onPressed: (_currentStep > 0 && !_isCapturing)
                          ? _goToPreviousStep
                          : null,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(54),
                        side: BorderSide(
                          color: Colors.white.withOpacity(0.20),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        'Back',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ),
          ],
        ),
        const SizedBox(height: 18),
      ],
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.10),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.06),
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}

class _CaptureStep {
  final String keyName;
  final String title;
  final String subtitle;

  const _CaptureStep({
    required this.keyName,
    required this.title,
    required this.subtitle,
  });
}

class _BackgroundGrid extends StatelessWidget {
  const _BackgroundGrid();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GridPainter(),
      child: Container(),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF102038),
          Color(0xFF020817),
          Color(0xFF000000),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Offset.zero & size);

    canvas.drawRect(Offset.zero & size, backgroundPaint);

    final linePaint = Paint()
      ..color = const Color(0xFF1A3352).withOpacity(0.18)
      ..strokeWidth = 1;

    const gap = 32.0;

    for (double x = 0; x < size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }

    for (double y = 0; y < size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CornerPainter extends CustomPainter {
  final Color color;

  _CornerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final glowPaint = Paint()
      ..color = color.withOpacity(0.20)
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const cornerLength = 58.0;
    const margin = 26.0;
    const radius = 18.0;

    final path = Path();

    path.moveTo(margin + radius, margin);
    path.lineTo(margin + cornerLength, margin);
    path.moveTo(margin, margin + radius);
    path.lineTo(margin, margin + cornerLength);

    path.moveTo(size.width - margin - radius, margin);
    path.lineTo(size.width - margin - cornerLength, margin);
    path.moveTo(size.width - margin, margin + radius);
    path.lineTo(size.width - margin, margin + cornerLength);

    path.moveTo(margin, size.height - margin - radius);
    path.lineTo(margin, size.height - margin - cornerLength);
    path.moveTo(margin + radius, size.height - margin);
    path.lineTo(margin + cornerLength, size.height - margin);

    path.moveTo(size.width - margin - radius, size.height - margin);
    path.lineTo(size.width - margin - cornerLength, size.height - margin);
    path.moveTo(size.width - margin, size.height - margin - radius);
    path.lineTo(size.width - margin, size.height - margin - cornerLength);

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DottedOvalPainter extends CustomPainter {
  final Color color;

  _DottedOvalPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width,
      height: size.height,
    );

    final dashedPaint = Paint()
      ..color = color.withOpacity(0.45)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final glowPaint = Paint()
      ..color = color.withOpacity(0.10)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawOval(rect, glowPaint);

    const dashWidth = 6.0;
    const dashSpace = 5.0;

    final path = Path()..addOval(rect);

    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final nextDistance = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, nextDistance),
          dashedPaint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}