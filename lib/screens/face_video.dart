import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
 

class FaceVideoScreen extends StatefulWidget {
  const FaceVideoScreen({super.key});
 
  @override
  State<FaceVideoScreen> createState() => _FaceVideoScreenState();
}
 
class _FaceVideoScreenState extends State<FaceVideoScreen>
    with TickerProviderStateMixin {
  CameraController? _cameraController;
  bool   _isCameraReady = false;
  bool   _isRecording   = false;
  int    _recordSeconds = 0;
  Timer? _timer;
 
  // أنيميشن بسيط لنبضة زر التسجيل
  late AnimationController _pulseController;
  late Animation<double>   _pulseAnim;
 
  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
 
    _initCamera();
  }
 
  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final front = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      _cameraController = CameraController(
        front, ResolutionPreset.high, enableAudio: false,
      );
      await _cameraController!.initialize();
      if (mounted) setState(() => _isCameraReady = true);
    } catch (e) {
      debugPrint('Camera error: $e');
    }
  }
 
  //  بدء التسجيل 
  Future<void> _startRecording() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;
    if (_isRecording) return;
 
    await _cameraController!.startVideoRecording();
    setState(() { _isRecording = true; _recordSeconds = 0; });
 
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _recordSeconds++);
    });
  }
 
  //  إيقاف التسجيل 
  Future<void> _stopRecording() async {
    if (_cameraController == null || !_isRecording) return;
    _timer?.cancel();
 
    try {
      final XFile video = await _cameraController!.stopVideoRecording();
      if (!mounted) return;
      Navigator.pop(context, video.path);
    } catch (e) {
      debugPrint('Stop error: $e');
      if (mounted) Navigator.pop(context, null);
    }
  }
 
  String _formatTime(int s) {
    final m = (s ~/ 60).toString().padLeft(2, '0');
    final sec = (s % 60).toString().padLeft(2, '0');
    return '$m:$sec';
  }
 
  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;
 
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
 
          // Camera Preview — يملأ الشاشة كلها 
          if (_isCameraReady && _cameraController != null)
            Positioned.fill(
              child: CameraPreview(_cameraController!),
            )
          else
            const Positioned.fill(
              child: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
 
          // Top Bar
          Positioned(
            top: 0, left: 0, right: 0,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
 
                    // زر الإغلاق
                    GestureDetector(
                      onTap: () => Navigator.pop(context, null),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Colors.white, size: 22),
                      ),
                    ),
 
                    // مؤشر REC + Timer
                    if (_isRecording)
                      AnimatedBuilder(
                        animation: _pulseAnim,
                        builder: (_, __) => Opacity(
                          opacity: _pulseAnim.value,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(children: [
                              Container(
                                width: 9, height: 9,
                                decoration: const BoxDecoration(
                                    color: Colors.red, shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 7),
                              Text(
                                _formatTime(_recordSeconds),
                                style: const TextStyle(
                                  color: Colors.white, fontSize: 15,
                                  fontWeight: FontWeight.bold, letterSpacing: 1.2,
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ),
 
                    // placeholder عشان يتوازن الـ row
                    const SizedBox(width: 42),
                  ],
                ),
              ),
            ),
          ),
 
          // ── Bottom Controls ───────────────────────────────────────
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 30,
                top: 24,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end:   Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
 
                  // نص الحالة
                  Text(
                    _isRecording ? "Tap to stop recording" : "Tap to start recording",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 13,
                    ),
                  ),
 
                  const SizedBox(height: 20),
 
                  // زر التسجيل
                  GestureDetector(
                    onTap: _isRecording ? _stopRecording : _startRecording,
                    child: AnimatedBuilder(
                      animation: _pulseAnim,
                      builder: (_, __) {
                        return Container(
                          width: 78, height: 78,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3.5),
                          ),
                          child: Center(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeInOut,
                              width:  _isRecording ? 30 : 58,
                              height: _isRecording ? 30 : 58,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                // دائرة = ابدأ | مربع = وقف
                                borderRadius: BorderRadius.circular(
                                    _isRecording ? 6 : 29),
                                boxShadow: _isRecording
                                    ? [BoxShadow(
                                        color: Colors.red.withOpacity(_pulseAnim.value * 0.6),
                                        blurRadius: 14, spreadRadius: 3,
                                      )]
                                    : [],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
 
        ],
      ),
    );
  }
}