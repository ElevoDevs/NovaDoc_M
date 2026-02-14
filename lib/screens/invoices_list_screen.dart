import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/invoice.dart';
import 'invoice_detail_screen.dart';

class InvoicesListScreen extends StatefulWidget {
  const InvoicesListScreen({super.key});

  @override
  State<InvoicesListScreen> createState() => _InvoicesListScreenState();
}

class _InvoicesListScreenState extends State<InvoicesListScreen> {
  String _searchQuery = '';
  List<Invoice> _invoices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInvoices();
  }

  Future<void> _loadInvoices() async {
    try {
      final invoices = await ApiService.getInvoices();
      setState(() {
        _invoices = invoices;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Facturas'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadInvoices),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar facturas...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (value) => setState(() => _searchQuery = value),
                  ),
                ),
                Expanded(
                  child: _invoices.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text('No hay facturas', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadInvoices,
                          child: ListView.builder(
                            itemCount: _invoices
                                .where((inv) => inv.schoolName.toLowerCase().contains(_searchQuery.toLowerCase()))
                                .length,
                            itemBuilder: (context, index) {
                              final filteredInvoices = _invoices
                                  .where((inv) => inv.schoolName.toLowerCase().contains(_searchQuery.toLowerCase()))
                                  .toList();
                              final invoice = filteredInvoices[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue[700],
                                    child: const Icon(Icons.receipt, color: Colors.white),
                                  ),
                                  title: Text(invoice.schoolName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  subtitle: Text(
                                      '\$${invoice.price.toStringAsFixed(0)} - ${invoice.createdAt != null ? '${invoice.createdAt!.day}/${invoice.createdAt!.month}/${invoice.createdAt!.year}' : ''}'),
                                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => InvoiceDetailScreen(invoice: invoice),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}
