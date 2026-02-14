import 'package:flutter/material.dart';
import '../services/api_service.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          FutureBuilder<Map<String, dynamic>>(
            future: ApiService.getPdfCounter(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'PDFs: ${data['totalGenerated']}/${data['limitAllowed']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(child: _StatCard(title: 'Hoy', value: '\$0', icon: Icons.today, color: Colors.green)),
              const SizedBox(width: 12),
              Expanded(child: _StatCard(title: 'Mes', value: '\$0', icon: Icons.calendar_month, color: Colors.blue)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _StatCard(title: 'Total', value: '0', icon: Icons.receipt, color: Colors.orange)),
              const SizedBox(width: 12),
              Expanded(child: _StatCard(title: 'Colegios', value: '0', icon: Icons.school, color: Colors.purple)),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Facturas Recientes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _EmptyState(),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            Text(title, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('No hay facturas aún', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
            const SizedBox(height: 8),
            Text('Crea tu primera factura', style: TextStyle(color: Colors.grey[500])),
          ],
        ),
      ),
    );
  }
}
