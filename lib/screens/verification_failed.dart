import 'package:faceapp/screens/verifier_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:faceapp/screens/selfitips.dart';
import 'package:faceapp/screens/face_scan.dart'; // ✏️ غيّر المسار حسب مشروعك

// ══════════════════════════════════════════════════════════════════════
// SCREEN
// ══════════════════════════════════════════════════════════════════════
class VerificationFailedScreen extends StatefulWidget {
  /// رسالة الخطأ من الباك اند — لو ما في، بتستخدم الافتراضية
  final String? errorMessage;

  const VerificationFailedScreen({super.key, this.errorMessage});

  @override
  State<VerificationFailedScreen> createState() =>
      _VerificationFailedScreenState();
}

class _VerificationFailedScreenState extends State<VerificationFailedScreen>
    with TickerProviderStateMixin {
  // ── Animations ──────────────────────────────────────────────────────
  late AnimationController _xController;
  late AnimationController _cardController;
  late AnimationController _bottomController;

  late Animation<double> _xScale;
  late Animation<double> _xOpacity;
  late Animation<Offset> _cardSlide;
  late Animation<double> _cardOpacity;
  late Animation<Offset> _bottomSlide;
  late Animation<double> _bottomOpacity;

  late String _failedAt;

  @override
  void initState() {
    super.initState();

    _failedAt =
        "Failed at ${DateFormat('hh:mm a').format(DateTime.now())} • "
        "${DateFormat('EEEE, MMMM d, y').format(DateTime.now())}";

    _initAnimations();
  }

  void _initAnimations() {
    // X icon bounce
    _xController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _xScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _xController, curve: Curves.elasticOut),
    );
    _xOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _xController,
          curve: const Interval(0.0, 0.4, curve: Curves.easeIn)),
    );

    // Card slide up
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _cardSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end:   Offset.zero,
    ).animate(CurvedAnimation(parent: _cardController, curve: Curves.easeOut));
    _cardOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOut),
    );

    // Bottom buttons
    _bottomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _bottomSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end:   Offset.zero,
    ).animate(
        CurvedAnimation(parent: _bottomController, curve: Curves.easeOut));
    _bottomOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bottomController, curve: Curves.easeOut),
    );

    // تشغيل بالتسلسل
    _xController.forward().then((_) {
      _cardController.forward().then((_) {
        _bottomController.forward();
      });
    });
  }

  @override
  void dispose() {
    _xController.dispose();
    _cardController.dispose();
    _bottomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;
    double fs(double s) => s * (w / 375).clamp(0.85, 1.3);
    double dp(double s) => s * (w / 375).clamp(0.8, 1.3);
return WillPopScope(
    onWillPop: () async {
      return false; // ❌ يمنع الرجوع بزر الجهاز
    },
   
    child: 
 Scaffold(
      backgroundColor: const Color(0xFFF8F0F0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: w * 0.05),
          child: Column(
            children: [
              SizedBox(height: h * 0.05),

              // ── ❌ X Icon ────────────────────────────────────────────
              ScaleTransition(
                scale: _xScale,
                child: FadeTransition(
                  opacity: _xOpacity,
                  child: Container(
                    width:  dp(90),
                    height: dp(90),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEF5350), Color(0xFFB71C1C)],
                        begin: Alignment.topLeft,
                        end:   Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:       const Color(0xFFEF5350).withOpacity(0.45),
                          blurRadius:  22,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size:  dp(50),
                    ),
                  ),
                ),
              ),

              SizedBox(height: dp(16)),

              // ── العنوان ─────────────────────────────────────────────
              FadeTransition(
                opacity: _xOpacity,
                child: Column(
                  children: [
                    Text(
                      "فشل التعرف",
                      style: TextStyle(
                        fontSize:   fs(26),
                        fontWeight: FontWeight.bold,
                        color:      const Color(0xFFB71C1C),
                      ),
                    ),
                    SizedBox(height: dp(4)),
                    Text(
                      "Face Verification Failed",
                      style: TextStyle(
                        fontSize: fs(13),
                        color:    Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: dp(24)),

              // ── Error Card ───────────────────────────────────────────
              SlideTransition(
                position: _cardSlide,
                child: FadeTransition(
                  opacity: _cardOpacity,
                  child: _buildErrorCard(dp, fs, w),
                ),
              ),

              SizedBox(height: dp(14)),

              // ── Failed At ────────────────────────────────────────────
              FadeTransition(
                opacity: _bottomOpacity,
                child: Text(
                  _failedAt,
                  style: TextStyle(
                    fontSize: fs(11.5),
                    color:    Colors.grey.shade400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: dp(24)),

              // ── Buttons ──────────────────────────────────────────────
              SlideTransition(
                position: _bottomSlide,
                child: FadeTransition(
                  opacity: _bottomOpacity,
                  child: _buildButtons(dp, fs, w, context),
                ),
              ),

              SizedBox(height: dp(20)),

              // ── Security Note ────────────────────────────────────────
              FadeTransition(
                opacity: _bottomOpacity,
                child: Text(
                  "For security reasons, please ensure you follow all selfie\ntips before scanning",
                  style: TextStyle(
                    fontSize: fs(11),
                    color:    Colors.grey.shade400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: dp(16)),
            ],
          ),
        ),
      ),
 ),
    );
  }

  // ── Error Card ───────────────────────────────────────────────────────
  Widget _buildErrorCard(
      double Function(double) dp, double Function(double) fs, double w) {
    final String errorMsg = widget.errorMessage ??
        "Face not recognized in our system";

    final reasons = [
      "Poor lighting conditions",
      "Face not clearly visible",
      "Not registered in the system",
      "Camera quality issues",
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(dp(18)),
      decoration: BoxDecoration(
        color:        Colors.white,
        borderRadius: BorderRadius.circular(dp(20)),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withOpacity(0.07),
            blurRadius: 14,
            offset:     const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Error Details
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:    EdgeInsets.all(dp(10)),
                decoration: BoxDecoration(
                  color:        const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(dp(12)),
                ),
                child: Icon(Icons.warning_amber_rounded,
                    color: const Color(0xFFEF5350), size: dp(22)),
              ),
              SizedBox(width: dp(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Error Details",
                      style: TextStyle(
                        fontSize: fs(11),
                        color:    Colors.grey.shade500,
                      ),
                    ),
                    SizedBox(height: dp(4)),
                    Text(
                      errorMsg,
                      style: TextStyle(
                        fontSize:   fs(15),
                        fontWeight: FontWeight.bold,
                        color:      const Color(0xFF1A1A2E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: dp(18)),
          Divider(color: Colors.grey.shade100, thickness: 1.2),
          SizedBox(height: dp(14)),

          // Possible Reasons
          Text(
            "Possible Reasons:",
            style: TextStyle(
              fontSize:   fs(12.5),
              color:      Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: dp(10)),

          ...reasons.map(
            (reason) => Padding(
              padding: EdgeInsets.only(bottom: dp(8)),
              child: Row(
                children: [
                  Container(
                    width:  dp(6),
                    height: dp(6),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFEF5350),
                    ),
                  ),
                  SizedBox(width: dp(10)),
                  Text(
                    reason,
                    style: TextStyle(
                      fontSize: fs(13.5),
                      color:    const Color(0xFF333333),
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

  // ── Buttons ──────────────────────────────────────────────────────────
  Widget _buildButtons(double Function(double) dp, double Function(double) fs,
      double w, BuildContext context) {
    return Column(
      children: [
        // Try Again
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const FaceScanScreen()),
            );
          },
          child: Container(
            width:  double.infinity,
            height: dp(56),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(dp(18)),
              gradient: const LinearGradient(
                colors: [Color(0xFFFF7043), Color(0xFFE53935)],
                begin: Alignment.centerLeft,
                end:   Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                  color:      const Color(0xFFE53935).withOpacity(0.4),
                  blurRadius: 16,
                  offset:     const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh_rounded,
                    color: Colors.white, size: dp(22)),
                SizedBox(width: dp(10)),
                Text(
                  "Try Again",
                  style: TextStyle(
                    color:      Colors.white,
                    fontSize:   fs(17),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: dp(12)),

        // Return to Home
        GestureDetector(
          onTap: () {
           Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) =>Verifierscreen(),
        ),
        (route) => false,
      );
          },
          child: Container(
            width:  double.infinity,
            height: dp(56),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(dp(18)),
              color:        Colors.white,
              border: Border.all(color: Colors.grey.shade200, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color:      Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset:     const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.home_rounded,
                    color: Colors.grey.shade600, size: dp(22)),
                SizedBox(width: dp(10)),
                Text(
                  "Return to Home",
                  style: TextStyle(
                    color:      Colors.grey.shade700,
                    fontSize:   fs(16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}