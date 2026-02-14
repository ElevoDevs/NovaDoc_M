import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';

class SchoolInvoiceScreen extends StatefulWidget {
  const SchoolInvoiceScreen({super.key});

  @override
  State<SchoolInvoiceScreen> createState() => _SchoolInvoiceScreenState();
}

class _SchoolInvoiceScreenState extends State<SchoolInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _schoolController = TextEditingController();
  final _amountController = TextEditingController();
  final _studentController = TextEditingController();
  final _monitorController = TextEditingController();

  @override
  void dispose() {
    _schoolController.dispose();
    _amountController.dispose();
    _studentController.dispose();
    _monitorController.dispose();
    super.dispose();
  }

  Future<void> _generateInvoice() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ApiService.createSchoolInvoice(
          schoolName: _schoolController.text,
          amount: double.parse(_amountController.text),
          studentName: _studentController.text,
          monitorName: _monitorController.text,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Factura generada exitosamente')),
          );
          _formKey.currentState!.reset();
          _schoolController.clear();
          _amountController.clear();
          _studentController.clear();
          _monitorController.clear();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Facturación Colegios'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _schoolController,
              decoration: const InputDecoration(
                labelText: 'Nombre del Colegio *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.school),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Valor a Pagar *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
                prefixText: '\$ ',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _studentController,
              decoration: const InputDecoration(
                labelText: 'Nombre del Estudiante *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _monitorController,
              decoration: const InputDecoration(
                labelText: 'Nombre del Monitor *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.receipt),
              label: const Text('Generar Factura'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _generateInvoice();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
