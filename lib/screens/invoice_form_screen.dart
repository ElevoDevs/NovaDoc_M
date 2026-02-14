import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/invoice.dart';
import '../services/api_service.dart';

class InvoiceFormScreen extends StatefulWidget {
  const InvoiceFormScreen({super.key});

  @override
  State<InvoiceFormScreen> createState() => _InvoiceFormScreenState();
}

class _InvoiceFormScreenState extends State<InvoiceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _schoolNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _nitController = TextEditingController();
  final _addressController = TextEditingController();
  final _conceptController = TextEditingController();
  final _generatedByController = TextEditingController();
  final _observationsController = TextEditingController();

  @override
  void dispose() {
    _schoolNameController.dispose();
    _priceController.dispose();
    _nitController.dispose();
    _addressController.dispose();
    _conceptController.dispose();
    _generatedByController.dispose();
    _observationsController.dispose();
    super.dispose();
  }

  void _generateInvoice() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ApiService.createCompanyInvoice(
          companyName: _schoolNameController.text,
          companyNit: _nitController.text.isEmpty ? 'N/A' : _nitController.text,
          companyAddress: _addressController.text.isEmpty ? null : _addressController.text,
          companyPhone: null,
          companyEmail: null,
          concept: _conceptController.text.isEmpty ? 'Factura' : _conceptController.text,
          subtotal: double.parse(_priceController.text),
          tax: double.parse(_priceController.text) * 0.19,
          total: double.parse(_priceController.text) * 1.19,
          generatedBy: _generatedByController.text,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Factura generada exitosamente')),
          );
          _formKey.currentState!.reset();
          _schoolNameController.clear();
          _priceController.clear();
          _nitController.clear();
          _addressController.clear();
          _conceptController.clear();
          _observationsController.clear();
          _generatedByController.clear();
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
        title: const Text('Nueva Factura Electrónica'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Facturación Colegios - Ibagué',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _schoolNameController,
              decoration: const InputDecoration(
                labelText: 'Nombre del Colegio *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.school),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo es requerido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Precio *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
                prefixText: '\$ ',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo es requerido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nitController,
              decoration: const InputDecoration(
                labelText: 'NIT',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Dirección',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _conceptController,
              decoration: const InputDecoration(
                labelText: 'Concepto',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _observationsController,
              decoration: const InputDecoration(
                labelText: 'Observaciones',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _generatedByController,
              decoration: const InputDecoration(
                labelText: 'Generado por (Nombre/Firma) *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo es requerido';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.check_circle),
              label: const Text('Generar Factura'),
              onPressed: _generateInvoice,
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
