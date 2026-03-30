import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:faceapp/screens/verification_success.dart';
import 'package:faceapp/screens/verification_failed.dart';
import 'package:faceapp/screens/verified_student.dart';
import 'dart:math';




class MockApiService {
  static Future<Map<String, dynamic>> verifyFace(String imagePath) async {
    await Future.delayed(const Duration(seconds: 2));

    bool isSuccess = Random().nextBool(); // نجاح أو فشل عشوائي

    if (isSuccess) {
      return {
        "success": true,
        "data": {
          "full_name": "Ahmad Ali",
          "student_id": "20231234",
          "faculty": "IT",
          "major": "Computer Science",
          "year_level": "3",
          "verification_time": "09:30 AM",
          "status": "Authorized",
          "date": "2026-03-30"
        }
      };
    } else {
      return {
        "success": false,
        "message": "Face not recognized"
      };
    }
  }
}

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
  bool _isScanning    = false;
  String _scanStatus  = "Position your face in the frame";

  late AnimationController _pulseController;
  late AnimationController _scanLineController;
  late AnimationController _cornerController;
  late Animation<double>   _pulseAnim;
  late Animation<double>   _scanLineAnim;
  late Animation<double>   _cornerAnim;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _initCamera();
  }

  void _initAnimations() {
    _pulseController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800))
      ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _scanLineController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2200))
      ..repeat(reverse: true);
    _scanLineAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _scanLineController, curve: Curves.easeInOut));

    _cornerController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..forward();
    _cornerAnim =
        CurvedAnimation(parent: _cornerController, curve: Curves.easeOut);
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      final front = _cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras.first,
      );
      _cameraController = CameraController(front, ResolutionPreset.high,
          enableAudio: false, imageFormatGroup: ImageFormatGroup.jpeg);
      await _cameraController!.initialize();
      if (mounted) setState(() => _isCameraReady = true);
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

  // ── Capture & Scan ───────────────────────────────────────────────────
  Future<void> _captureAndScan() async {
    if (_isScanning) return;
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;

    setState(() {
      _isScanning = true;
      _scanStatus = "Scanning...";
    });

    try {
      final XFile image = await _cameraController!.takePicture();

      //  Mock بدل الباك اند
      final response = await MockApiService.verifyFace(image.path);

      if (!mounted) return;

      if (response['success'] == true) {
        // ✅ نجاح
        setState(() => _scanStatus = "✓ Scan Complete");
        await Future.delayed(const Duration(milliseconds: 700));
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => VerificationSuccessScreen(
              student:VerifiedStudent.fromJson(response['data']),
            ),
          ),
        );
      } else {
        // ❌ فشل
        setState(() => _scanStatus = "✗ Verification Failed");
        await Future.delayed(const Duration(milliseconds: 700));
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => VerificationFailedScreen(
              errorMessage: response['message'],
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _scanStatus = "✗ Error. Try again.");
      await Future.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const VerificationFailedScreen(
            errorMessage: "Something went wrong. Please try again.",
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double w      = MediaQuery.of(context).size.width;
    final double h      = MediaQuery.of(context).size.height;
    final double frameW = w * 0.68;
    final double frameH = h * 0.42;

    return Scaffold(
      backgroundColor: const Color(0xFF050D1A),
      body: Stack(
        children: [

          // ── Camera / dark bg ─────────────────────────────────────
          _isCameraReady && _cameraController != null
              ? Positioned.fill(child: CameraPreview(_cameraController!))
              : Positioned.fill(
                  child: Container(color: const Color(0xFF050D1A))),

          // ── Oval cutout overlay ──────────────────────────────────
          Positioned.fill(
              child: _OvalCutoutOverlay(frameW: frameW, frameH: frameH)),

          // ── Scan line ────────────────────────────────────────────
          Center(
            child: SizedBox(
              width: frameW, height: frameH,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(frameW / 2),
                child: AnimatedBuilder(
                  animation: _scanLineAnim,
                  builder: (_, __) => Stack(children: [
                    Positioned(
                      top: frameH * _scanLineAnim.value - 1,
                      left: 0, right: 0,
                      child: AnimatedBuilder(
                        animation: _pulseAnim,
                        builder: (_, __) => Opacity(
                          opacity: _pulseAnim.value,
                          child: Container(
                            height: 2,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Colors.transparent,
                                Color(0xFF00D4FF),
                                Color(0xFF00FFEA),
                                Color(0xFF00D4FF),
                                Colors.transparent,
                              ]),
                              boxShadow: [BoxShadow(
                                  color: Color(0x9900D4FF),
                                  blurRadius: 12, spreadRadius: 4)],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),

          // ── Corner brackets ──────────────────────────────────────
          Center(
            child: FadeTransition(
              opacity: _cornerAnim,
              child: SizedBox(
                width: frameW + 24, height: frameH + 24,
                child: CustomPaint(
                  painter: _CornerBracketsPainter(
                    color: const Color(0xFF00D4FF),
                    glowColor: const Color(0x6600D4FF),
                  ),
                ),
              ),
            ),
          ),

          // ── Oval glow border ─────────────────────────────────────
          Center(
            child: AnimatedBuilder(
              animation: _pulseAnim,
              builder: (_, __) => Container(
                width: frameW, height: frameH,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(frameW / 2),
                  border: Border.all(
                    color: Color.fromRGBO(0, 212, 255, _pulseAnim.value * 0.6),
                    width: 1.5,
                  ),
                  boxShadow: [BoxShadow(
                    color: Color.fromRGBO(0, 212, 255, _pulseAnim.value * 0.25),
                    blurRadius: 20, spreadRadius: 2,
                  )],
                ),
              ),
            ),
          ),

          // ── Top bar ──────────────────────────────────────────────
          Positioned(
            top: 0, left: 0, right: 0,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: 12),
                child: Row(children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.15)),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white, size: 18),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text("Face Scan",
                      style: TextStyle(
                          color: Colors.white, fontSize: 20,
                          fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                ]),
              ),
            ),
          ),

          // ── Status text ──────────────────────────────────────────
          Positioned(
            bottom: h * 0.22, left: 0, right: 0,
            child: AnimatedBuilder(
              animation: _pulseAnim,
              builder: (_, __) => Opacity(
                opacity: 0.7 + _pulseAnim.value * 0.3,
                child: Text(
                  _scanStatus,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _scanStatus.contains("✓")
                        ? Colors.greenAccent
                        : _scanStatus.contains("✗")
                            ? Colors.redAccent
                            : const Color(0xFF00D4FF),
                    fontSize: 15, letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
          ),

          // ── Dots ─────────────────────────────────────────────────
          Positioned(
            bottom: h * 0.175, left: 0, right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) => AnimatedBuilder(
                animation: _scanLineController,
                builder: (_, __) {
                  final active = (_scanLineController.value * 3).floor() % 3 == i;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 18 : 7, height: 7,
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
            bottom: h * 0.055, left: 0, right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _isScanning ? null : _captureAndScan,
                child: AnimatedBuilder(
                  animation: _pulseAnim,
                  builder: (_, __) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: _isScanning
                            ? [Colors.grey.shade600, Colors.grey.shade800]
                            : [const Color(0xFF00D4FF), const Color(0xFF0080FF)],
                        begin: Alignment.topLeft,
                        end:   Alignment.bottomRight,
                      ),
                      boxShadow: [BoxShadow(
                        color: Color.fromRGBO(0, 212, 255,
                            _isScanning ? 0.1 : _pulseAnim.value * 0.55),
                        blurRadius: 25, spreadRadius: 4,
                      )],
                    ),
                    child: _isScanning
                        ? const Padding(
                            padding: EdgeInsets.all(22),
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2.5),
                          )
                        : const Icon(Icons.camera_alt_rounded,
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
// PAINTERS
// ══════════════════════════════════════════════════════════════════════
class _OvalCutoutOverlay extends StatelessWidget {
  final double frameW, frameH;
  const _OvalCutoutOverlay({required this.frameW, required this.frameH});
  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _OvalCutoutPainter(frameW: frameW, frameH: frameH));
}

class _OvalCutoutPainter extends CustomPainter {
  final double frameW, frameH;
  _OvalCutoutPainter({required this.frameW, required this.frameH});
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()..addOval(Rect.fromCenter(center: c, width: frameW, height: frameH)),
      ),
      Paint()..color = const Color(0xCC050D1A),
    );
  }
  @override
  bool shouldRepaint(_OvalCutoutPainter o) =>
      o.frameW != frameW || o.frameH != frameH;
}

class _CornerBracketsPainter extends CustomPainter {
  final Color color, glowColor;
  _CornerBracketsPainter({required this.color, required this.glowColor});
  @override
  void paint(Canvas canvas, Size size) {
    const len = 28.0, r = 10.0, sw = 3.0;
    final paint = Paint()
      ..color = color ..strokeWidth = sw
      ..style = PaintingStyle.stroke ..strokeCap = StrokeCap.round;
    final glow = Paint()
      ..color = glowColor ..strokeWidth = sw + 6
      ..style = PaintingStyle.stroke ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    for (final c in [
      _CD(Offset(0, 0),                    1,  1),
      _CD(Offset(size.width, 0),          -1,  1),
      _CD(Offset(0, size.height),          1, -1),
      _CD(Offset(size.width, size.height),-1, -1),
    ]) {
      final p = Path()
        ..moveTo(c.o.dx + c.sx * len, c.o.dy)
        ..lineTo(c.o.dx + c.sx * r,   c.o.dy)
        ..quadraticBezierTo(c.o.dx, c.o.dy, c.o.dx, c.o.dy + c.sy * r)
        ..lineTo(c.o.dx, c.o.dy + c.sy * len);
      canvas.drawPath(p, glow);
      canvas.drawPath(p, paint);
    }
  }
  @override
  bool shouldRepaint(_) => false;
}

class _CD {
  final Offset o; final double sx, sy;
  _CD(this.o, this.sx, this.sy);
}