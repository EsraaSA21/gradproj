import 'package:faceapp/screens/students_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:faceapp/screens/add_students_screen.dart';


class _Responsive {
  final double w;
  final double h;

  _Responsive(BuildContext context)
      : w = MediaQuery.of(context).size.width,
        h = MediaQuery.of(context).size.height;

  bool get isSmall  => w < 360;
  bool get isMedium => w < 480;
  bool get isLarge  => w < 768;
  bool get isTablet => w >= 768;

  double dp(double size) {
    if (isSmall)  return size * 0.85;
    if (isMedium) return size * 1.0;
    if (isLarge)  return size * 1.1;
    return size * 1.25;
  }

  double fs(double size) {
    if (isSmall)  return size * 0.88;
    if (isMedium) return size * 1.0;
    if (isLarge)  return size * 1.08;
    return size * 1.2;
  }

  double get horizontalPadding {
    if (isTablet) return w * 0.08;
    if (isLarge)  return w * 0.06;
    return w * 0.05;
  }

  int get gridCrossAxisCount {
    if (isTablet) return 4;
    if (isLarge)  return 2;
    return 2;
  }

  double get gridChildAspectRatio {
    if (isTablet) return 1.5;
    if (isLarge)  return 1.2;
    if (isSmall)  return 1.05;
    return 1.15;
  }

  double get gridSpacing {
    if (isTablet) return 20;
    if (isSmall)  return 12;
    return 16;
  }

  double get headerMinHeight {
    if (isTablet) return 150;
    if (isSmall)  return 100;
    return 120;
  }

  double get headerIconSize {
    if (isTablet) return 44;
    if (isSmall)  return 28;
    return 35;
  }

  double get headerIconPadding {
    if (isTablet) return 16;
    if (isSmall)  return 10;
    return 12;
  }

  double get quickActionHeight {
    if (isTablet) return 160;
    if (isSmall)  return 115;
    return 130;
  }

  double get quickActionIconSize {
    if (isTablet) return 64;
    if (isSmall)  return 44;
    return 50;
  }

  double get quickActionIconInner {
    if (isTablet) return 30;
    if (isSmall)  return 20;
    return 24;
  }

  double get statIconSize {
    if (isTablet) return 26;
    if (isSmall)  return 20;
    return 24;
  }
}

// ══════════════════════════════════════════════════════════════════════
// REGISTRAR SCREEN
// ══════════════════════════════════════════════════════════════════════
class RegistrarScreen extends StatelessWidget {
  const RegistrarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final r = _Responsive(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Header ───────────────────────────────────────────
              _RegistrarHeader(r: r),

              SizedBox(height: r.dp(20)),

              // ── Stats Grid ───────────────────────────────────────
// ── Stats Grid ───────────────────────────────────────
Padding(
  padding: EdgeInsets.symmetric(horizontal: r.horizontalPadding),
  child: Column(
    children: [
      Row(
        children: [
          Expanded(
            child: statCard(
              r: r,
              icon: PhosphorIcons.users(),
              title: "Total Students",
              number: "1.2K",
              gradientColors: const [
                Color.fromARGB(255, 66, 41, 255),
                Color.fromARGB(255, 103, 76, 255),
              ],
            ),
          ),
          SizedBox(width: r.gridSpacing),
          Expanded(
            child: statCard(
              r: r,
              icon: PhosphorIcons.bell(),
              title: "Today's Scans",
              number: "350",
              gradientColors: const [
                Color.fromARGB(255, 255, 25, 232),
                Color.fromARGB(255, 144, 12, 164),
              ],
            ),
          ),
        ],
      ),
      SizedBox(height: r.gridSpacing),
      Row(
        children: [
          Expanded(
            child: statCard(
              r: r,
              icon: PhosphorIcons.checkCircle(),
              title: "Success Rate",
              number: "12.5K",
              gradientColors: const [
                Color.fromARGB(255, 50, 193, 128),
                Color.fromARGB(255, 24, 164, 20),
              ],
            ),
          ),
          SizedBox(width: r.gridSpacing),
          Expanded(
            child: statCard(
              r: r,
              icon: PhosphorIcons.clock(),
              title: "Active Users",
              number: "4.8",
              gradientColors: const [
                Color.fromARGB(255, 235, 111, 22),
                Color.fromARGB(255, 236, 65, 65),
              ],
            ),
          ),
        ],
      ),
    ],
  ),
),

              SizedBox(height: r.dp(16)),

              // ── Quick Actions Label ──────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: r.horizontalPadding),
                child: Text(
                  "Quick Actions",
                  style: TextStyle(fontSize: r.fs(19)),
                ),
              ),

