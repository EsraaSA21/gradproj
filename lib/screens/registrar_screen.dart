import 'package:faceapp/screens/students_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:faceapp/screens/add_students_screen.dart';

class RegistrarScreen extends StatelessWidget {
  const RegistrarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final bool isTablet = width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ── HEADER ──────────────────────────────────────────────
              const _RegistrarHeader(),

              const SizedBox(height: 20),

              /// ── STATS GRID ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: isTablet ? 4 : 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: isTablet ? 1.5 : 1.15,
                  children: [
                    statCard(
                      icon: PhosphorIcons.users(),
                      title: "Total Students",
                      number: "1.2K",
                      gradientColors: const [
                        Color.fromARGB(255, 66, 41, 255),
                        Color.fromARGB(255, 103, 76, 255),
                      ],
                    ),
                    statCard(
                      icon: PhosphorIcons.bell(),
                      title: "Today's Scans",
                      number: "350",
                      gradientColors: const [
                        Color.fromARGB(255, 255, 25, 232),
                        Color.fromARGB(255, 144, 12, 164),
                      ],
                    ),
                    statCard(
                      icon: PhosphorIcons.checkCircle(),
                      title: "Success Rate",
                      number: "12.5K",
                      gradientColors: const [
                        Color.fromARGB(255, 50, 193, 128),
                        Color.fromARGB(255, 24, 164, 20),
                      ],
                    ),
                    statCard(
                      icon: PhosphorIcons.clock(),
                      title: "Active Users",
                      number: "4.8",
                      gradientColors: const [
                        Color.fromARGB(255, 235, 111, 22),
                        Color.fromARGB(255, 236, 65, 65),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// ── QUICK ACTIONS label ──────────────────────────────────
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Text("Quick Actions", style: TextStyle(fontSize: 19)),
              ),

              const SizedBox(height: 10),

              /// ── QUICK ACTIONS — كارتين بس للـ Registrar ─────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    Expanded(
                      child: QuickActionCard(
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
                    const SizedBox(width: 16),
                    Expanded(
                     child: QuickActionCard(
                            icon: PhosphorIconsBold.listBullets,
                            title: "Students\nList",
                            iconBg: const Color(0xFF7A1CF0),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>  StudentsListScreen(),
                                ),
                              );
                            },
                          ),
                    ),
                  ],
                ),
              ),

              /// ── INFO BOX ─────────────────────────────────────────────
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 240, 252, 255),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.blue),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Padding(
                  padding: EdgeInsets.all(13),
                  child: Text(
                    "Limited operational permissions. You can add or edit students, but you cannot delete them or modify system settings.",
                    style: TextStyle(
                      fontSize: 13.5,
                      color: Color.fromARGB(255, 69, 69, 69),
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

/// ── HEADER ──────────────────────────────────────────────────────────────────
class _RegistrarHeader extends StatelessWidget {
  const _RegistrarHeader();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final bool isTablet = width > 600;
    final bool isSmall = width < 380;

    return Container(
     constraints: const BoxConstraints(minHeight: 120),
  width: double.infinity,
  padding: EdgeInsets.symmetric(
    horizontal: width * 0.05,
    vertical: 16,
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
                  fontSize: isSmall ? 13 : 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Registrar",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isTablet ? 26 : 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    PhosphorIcons.circle(),
                    size: 10,
                    color: Colors.white70,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    "Registrar",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
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
            padding: const EdgeInsets.all(12),
            child: Icon(
              PhosphorIcons.users(),
              color: Colors.blue,
              size: isTablet ? 40 : 35,
            ),
          ),
        ],
      ),
    );
  }
}

/// ── STAT CARD ────────────────────────────────────────────────────────────────
Widget statCard({
  required IconData icon,
  required String title,
  required String number,
  required List<Color> gradientColors,
}) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Color.fromARGB(255, 104, 104, 104),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          number,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

/// ── QUICK ACTION CARD ────────────────────────────────────────────────────────

class QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconBg;
  final VoidCallback onTap;

  const QuickActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.iconBg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        height: 130,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
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
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}