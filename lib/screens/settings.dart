import 'package:flutter/material.dart';

// ══════════════════════════════════════════════════════════════════════
// BREAKPOINTS HELPER
// ══════════════════════════════════════════════════════════════════════
class _Responsive {
  final double w;
  final double h;

  _Responsive(BuildContext context)
      : w = MediaQuery.of(context).size.width,
        h = MediaQuery.of(context).size.height;

  bool get isSmall  => w < 360;
  bool get isMedium => w < 480;
  bool get isLarge  => w < 768;
  bool get isTablet => w >= 768 && w < 1024;
  bool get isLargeTablet => w >= 1024;  

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

  double get contentWidth {
   if (isLargeTablet) return w * 0.65;
  if (isTablet)      return w * 0.85;  
  return double.infinity;
  }

  double get horizontalPadding {
    if (isTablet) return w * 0.04;
    if (isLarge)  return 15.0;
    return 12.0;
  }

  double get headerHeight {
    if (isSmall)  return 130.0;
    if (isMedium) return 160.0;
    if (isLarge)  return 170.0;
    return 190.0;
  }

  double get sectionRadius {
    if (isSmall)  return 14.0;
    if (isMedium) return 20.0;
    return 24.0;
  }

  double get sectionPadding {
    if (isSmall)  return 12.0;
    if (isMedium) return 15.0;
    return 20.0;
  }

  double get iconSize {
    if (isSmall)  return 20.0;
    if (isMedium) return 24.0;
    return 28.0;
  }
}

// ══════════════════════════════════════════════════════════════════════
// SETTINGS SCREEN
// ══════════════════════════════════════════════════════════════════════
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notifications = false;
  bool darkMode      = false;
  bool biometricLock = true;

  @override
  Widget build(BuildContext context) {
    final r = _Responsive(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      body: SafeArea(
        child: Column(
          children: [

            // ── Header يمتد بالكامل دايماً ──────────────────────
            SettingsHeader(r: r),

            SizedBox(height: r.dp(15)),

            // ── المحتوى محدود العرض على التابلت ─────────────────
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: r.contentWidth),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [

                        // GENERAL
                        SettingsSection(
                          r: r,
                          title: "General",
                          icon: Icons.tune,
                          children: [
                            SettingsSwitchTile(
                              r: r,
                              icon: Icons.notifications_outlined,
                              title: "Push Notifications",
                              subtitle: "Receive alerts and updates",
                              value: notifications,
                              onChanged: (val) =>
                                  setState(() => notifications = val),
                            ),
                            SettingsSwitchTile(
                              r: r,
                              icon: Icons.dark_mode_outlined,
                              title: "Dark Mode",
                              subtitle: "Enable dark theme",
                              value: darkMode,
                              onChanged: (val) =>
                                  setState(() => darkMode = val),
                            ),
                            SettingsListTile(
                              r: r,
                              icon: Icons.language,
                              title: "Language",
                              subtitle: "English / العربية",
                              trailing: Text(
                                "English",
                                style: TextStyle(fontSize: r.fs(14)),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: r.dp(15)),

                        // SECURITY
                        SettingsSection(
                          r: r,
                          title: "Security & Privacy",
                          icon: Icons.security,
                          children: [
                            SettingsSwitchTile(
                              r: r,
                              icon: Icons.fingerprint,
                              title: "Biometric Lock",
                              subtitle: "Lock app with fingerprint",
                              value: biometricLock,
                              onChanged: (val) =>
                                  setState(() => biometricLock = val),
                            ),
                            SettingsListTile(
                              r: r,
                              icon: Icons.lock,
                              title: "Change Password",
                              subtitle: "Update your password",
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: r.dp(16),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: r.dp(15)),

                        // SUPPORT
                        SettingsSection(
                          r: r,
                          title: "Support & Information",
                          icon: Icons.info,
                          children: [
                            SettingsListTile(
                              r: r,
                              icon: Icons.help,
                              title: "Help Center",
                              subtitle: "Get support",
                            ),
                          ],
                        ),

                        SizedBox(height: r.dp(30)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// HEADER
// ══════════════════════════════════════════════════════════════════════
class SettingsHeader extends StatelessWidget {
  final _Responsive r;
  const SettingsHeader({super.key, required this.r});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: r.headerHeight,
      width: double.infinity,
      padding: EdgeInsets.all(r.dp(20)),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F2027), Color(0xFF203A43)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: r.dp(20),
            backgroundColor: Colors.white24,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: r.dp(20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SizedBox(height: r.dp(20)),
          Text(
            "Settings",
            style: TextStyle(
              color: Colors.white,
              fontSize: r.fs(22),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// SECTION
// ══════════════════════════════════════════════════════════════════════
class SettingsSection extends StatelessWidget {
  final _Responsive r;
  final String title;
  final IconData icon;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.r,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: r.horizontalPadding),
      padding: EdgeInsets.all(r.sectionPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.sectionRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue, size: r.iconSize),
              SizedBox(width: r.dp(8)),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: r.fs(16),
                ),
              ),
            ],
          ),
          SizedBox(height: r.dp(10)),
          ...children,
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// SWITCH TILE
// ══════════════════════════════════════════════════════════════════════
class SettingsSwitchTile extends StatelessWidget {
  final _Responsive r;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final Function(bool) onChanged;

  const SettingsSwitchTile({
    super.key,
    required this.r,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: r.dp(4)),
      leading: Icon(icon, color: Colors.blue, size: r.iconSize),
      title: Text(
        title,
        style: TextStyle(fontSize: r.fs(14)),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: r.fs(12)),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color.fromARGB(255, 243, 250, 255),
        activeTrackColor: Colors.blue,
        inactiveThumbColor: Colors.white,
        inactiveTrackColor: const Color.fromARGB(255, 208, 212, 208),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// LIST TILE
// ══════════════════════════════════════════════════════════════════════
class SettingsListTile extends StatelessWidget {
  final _Responsive r;
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;

  const SettingsListTile({
    super.key,
    required this.r,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: r.dp(4)),
      leading: Icon(icon, color: Colors.blue, size: r.iconSize),
      title: Text(
        title,
        style: TextStyle(fontSize: r.fs(14)),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: r.fs(12)),
      ),
      trailing: trailing,
    );
  }
}