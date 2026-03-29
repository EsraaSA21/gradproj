import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:faceapp/screens/add_students_screen.dart';
import 'package:faceapp/screens/students_list_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double horizontalPadding = screenWidth < 380 ? 14 : 18;
    final double contentMaxWidth = screenWidth > 700 ? 560 : double.infinity;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: contentMaxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 18),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.28,
                      children: const [
                        StatCard(
                          icon: PhosphorIconsBold.users,
                          title: "Total Students",
                          value: "1,247",
                          iconBg: Color(0xFF2F49F5),
                          trailingIcon: Icons.bar_chart_rounded,
                          trailingColor: Color(0xFF43D17C),
                        ),
                        StatCard(
                          icon: PhosphorIconsBold.bell,
                          title: "Today's Scans",
                          value: "342",
                          iconBg: Color(0xFFB51CE6),
                          trailingIcon: Icons.bar_chart_rounded,
                          trailingColor: Color(0xFF43D17C),
                        ),
                        StatCard(
                          icon: PhosphorIconsBold.checkCircle,
                          title: "Success Rate",
                          value: "80%",
                          iconBg: Color(0xFF10C654),
                          trailingIcon: Icons.bar_chart_rounded,
                          trailingColor: Color(0xFF43D17C),
                        ),
                        StatCard(
                          icon: PhosphorIconsBold.clockCountdown,
                          title: "Active Users",
                          value: "289",
                          iconBg: Color(0xFFE12222),
                          trailingDot: true,
                          trailingColor: Color(0xFFFF6A00),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: const Text(
                      "Quick Actions",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
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
                        const SizedBox(width: 12),
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
                        const SizedBox(width: 12),
                        Expanded(
                          child: QuickActionCard(
                            icon: PhosphorIconsBold.chartBar,
                            title: "Dashboard",
                            iconBg: const Color(0xFF0A84FF),
                            onTap: () async {
                              final Uri url = Uri.parse(
                                "https://your-dashboard-link.com",
                              );
                              if (!await launchUrl(url)) {
                                throw Exception("Could not launch $url");
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFD9E2FF),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4F3FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              PhosphorIconsBold.shieldCheck,
                              color: Color(0xFF4F46E5),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "System Authentication",
                                  style: TextStyle(
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1F2A44),
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Authorized administrators only. All actions are logged and monitored.",
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    height: 1.45,
                                    color: Color(0xFF44506A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 135,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF08B8D9), Color(0xFF123DDE)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF123DDE).withOpacity(0.22),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome back",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Admin",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      PhosphorIconsFill.shieldCheck,
                      size: 15,
                      color: Color(0xFF9AE6B4),
                    ),
                    SizedBox(width: 6),
                    Text(
                      "Administrator",
                      style: TextStyle(
                        color: Color(0xFF9AE6B4),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.14),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              PhosphorIconsBold.usersThree,
              color: Color(0xFF0E5ACF),
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color iconBg;
  final IconData? trailingIcon;
  final bool trailingDot;
  final Color trailingColor;

  const StatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.iconBg,
    this.trailingIcon,
    this.trailingDot = false,
    required this.trailingColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const Spacer(),
              trailingDot
                  ? Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: trailingColor,
                        shape: BoxShape.circle,
                      ),
                    )
                  : Icon(
                      trailingIcon,
                      size: 20,
                      color: trailingColor,
                    ),
            ],
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13.5,
              color: Color(0xFF4B5563),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }
}

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