              SizedBox(height: r.dp(10)),

              // ── Quick Actions ────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: r.horizontalPadding),
                child: Row(
                  children: [
                    Expanded(
                      child: QuickActionCard(
                        r: r,
                        icon: PhosphorIconsBold.userPlus,
                        title: "Add\nStudent",
                        iconBg: const Color(0xFF2F49F5),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AddStudentsScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: r.dp(16)),
                    Expanded(
                      child: QuickActionCard(
                        r: r,
                        icon: PhosphorIconsBold.listBullets,
                        title: "Students\nList",
                        iconBg: const Color(0xFF7A1CF0),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => StudentsListScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // ── Info Box ─────────────────────────────────────────
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(r.horizontalPadding),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 240, 252, 255),
                  borderRadius: BorderRadius.circular(r.dp(18)),
                  border: Border.all(color: Colors.blue),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(r.dp(13)),
                  child: Text(
                    "Limited operational permissions. You can add or edit students, but you cannot delete them or modify system settings.",
                    style: TextStyle(
                      fontSize: r.fs(13.5),
                      color: const Color.fromARGB(255, 69, 69, 69),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// HEADER
// ══════════════════════════════════════════════════════════════════════
class _RegistrarHeader extends StatelessWidget {
  final _Responsive r;
  const _RegistrarHeader({required this.r});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: r.headerMinHeight),
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: r.horizontalPadding,
        vertical: r.dp(16),
      ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        gradient: LinearGradient(
          colors: [Colors.blue, Color.fromARGB(255, 3, 175, 255)],
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome back",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: r.fs(r.isSmall ? 13 : 16),
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: r.dp(4)),
              Text(
                "Registrar",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: r.fs(r.isTablet ? 26 : 22),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: r.dp(4)),
              Row(
                children: [
                  Icon(
                    PhosphorIcons.circle(),
                    size: r.dp(10),
                    color: Colors.white70,
                  ),
                  SizedBox(width: r.dp(6)),
                  Text(
                    "Registrar",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: r.fs(13),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: EdgeInsets.all(r.headerIconPadding),
            child: Icon(
              PhosphorIcons.users(),
              color: Colors.blue,
              size: r.headerIconSize,
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// STAT CARD
// ══════════════════════════════════════════════════════════════════════
Widget statCard({
  required _Responsive r,
  required IconData icon,
  required String title,
  required String number,
  required List<Color> gradientColors,
}) {
  return Container(
    padding: EdgeInsets.all(r.dp(14)),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(r.dp(18)),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(r.dp(8)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(r.dp(10)),
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Icon(icon, color: Colors.white, size: r.statIconSize),
        ),
        SizedBox(height: r.dp(12)),
        Text(
          title,
          style: TextStyle(
            fontSize: r.fs(13),
            color: const Color.fromARGB(255, 104, 104, 104),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: r.dp(4)),
        Text(
          number,
          style: TextStyle(
            fontSize: r.fs(18),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

// ══════════════════════════════════════════════════════════════════════
// QUICK ACTION CARD
// ══════════════════════════════════════════════════════════════════════
class QuickActionCard extends StatelessWidget {
  final _Responsive r;
  final IconData icon;
  final String title;
  final Color iconBg;
  final VoidCallback onTap;

  const QuickActionCard({
    super.key,
    required this.r,
    required this.icon,
    required this.title,
    required this.iconBg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(r.dp(22)),
      child: Container(
        height: r.quickActionHeight,
        padding: EdgeInsets.symmetric(
          horizontal: r.dp(10),
          vertical: r.dp(12),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(r.dp(22)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: r.quickActionIconSize,
              height: r.quickActionIconSize,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(r.dp(16)),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: r.quickActionIconInner,
              ),
            ),
            SizedBox(height: r.dp(10)),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: r.fs(13.5),
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}