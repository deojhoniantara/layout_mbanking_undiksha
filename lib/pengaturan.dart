import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color.fromARGB(255, 0, 21, 105);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: primaryColor,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: primaryColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView(
            children: [
              _buildSettingItem(
                icon: Icons.lock,
                label: 'Ganti PIN',
                onTap: () {
                  // Arahkan ke halaman Ganti PIN
                },
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.notifications,
                label: 'Notifikasi',
                onTap: () {
                  // Arahkan ke halaman Notifikasi
                },
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.language,
                label: 'Bahasa',
                onTap: () {
                  // Arahkan ke halaman pilihan bahasa
                },
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.security,
                label: 'Keamanan',
                onTap: () {
                  // Arahkan ke halaman keamanan
                },
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.info,
                label: 'Tentang Aplikasi',
                onTap: () {
                  // Arahkan ke halaman info aplikasi
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color iconColor = const Color.fromARGB(255, 0, 21, 105),
    Color textColor = Colors.black,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1);
  }
}
