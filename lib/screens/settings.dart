import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notifications = false;
  bool darkMode = false;
  bool biometricLock = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),

      body: SafeArea(
        child: Column(
          children: [
            const SettingsHeader(),

            const SizedBox(height: 15),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //  GENERAL
                    SettingsSection(
                      title: "General",
                      icon: Icons.tune,
                      children: [
                        SettingsSwitchTile(
                          icon: Icons.notifications_outlined,
                          title: "Push Notifications",
                          subtitle: "Receive alerts and updates",
                          value: notifications,
                          onChanged: (val) {
                            setState(() => notifications = val);
                          },
                        ),

                        SettingsSwitchTile(
                          icon: Icons.dark_mode_outlined,
                          title: "Dark Mode",
                          subtitle: "Enable dark theme",
                          value: darkMode,
                          onChanged: (val) {
                            setState(() => darkMode = val);
                          },
                        ),

                        const SettingsListTile(
                          icon: Icons.language,
                          title: "Language",
                          subtitle: "English / العربية",
                          trailing: Text("English"),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    // SECURITY
                    SettingsSection(
                      title: "Security & Privacy",
                      icon: Icons.security,
                      children: [
                        SettingsSwitchTile(
                          icon: Icons.fingerprint,
                          title: "Biometric Lock",
                          subtitle: "Lock app with fingerprint",
                          value: biometricLock,
                          onChanged: (val) {
                            setState(() => biometricLock = val);
                          },
                        ),

                        const SettingsListTile(
                          icon: Icons.lock,
                          title: "Change Password",
                          subtitle: "Update your password",
                          trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    SettingsSection(
                      title: "Support & Information",
                      icon: Icons.info,
                      children: const [
                        SettingsListTile(
                          icon: Icons.help,
                          title: "Help Center",
                          subtitle: "Get support",
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//  HEADER

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
            backgroundColor: Colors.white24,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Settings",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// SECTION

class SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          ...children,
        ],
      ),
    );
  }
}

//  SWITCH TILE

class SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final Function(bool) onChanged;

  const SettingsSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        //active*
        activeColor: const Color.fromARGB(255, 243, 250, 255),
        activeTrackColor: Colors.blue,

        //inactive*
        inactiveThumbColor: Colors.white,
        inactiveTrackColor: const Color.fromARGB(255, 208, 212, 208),
      ),
    );
  }
}

class SettingsListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;

  const SettingsListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing,
    );
  }
}
