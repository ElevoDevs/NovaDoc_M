import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student.dart';
import 'auth_service.dart';

class StudentService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/students';

  static Future<Map<String, String>> _getHeaders() async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<List<Student>> getStudents() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Student.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener estudiantes');
    }
  }

  static Future<Student> createStudent(Student student) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: await _getHeaders(),
      body: jsonEncode({
        'name': student.name,
        'schoolName': student.school,
        'grade': '',
        'parentName': '',
        'parentPhone': '',
        'parentEmail': '',
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Student.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear estudiante: ${response.body}');
    }
  }

  static Future<void> markPayment(int studentId, String month, int year) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$studentId/payment'),
      headers: await _getHeaders(),
      body: jsonEncode({'month': month, 'year': year}),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al marcar pago');
    }
  }

  static Future<Map<String, dynamic>> getMonthlyPayments(
      int studentId, int year, int month) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$studentId/payments/month?year=$year&month=$month'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener pagos');
    }
  }

  static Future<void> deleteStudent(int studentId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$studentId'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar estudiante');
    }
  }
}
