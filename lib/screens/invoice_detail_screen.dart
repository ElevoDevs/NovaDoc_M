import 'package:flutter/material.dart';
import '../models/invoice.dart';
import '../services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class InvoiceDetailScreen extends StatefulWidget {
  final Invoice invoice;

  const InvoiceDetailScreen({super.key, required this.invoice});

  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  Future<void> _downloadPdf() async {
    try {
      final url = 'http://10.0.2.2:8080/api/invoices/${widget.invoice.id}/pdf';
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'No se puede abrir el PDF';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _sharePdf() async {
    try {
      final url = 'http://10.0.2.2:8080/api/invoices/${widget.invoice.id}/pdf';
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'No se puede compartir el PDF';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Factura'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.share), onPressed: _sharePdf),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.receipt_long, size: 40, color: Colors.blue[700]),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Factura #${widget.invoice.id}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              Text(
                                widget.invoice.createdAt != null
                                    ? '${widget.invoice.createdAt!.day}/${widget.invoice.createdAt!.month}/${widget.invoice.createdAt!.year}'
                                    : '',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    _DetailRow(icon: Icons.business, label: 'Cliente', value: widget.invoice.schoolName),
                    if (widget.invoice.studentName != null && widget.invoice.studentName!.isNotEmpty)
                      _DetailRow(icon: Icons.person, label: 'Estudiante', value: widget.invoice.studentName!),
                    if (widget.invoice.nit != null) _DetailRow(icon: Icons.badge, label: 'NIT', value: widget.invoice.nit!),
                    if (widget.invoice.address != null) _DetailRow(icon: Icons.location_on, label: 'Dirección', value: widget.invoice.address!),
                    if (widget.invoice.concept != null) _DetailRow(icon: Icons.description, label: 'Concepto', value: widget.invoice.concept!),
                    const Divider(height: 32),
                    _DetailRow(
                      icon: Icons.attach_money,
                      label: 'Total',
                      value: '\$${widget.invoice.price.toStringAsFixed(0)}',
                      isTotal: true,
                    ),
                    if (widget.invoice.generatedBy.isNotEmpty)
                      _DetailRow(icon: Icons.person, label: 'Generado por', value: widget.invoice.generatedBy),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text('Descargar PDF'),
                onPressed: _downloadPdf,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.email),
                label: const Text('Enviar por Email'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Función próximamente')),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isTotal;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: isTotal ? Colors.green[700] : Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isTotal ? 24 : 16,
                    fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                    color: isTotal ? Colors.green[700] : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
