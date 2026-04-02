import 'package:faceapp/config/user_session.dart';
import 'package:faceapp/screens/verifier_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:faceapp/screens/face_scan.dart';

// ══════════════════════════════════════════════════════════════════════
// BREAKPOINTS HELPER
// ══════════════════════════════════════════════════════════════════════
class _Responsive {
  final double w;
  final double h;

  _Responsive(BuildContext context)
      : w = MediaQuery.of(context).size.width,
        h = MediaQuery.of(context).size.height;

  // Breakpoints
  bool get isSmall  => w < 360;   // شاشات صغيرة جداً
  bool get isMedium => w < 480;   // موبايل عادي
  bool get isLarge  => w < 768;   // موبايل كبير / فولدد
  bool get isTablet => w >= 768;  // تابلت

  // Scale helpers
  double dp(double size) {
    if (isSmall)  return size * 0.85;
    if (isMedium) return size * 1.0;
    if (isLarge)  return size * 1.1;
    return size * 1.25;           // تابلت
  }

  double fs(double size) {
    if (isSmall)  return size * 0.88;
    if (isMedium) return size * 1.0;
    if (isLarge)  return size * 1.08;
    return size * 1.2;            // تابلت
  }

  // Icon size
  double get xIconContainer {
    if (isSmall)  return 75.0;
    if (isMedium) return 90.0;
    if (isLarge)  return 100.0;
    return 115.0;
  }

  double get xIconSize {
    if (isSmall)  return 42.0;
    if (isMedium) return 50.0;
    if (isLarge)  return 56.0;
    return 64.0;
  }

  // Padding
  double get horizontalPadding {
    if (isTablet) return w * 0.12;
    if (isLarge)  return w * 0.07;
    return w * 0.05;
  }

  double get topSpacing {
    if (isSmall)  return h * 0.04;
    if (isMedium) return h * 0.05;
    return h * 0.06;
  }

  // Button height
  double get buttonHeight {
    if (isSmall)  return 50.0;
    if (isMedium) return 56.0;
    if (isLarge)  return 60.0;
    return 66.0;
  }

  // Card padding
  double get cardPadding {
    if (isSmall)  return 14.0;
    if (isMedium) return 18.0;
    if (isLarge)  return 20.0;
    return 24.0;
  }

  double get cardRadius {
    if (isSmall)  return 16.0;
    if (isMedium) return 20.0;
    return 24.0;
  }
}

// ══════════════════════════════════════════════════════════════════════
// VERIFICATION FAILED SCREEN
// ══════════════════════════════════════════════════════════════════════
class VerificationFailedScreen extends StatefulWidget {
  final String? errorMessage;

  const VerificationFailedScreen({super.key, this.errorMessage});

  @override
  State<VerificationFailedScreen> createState() =>
      _VerificationFailedScreenState();
}

