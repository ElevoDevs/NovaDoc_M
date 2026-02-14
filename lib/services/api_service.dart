import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/invoice.dart';
import 'auth_service.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080/api';

  static Future<Map<String, String>> _getHeaders() async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<Invoice> createSchoolInvoice({
    required String schoolName,
    required String studentName,
    required double amount,
    required String monitorName,
    int? studentId,
  }) async {
    final user = await AuthService.getUser();
    final response = await http.post(
      Uri.parse('$baseUrl/invoices/school'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'userId': user?['id'],
        'schoolName': schoolName,
        'studentName': studentName,
        'amount': amount,
        'monitorName': monitorName,
        if (studentId != null) 'studentId': studentId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Invoice.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear factura: ${response.body}');
    }
  }

  static Future<Invoice> createCompanyInvoice({
    required String companyName,
    required String companyNit,
    String? companyAddress,
    String? companyPhone,
    String? companyEmail,
    required String concept,
    required double subtotal,
    required double tax,
    required double total,
    required String generatedBy,
  }) async {
    final user = await AuthService.getUser();
    final response = await http.post(
      Uri.parse('$baseUrl/invoices/company'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'userId': user?['id'],
        'companyName': companyName,
        'companyNit': companyNit,
        'companyAddress': companyAddress,
        'companyPhone': companyPhone,
        'companyEmail': companyEmail,
        'concept': concept,
        'subtotal': subtotal,
        'tax': tax,
        'total': total,
        'generatedBy': generatedBy,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Invoice.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear factura: ${response.body}');
    }
  }

  static Future<List<Invoice>> getInvoices() async {
    final response = await http.get(
      Uri.parse('$baseUrl/invoices'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return data.map((json) => Invoice.fromJson(json)).toList();
      }
      return [];
    } else {
      return [];
    }
  }

  static Future<Map<String, dynamic>> getDashboardStats() async {
    final response = await http.get(
      Uri.parse('$baseUrl/dashboard/stats'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener estadísticas');
    }
  }

  static Future<Map<String, dynamic>> getPdfCounter() async {
    final user = await AuthService.getUser();
    final userId = user?['id'];
    final response = await http.get(
      Uri.parse(userId != null
          ? '$baseUrl/invoices/pdf-counter/$userId'
          : '$baseUrl/invoices/pdf-counter'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {
        'totalGenerated': 0,
        'limitAllowed': 400,
        'remaining': 400,
        'canGenerate': true
      };
    }
  }

  static Future<String> getInvoicePdfUrl(int invoiceId) async {
    return '$baseUrl/invoices/$invoiceId/pdf';
  }

  static Future<void> downloadInvoicePdf(int invoiceId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/invoices/$invoiceId/pdf'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al descargar PDF');
    }
  }
}
