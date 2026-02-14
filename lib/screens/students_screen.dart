import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/student_service.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  List<Student> _students = [];
  final _nameController = TextEditingController();
  final _schoolController = TextEditingController();
  bool _isLoading = true;
  final Set<int> _selectedStudents = {};

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    try {
      final students = await StudentService.getStudents();
      setState(() {
        _students = students;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _addStudent() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar Estudiante'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _schoolController,
              decoration: const InputDecoration(labelText: 'Colegio', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              if (_nameController.text.isNotEmpty && _schoolController.text.isNotEmpty) {
                try {
                  final student = await StudentService.createStudent(
                    Student(name: _nameController.text, school: _schoolController.text),
                  );
                  setState(() {
                    _students.add(student);
                    _nameController.clear();
                    _schoolController.clear();
                  });
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteSelectedStudents() async {
    try {
      for (final index in _selectedStudents) {
        final student = _students[index];
        if (student.id != null) {
          await StudentService.deleteStudent(student.id!);
        }
      }
      await _loadStudents();
      setState(() => _selectedStudents.clear());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Estudiantes eliminados')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _togglePayment(int index, String month) {
    setState(() {
      _students[index].payments[month] = !(_students[index].payments[month] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedStudents.isEmpty ? 'Estudiantes' : '${_selectedStudents.length} seleccionados'),
        backgroundColor: Colors.purple[700],
        foregroundColor: Colors.white,
        actions: [
          if (_selectedStudents.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Eliminar estudiantes'),
                    content: Text('¿Eliminar ${_selectedStudents.length} estudiante(s)?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _deleteSelectedStudents();
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('Eliminar'),
                      ),
                    ],
                  ),
                );
              },
            ),
          IconButton(icon: const Icon(Icons.add), onPressed: _addStudent),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              try {
                for (final student in _students) {
                  if (student.id != null) {
                    for (final entry in student.payments.entries) {
                      if (entry.value) {
                        await StudentService.markPayment(student.id!, entry.key, DateTime.now().year);
                      }
                    }
                  }
                }
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pagos guardados exitosamente')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _students.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text('No hay estudiantes', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar Estudiante'),
                    onPressed: _addStudent,
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columns: [
                    const DataColumn(label: Text('Estudiante', style: TextStyle(fontWeight: FontWeight.bold))),
                    const DataColumn(label: Text('Colegio', style: TextStyle(fontWeight: FontWeight.bold))),
                    ...['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic']
                        .map((m) => DataColumn(label: Text(m, style: const TextStyle(fontWeight: FontWeight.bold)))),
                  ],
                  rows: _students.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final student = entry.value;
                    final months = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
                    return DataRow(
                      selected: _selectedStudents.contains(idx),
                      onSelectChanged: (selected) {
                        setState(() {
                          if (selected == true) {
                            _selectedStudents.add(idx);
                          } else {
                            _selectedStudents.remove(idx);
                          }
                        });
                      },
                      cells: [
                        DataCell(Text(student.name)),
                        DataCell(Text(student.school)),
                        ...months.map((month) => DataCell(
                          Checkbox(
                            value: student.payments[month] ?? false,
                            onChanged: (val) => _togglePayment(idx, month),
                          ),
                        )),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addStudent,
        backgroundColor: Colors.purple[700],
        child: const Icon(Icons.add),
      ),
    );
  }
}
