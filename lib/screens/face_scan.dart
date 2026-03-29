import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:faceapp/screens/Verification_success.dart';
// ══════════════════════════════════════════════════════════════════════
// FACE SCAN SCREEN
// ══════════════════════════════════════════════════════════════════════
class FaceScanScreen extends StatefulWidget {
  const FaceScanScreen({super.key});

  @override
  State<FaceScanScreen> createState() => _FaceScanScreenState();
}

class _FaceScanScreenState extends State<FaceScanScreen>
    with TickerProviderStateMixin {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraReady = false;
  String _scanStatus = "Position your face in the frame";

  // ── Animations ──────────────────────────────────────────────────────
  late AnimationController _pulseController;
  late AnimationController _scanLineController;
  late AnimationController _cornerController;

  late Animation<double> _pulseAnim;
  late Animation<double> _scanLineAnim;
  late Animation<double> _cornerAnim;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _initCamera();
  }

  void _initAnimations() {
    // Pulse glow
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Scan line sweep
    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
    _scanLineAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanLineController, curve: Curves.easeInOut),
    );

    // Corner brackets fade-in
    _cornerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _cornerAnim = CurvedAnimation(
      parent: _cornerController,
      curve: Curves.easeOut,
    );
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();

      // تفضيل الكاميرا الأمامية
      final frontCamera = _cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() => _isCameraReady = true);
      }
    } catch (e) {
      debugPrint('Camera error: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _pulseController.dispose();
    _scanLineController.dispose();
    _cornerController.dispose();
    super.dispose();
  }

  // ── Capture ──────────────────────────────────────────────────────────
  Future<void> _captureAndScan() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    setState(() => _scanStatus = "Scanning...");

    try {
      final XFile image = await _cameraController!.takePicture();

      // ✏️ هنا ترسل الصورة للباك اند
      // await ApiService.verifyFace(image.path);

      if (mounted) {
  setState(() => _scanStatus = "✓ Scan Complete");
  await Future.delayed(const Duration(seconds: 1));

  // ✏️ هون ترسل الصورة للباك اند وتاخذ الـ response
  // final response = await ApiService.verifyFace(image.path);
  // final student = VerifiedStudent.fromJson(response);

  Navigator.pushReplacement(        // ← بدل pop
    context,
    MaterialPageRoute(
      builder: (_) => VerificationSuccessScreen(
        // student: student,        // ← مررها لما تربط الباك اند
      ),
    ),
  );
}
    } catch (e) {
      setState(() => _scanStatus = "Scan failed. Try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.of(context).size;
    final double w = screen.width;
    final double h = screen.height;

    // حجم الـ oval frame
    final double frameW = w * 0.68;
    final double frameH = h * 0.42;

    return Scaffold(
      backgroundColor: const Color(0xFF050D1A),
      body: Stack(
        children: [
          // ── Camera feed ──────────────────────────────────────────
          if (_isCameraReady && _cameraController != null)
            Positioned.fill(
              child: CameraPreview(_cameraController!),
            )
          else
            Positioned.fill(
              child: Container(color: const Color(0xFF050D1A)),
            ),

          // ── Dark overlay with oval hole ──────────────────────────
          Positioned.fill(
            child: _OvalCutoutOverlay(
              frameW: frameW,
              frameH: frameH,
            ),
          ),

          // ── Scan line inside oval ─────────────────────────────────
          Center(
            child: SizedBox(
              width:  frameW,
              height: frameH,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(frameW / 2),
                child: AnimatedBuilder(
                  animation: _scanLineAnim,
                  builder: (_, __) {
                    return Stack(
                      children: [
                        Positioned(
                          top:  frameH * _scanLineAnim.value - 1,
                          left: 0,
                          right: 0,
                          child: AnimatedBuilder(
                            animation: _pulseAnim,
                            builder: (_, __) => Opacity(
                              opacity: _pulseAnim.value,
                              child: Container(
                                height: 2,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Color(0xFF00D4FF),
                                      Color(0xFF00FFEA),
                                      Color(0xFF00D4FF),
                                      Colors.transparent,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:Color(0x9900D4FF),
                                      blurRadius:  12,
                                      spreadRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),

          // ── Corner brackets ──────────────────────────────────────
          Center(
            child: FadeTransition(
              opacity: _cornerAnim,
              child: SizedBox(
                width:  frameW + 24,
                height: frameH + 24,
                child: CustomPaint(
                  painter: _CornerBracketsPainter(
                    color: const Color(0xFF00D4FF),
                    glowColor: const Color(0x6600D4FF),
                  ),
                ),
              ),
            ),
          ),

          // ── Oval border glow ─────────────────────────────────────
          Center(
            child: AnimatedBuilder(
              animation: _pulseAnim,
              builder: (_, __) => Container(
                width:  frameW,
                height: frameH,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(frameW / 2),
                  border: Border.all(
                    color: Color.fromRGBO(
                        0, 212, 255, _pulseAnim.value * 0.6),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:       Color.fromRGBO(0, 212, 255, _pulseAnim.value * 0.25),
                      blurRadius:  20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Top bar ──────────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: w * 0.05, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color:        const Color.fromARGB(255, 58, 111, 233).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border:       Border.all(
                              color: Colors.white.withOpacity(0.15)),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.white, size: 18),
                      ),
                    ),
                    const SizedBox(width:18),
                    const Text(
                      "Face Scan",
                      style: TextStyle(
                        color:      Colors.white,
                        fontSize:   20,
                        fontWeight: FontWeight.bold,
                        letterSpacing:.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Status text ──────────────────────────────────────────
          Positioned(
            bottom: h * 0.22,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _pulseAnim,
              builder: (_, __) => Opacity(
                opacity: 0.7 + _pulseAnim.value * 0.3,
                child: Text(
                  _scanStatus,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color:       Color(0xFF00D4FF),
                    fontSize:    15,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ),

          // ── Dots indicator ───────────────────────────────────────
          Positioned(
            bottom: h * 0.175,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) => AnimatedBuilder(
                animation: _scanLineController,
                builder: (_, __) {
                  final active =
                      (_scanLineController.value * 3).floor() % 3 == i;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width:  active ? 18 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: active
                          ? const Color(0xFF00D4FF)
                          : Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                },
              )),
            ),
          ),

          // ── Capture button ───────────────────────────────────────
          Positioned(
            bottom: h * 0.055,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _captureAndScan,
                child: AnimatedBuilder(
                  animation: _pulseAnim,
                  builder: (_, __) => Container(
                    width:  80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00D4FF), Color(0xFF0080FF)],
                        begin: Alignment.topLeft,
                        end:   Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(
                              0, 212, 255, _pulseAnim.value * 0.55),
                          blurRadius:  23,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.camera_alt_rounded,
                        color: Colors.white, size: 34),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// OVAL CUTOUT OVERLAY
// ══════════════════════════════════════════════════════════════════════
class _OvalCutoutOverlay extends StatelessWidget {
  final double frameW;
  final double frameH;

  const _OvalCutoutOverlay({required this.frameW, required this.frameH});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _OvalCutoutPainter(frameW: frameW, frameH: frameH),
    );
  }
}

class _OvalCutoutPainter extends CustomPainter {
  final double frameW;
  final double frameH;

  _OvalCutoutPainter({required this.frameW, required this.frameH});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final outerPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final ovalPath = Path()
      ..addOval(Rect.fromCenter(
          center: center, width: frameW, height: frameH));

    final cutout = Path.combine(
        PathOperation.difference, outerPath, ovalPath);

    canvas.drawPath(
      cutout,
      Paint()..color = const Color.fromARGB(204, 12, 29, 58),
    );
  }

  @override
  bool shouldRepaint(_OvalCutoutPainter old) =>
      old.frameW != frameW || old.frameH != frameH;
}

// ══════════════════════════════════════════════════════════════════════
// CORNER BRACKETS PAINTER
// ══════════════════════════════════════════════════════════════════════
class _CornerBracketsPainter extends CustomPainter {
  final Color color;
  final Color glowColor;

  _CornerBracketsPainter({required this.color, required this.glowColor});

  @override
  void paint(Canvas canvas, Size size) {
    final double len = 28.0;
    final double r   = 10.0;
    final double sw  = 3.0;

    final paint = Paint()
      ..color       = color
      ..strokeWidth = sw
      ..style       = PaintingStyle.stroke
      ..strokeCap   = StrokeCap.round;

    final glow = Paint()
      ..color       = glowColor
      ..strokeWidth = sw + 6
      ..style       = PaintingStyle.stroke
      ..strokeCap   = StrokeCap.round
      ..maskFilter  = const MaskFilter.blur(BlurStyle.normal, 8);

    final corners = [
      // top-left
      _CornerData(Offset(0, 0),                 1,  1),
      // top-right
      _CornerData(Offset(size.width, 0),        -1,  1),
      // bottom-left
      _CornerData(Offset(0, size.height),        1, -1),
      // bottom-right
      _CornerData(Offset(size.width, size.height), -1, -1),
    ];

    for (final c in corners) {
      final path = Path();
      path.moveTo(c.origin.dx + c.sx * len, c.origin.dy);
      path.lineTo(c.origin.dx + c.sx * r,   c.origin.dy);
      path.quadraticBezierTo(
        c.origin.dx, c.origin.dy,
        c.origin.dx, c.origin.dy + c.sy * r,
      );
      path.lineTo(c.origin.dx, c.origin.dy + c.sy * len);

      canvas.drawPath(path, glow);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _CornerData {
  final Offset origin;
  final double sx; // sign x
  final double sy; // sign y
  _CornerData(this.origin, this.sx, this.sy);
}


// ══════════════════════════════════════════════════════════════════════
// SELFIE TIPS  —  زر Start Face Scan يفتح FaceScanScreen
// ══════════════════════════════════════════════════════════════════════
