import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: AuthService.getUser(),
        builder: (context, snapshot) {
          final user = snapshot.data;
          return ListView(
            children: [
              const SizedBox(height: 16),
              const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
              const SizedBox(height: 16),
              Text(user?['name'] ?? 'Usuario', textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(user?['email'] ?? '', textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 24),
              _SettingTile(icon: Icons.dark_mode, title: 'Modo Oscuro', trailing: Switch(value: _darkMode, onChanged: (v) => setState(() => _darkMode = v))),
              _SettingTile(icon: Icons.notifications, title: 'Notificaciones', trailing: Switch(value: _notifications, onChanged: (v) => setState(() => _notifications = v))),
              _SettingTile(icon: Icons.business, title: 'Gestionar Colegios', onTap: () {}),
              _SettingTile(icon: Icons.palette, title: 'Plantillas', onTap: () {}),
              _SettingTile(icon: Icons.backup, title: 'Respaldo y Sincronización', onTap: () {}),
              _SettingTile(icon: Icons.help, title: 'Ayuda y Soporte', onTap: () {}),
              _SettingTile(icon: Icons.info, title: 'Acerca de', onTap: () {}),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
                  onPressed: () async {
                    await AuthService.logout();
                    if (mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingTile({required this.icon, required this.title, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue[700]),
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
