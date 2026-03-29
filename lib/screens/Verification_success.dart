import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'package:faceapp/screens/verified_student.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// ══════════════════════════════════════════════════════════════════════
// MODEL — البيانات القادمة من الباك اند بعد نجاح الـ face scan
// ══════════════════════════════════════════════════════════════════════


// ══════════════════════════════════════════════════════════════════════
// SCREEN
// ══════════════════════════════════════════════════════════════════════
class VerificationSuccessScreen extends StatefulWidget {
  /// بتقدر تمرر الـ data من الباك اند مباشرة
  final VerifiedStudent? student;

  const VerificationSuccessScreen({super.key, this.student});

  @override
  State<VerificationSuccessScreen> createState() =>
      _VerificationSuccessScreenState();
}

class _VerificationSuccessScreenState extends State<VerificationSuccessScreen>
    with TickerProviderStateMixin {
  // ── Animations ──────────────────────────────────────────────────────
  late AnimationController _checkController;
  late AnimationController _cardController;
  late AnimationController _bottomController;

  late Animation<double> _checkScale;
  late Animation<double> _checkOpacity;
  late Animation<Offset> _cardSlide;
  late Animation<double> _cardOpacity;
  late Animation<Offset> _bottomSlide;
  late Animation<double> _bottomOpacity;

  // بيانات تجريبية لو ما في بيانات من الباك اند
  late VerifiedStudent _student;

  @override
  void initState() {
    super.initState();

    _student = widget.student ??
        VerifiedStudent(
          name:             "Ahmed Hassan",
          studentId:        "20241234",
          faculty:          "Information Technology",
          major:            "Computer Science",
          yearLevel:        "3rd Year",
          verificationTime: DateFormat('hh:mm a').format(DateTime.now()),
          status:           "Authorized",
          date:             DateFormat('EEEE, MMMM d, y').format(DateTime.now()),
        );

    _initAnimations();
  }

  void _initAnimations() {
    // Check icon
    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _checkScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _checkController, curve: Curves.elasticOut),
    );
    _checkOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _checkController,
          curve: const Interval(0.0, 0.5, curve: Curves.easeIn)),
    );

    // Card slide up
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _cardSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end:   Offset.zero,
    ).animate(CurvedAnimation(parent: _cardController, curve: Curves.easeOut));
    _cardOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOut),
    );

    // Bottom section
    _bottomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _bottomSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end:   Offset.zero,
    ).animate(
        CurvedAnimation(parent: _bottomController, curve: Curves.easeOut));
    _bottomOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bottomController, curve: Curves.easeOut),
    );

    // تشغيل الأنيميشن بالتسلسل
    _checkController.forward().then((_) {
      _cardController.forward().then((_) {
        _bottomController.forward();
      });
    });
  }

  @override
  void dispose() {
    _checkController.dispose();
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

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: w * 0.05),
          child: Column(
            children: [
              SizedBox(height: h * 0.05),

              // ── ✅ Check Icon ────────────────────────────────────────
              ScaleTransition(
                scale: _checkScale,
                child: FadeTransition(
                  opacity: _checkOpacity,
                  child: Container(
                    width:  dp(90),
                    height: dp(90),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                        begin: Alignment.topLeft,
                        end:   Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:      const Color(0xFF4CAF50).withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                  PhosphorIcons.checkCircle(),
                      color: Colors.white,
                      size:  dp(50),
                    ),
                  ),
                ),
              ),

              SizedBox(height: dp(16)),

              // ── العنوان ─────────────────────────────────────────────
              FadeTransition(
                opacity: _checkOpacity,
                child: Column(
                  children: [
                    Text(
                      "تم التعرف بنجاح",
                      style: TextStyle(
                        fontSize:   fs(24),
                        fontWeight: FontWeight.bold,
                        color:      const Color(0xFF1A1A2E),
                      ),
                    ),
                    SizedBox(height: dp(4)),
                    Text(
                      "Face Verified Successfully",
                      style: TextStyle(
                        fontSize: fs(13),
                        color:    Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: dp(24)),

              // ── Student Card ─────────────────────────────────────────
              SlideTransition(
                position: _cardSlide,
                child: FadeTransition(
                  opacity: _cardOpacity,
                  child: _buildStudentCard(dp, fs, w),
                ),
              ),

              SizedBox(height: dp(16)),

              // ── Verification Info Row ────────────────────────────────
              SlideTransition(
                position: _bottomSlide,
                child: FadeTransition(
                  opacity: _bottomOpacity,
                  child: _buildInfoRow(dp, fs, w),
                ),
              ),

              SizedBox(height: dp(10)),

              // ── Date ────────────────────────────────────────────────
              FadeTransition(
                opacity: _bottomOpacity,
                child: Text(
                  _student.date,
                  style: TextStyle(
                    fontSize: fs(12),
                    color:    Colors.grey.shade400,
                  ),
                ),
              ),

              SizedBox(height: dp(24)),

              // ── Return to Home Button ────────────────────────────────
              SlideTransition(
                position: _bottomSlide,
                child: FadeTransition(
                  opacity: _bottomOpacity,
                  child: _buildReturnButton(dp, fs, w, context),
                ),
              ),

              SizedBox(height: dp(20)),
            ],
          ),
        ),
      ),
    );
  }

  // ── Student Card Widget ──────────────────────────────────────────────
  Widget _buildStudentCard(
      double Function(double) dp, double Function(double) fs, double w) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(dp(22)),
        gradient: const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF3949AB)],
          begin: Alignment.topLeft,
          end:   Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color:      const Color(0xFF1565C0).withOpacity(0.45),
            blurRadius: 24,
            offset:     const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Card Header ────────────────────────────────────────────
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: dp(16), vertical: dp(12)),
            decoration: BoxDecoration(
              color:        Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.only(
                topLeft:  Radius.circular(dp(22)),
                topRight: Radius.circular(dp(22)),
              ),
            ),
            child: Row(
              children: [
                // شعار الجامعة
                Container(
                  width:  dp(44),
                  height: dp(44),
                  decoration: BoxDecoration(
                    color:        Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(dp(10)),
                  ),
                  child: Icon(Icons.account_balance,
                      color: Colors.white, size: dp(24)),
                ),
                SizedBox(width: dp(10)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "جامعة فلسطين التقنية - خضوري",
                        style: TextStyle(
                          color:      Colors.white,
                          fontSize:   fs(12),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      Text(
                        "Palestine Technical University - Kadoorie",
                        style: TextStyle(
                          color:    Colors.white70,
                          fontSize: fs(10),
                        ),
                      ),
                      Text(
                        "Ramallah Branch",
                        style: TextStyle(
                          color:    Colors.white60,
                          fontSize: fs(9),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.verified_user_outlined,
                    color: Colors.white70, size: dp(22)),
              ],
            ),
          ),

          // ── Card Body ──────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.all(dp(16)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Container(
                  width:  dp(80),
                  height: dp(95),
                  decoration: BoxDecoration(
                    color:        Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(dp(14)),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.3), width: 1.5),
                  ),
                  child: Icon(Icons.person_outline,
                      color: Colors.white, size: dp(44)),
                ),

                SizedBox(width: dp(16)),

                // بيانات الطالب
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _cardField("Student Name", _student.name, dp, fs,
                          valueFontSize: 17),
                      SizedBox(height: dp(10)),
                      _cardField("Student ID", _student.studentId, dp, fs),
                      SizedBox(height: dp(10)),
                      _cardField("Faculty", _student.faculty, dp, fs),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Card Footer ────────────────────────────────────────────
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: dp(16), vertical: dp(12)),
            decoration: BoxDecoration(
              color:        Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.only(
                bottomLeft:  Radius.circular(dp(22)),
                bottomRight: Radius.circular(dp(22)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _cardField("Major", _student.major, dp, fs),
                ),
                Expanded(
                  child: _cardField("Year Level", _student.yearLevel, dp, fs),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Helper: حقل نص داخل الكارد ──────────────────────────────────────
  Widget _cardField(
    String label,
    String value,
    double Function(double) dp,
    double Function(double) fs, {
    double valueFontSize = 14,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color:    Colors.white60,
            fontSize: fs(11),
          ),
        ),
        SizedBox(height: dp(2)),
        Text(
          value,
          style: TextStyle(
            color:      Colors.white,
            fontSize:   fs(valueFontSize),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // ── Verification Info Row ────────────────────────────────────────────
  Widget _buildInfoRow(
      double Function(double) dp, double Function(double) fs, double w) {
    return Row(
      children: [
        // Verification Time
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: dp(14), vertical: dp(14)),
            margin:  EdgeInsets.only(right: dp(8)),
            decoration: BoxDecoration(
              color:        Colors.white,
              borderRadius: BorderRadius.circular(dp(16)),
              boxShadow: [
                BoxShadow(
                  color:      Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset:     const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding:    EdgeInsets.all(dp(8)),
                  decoration: BoxDecoration(
                    color:        const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(dp(10)),
                  ),
                  child: Icon(Icons.access_time_rounded,
                      color: Colors.orange, size: dp(18)),
                ),
                SizedBox(width: dp(10)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Verification Time",
                        style: TextStyle(
                            color: Colors.grey, fontSize: fs(10))),
                    Text(
                      _student.verificationTime,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:   fs(14),
                        color:      const Color(0xFF1A1A2E),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Status
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: dp(14), vertical: dp(14)),
            margin:  EdgeInsets.only(left: dp(8)),
            decoration: BoxDecoration(
              color:        Colors.white,
              borderRadius: BorderRadius.circular(dp(16)),
              boxShadow: [
                BoxShadow(
                  color:      Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset:     const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding:    EdgeInsets.all(dp(8)),
                  decoration: BoxDecoration(
                    color:        const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(dp(10)),
                  ),
                  child: Icon(Icons.verified_outlined,
                      color: Colors.green, size: dp(18)),
                ),
                SizedBox(width: dp(10)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Status",
                        style: TextStyle(
                            color: Colors.grey, fontSize: fs(10))),
                    Text(
                      _student.status,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:   fs(14),
                        color:      Colors.green.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Return to Home Button ────────────────────────────────────────────
  Widget _buildReturnButton(double Function(double) dp, double Function(double) fs,
      double w, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // يرجع لشاشة الـ Home ويمسح كل الـ stack
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      child: Container(
        width:  double.infinity,
        height: dp(58),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(dp(18)),
          gradient: const LinearGradient(
            colors: [Color(0xFF3949AB), Color(0xFF1E88E5)],
            begin: Alignment.centerLeft,
            end:   Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color:      const Color(0xFF3949AB).withOpacity(0.4),
              blurRadius: 16,
              offset:     const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home_rounded, color: Colors.white, size: dp(22)),
            SizedBox(width: dp(10)),
            Text(
              "Return to Home",
              style: TextStyle(
                color:      Colors.white,
                fontSize:   fs(17),
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}