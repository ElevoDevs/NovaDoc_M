import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';

class CompanyInvoiceScreen extends StatefulWidget {
  const CompanyInvoiceScreen({super.key});

  @override
  State<CompanyInvoiceScreen> createState() => _CompanyInvoiceScreenState();
}

class _CompanyInvoiceScreenState extends State<CompanyInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyController = TextEditingController();
  final _nitController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _amountController = TextEditingController();
  final _conceptController = TextEditingController();
  final _generatedByController = TextEditingController();

  @override
  void dispose() {
    _companyController.dispose();
    _nitController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _amountController.dispose();
    _conceptController.dispose();
    _generatedByController.dispose();
    super.dispose();
  }

  Future<void> _generateInvoice() async {
    if (_formKey.currentState!.validate()) {
      try {
        final subtotal = double.parse(_amountController.text);
        final tax = subtotal * 0.19;
        final total = subtotal + tax;

        await ApiService.createCompanyInvoice(
          companyName: _companyController.text,
          companyNit: _nitController.text,
          companyAddress:
              _addressController.text.isEmpty ? null : _addressController.text,
          companyPhone:
              _phoneController.text.isEmpty ? null : _phoneController.text,
          companyEmail:
              _emailController.text.isEmpty ? null : _emailController.text,
          concept: _conceptController.text,
          subtotal: subtotal,
          tax: tax,
          total: total,
          generatedBy: _generatedByController.text,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Factura electrónica generada')),
          );
          _formKey.currentState!.reset();
          _companyController.clear();
          _nitController.clear();
          _addressController.clear();
          _phoneController.clear();
          _emailController.clear();
          _amountController.clear();
          _conceptController.clear();
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
        title: const Text('Facturación Empresas'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _companyController,
              decoration: const InputDecoration(
                labelText: 'Nombre de la Empresa *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.business),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nitController,
              decoration: const InputDecoration(
                labelText: 'NIT *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
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
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Teléfono',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Valor Total *',
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
              controller: _conceptController,
              decoration: const InputDecoration(
                labelText: 'Concepto *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
              validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _generatedByController,
              decoration: const InputDecoration(
                labelText: 'Generado por *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.receipt_long),
              label: const Text('Generar Factura Electrónica'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _generateInvoice();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
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