class _VerificationFailedScreenState extends State<VerificationFailedScreen>
    with TickerProviderStateMixin {

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
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _cardSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _cardController, curve: Curves.easeOut));
    _cardOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOut),
    );

    _bottomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _bottomSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _bottomController, curve: Curves.easeOut),
    );
    _bottomOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bottomController, curve: Curves.easeOut),
    );

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
    final r = _Responsive(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F0F0),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: r.horizontalPadding),
            child: Column(
              children: [
                SizedBox(height: r.topSpacing),

                // ── X Icon ──────────────────────────────────────────
                ScaleTransition(
                  scale: _xScale,
                  child: FadeTransition(
                    opacity: _xOpacity,
                    child: Container(
                      width: r.xIconContainer,
                      height: r.xIconContainer,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEF5350), Color(0xFFB71C1C)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFEF5350).withOpacity(0.45),
                            blurRadius: 22,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: r.xIconSize,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: r.dp(16)),

                // ── Title ───────────────────────────────────────────
                FadeTransition(
                  opacity: _xOpacity,
                  child: Column(
                    children: [
                      Text(
                        "فشل التعرف",
                        style: TextStyle(
                          fontSize: r.fs(26),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFB71C1C),
                        ),
                      ),
                      SizedBox(height: r.dp(4)),
                      Text(
                        "Face Verification Failed",
                        style: TextStyle(
                          fontSize: r.fs(13),
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: r.dp(24)),

                // ── Error Card ──────────────────────────────────────
                SlideTransition(
                  position: _cardSlide,
                  child: FadeTransition(
                    opacity: _cardOpacity,
                    child: _buildErrorCard(r),
                  ),
                ),

                SizedBox(height: r.dp(14)),

                // ── Failed At ───────────────────────────────────────
                FadeTransition(
                  opacity: _bottomOpacity,
                  child: Text(
                    _failedAt,
                    style: TextStyle(
                      fontSize: r.fs(11.5),
                      color: Colors.grey.shade400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: r.dp(24)),

                // ── Buttons ─────────────────────────────────────────
                SlideTransition(
                  position: _bottomSlide,
                  child: FadeTransition(
                    opacity: _bottomOpacity,
                    child: _buildButtons(r, context),
                  ),
                ),

                SizedBox(height: r.dp(20)),

                // ── Security Note ───────────────────────────────────
                FadeTransition(
                  opacity: _bottomOpacity,
                  child: Text(
                    "For security reasons, please ensure you follow all selfie\ntips before scanning",
                    style: TextStyle(
                      fontSize: r.fs(11),
                      color: Colors.grey.shade400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: r.dp(16)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Error Card ────────────────────────────────────────────────────
  Widget _buildErrorCard(_Responsive r) {
    final String errorMsg =
        widget.errorMessage ?? "Face not recognized in our system";

    final reasons = [
      "Poor lighting conditions",
      "Face not clearly visible",
      "Not registered in the system",
      "Camera quality issues",
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(r.cardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Error Details row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(r.dp(10)),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(r.dp(12)),
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: const Color(0xFFEF5350),
                  size: r.dp(22),
                ),
              ),
              SizedBox(width: r.dp(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Error Details",
                      style: TextStyle(
                        fontSize: r.fs(11),
                        color: Colors.grey.shade500,
                      ),
                    ),
                    SizedBox(height: r.dp(4)),
                    Text(
                      errorMsg,
                      style: TextStyle(
                        fontSize: r.fs(15),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: r.dp(18)),
          Divider(color: Colors.grey.shade100, thickness: 1.2),
          SizedBox(height: r.dp(14)),

          // Possible Reasons
          Text(
            "Possible Reasons:",
            style: TextStyle(
              fontSize: r.fs(12.5),
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: r.dp(10)),

          ...reasons.map(
            (reason) => Padding(
              padding: EdgeInsets.only(bottom: r.dp(8)),
              child: Row(
                children: [
                  Container(
                    width: r.dp(6),
                    height: r.dp(6),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFEF5350),
                    ),
                  ),
                  SizedBox(width: r.dp(10)),
                  Expanded(
                    child: Text(
                      reason,
                      style: TextStyle(
                        fontSize: r.fs(13.5),
                        color: const Color(0xFF333333),
                      ),
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

  // ── Buttons ───────────────────────────────────────────────────────
  Widget _buildButtons(_Responsive r, BuildContext context) {
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
            width: double.infinity,
            height: r.buttonHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(r.dp(18)),
              gradient: const LinearGradient(
                colors: [Color(0xFFFF7043), Color(0xFFE53935)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE53935).withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh_rounded,
                    color: Colors.white, size: r.dp(22)),
                SizedBox(width: r.dp(10)),
                Text(
                  "Try Again",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: r.fs(17),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: r.dp(12)),

        // Return to Home
        GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    Verifierscreen(userData: currentUser),
              ),
              (route) => false,
            );
          },
          child: Container(
            width: double.infinity,
            height: r.buttonHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(r.dp(18)),
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade200, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.home_rounded,
                    color: Colors.grey.shade600, size: r.dp(22)),
                SizedBox(width: r.dp(10)),
                Text(
                  "Return to Home",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: r.fs(16),
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