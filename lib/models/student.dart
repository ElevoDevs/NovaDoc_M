class Student {
  final int? id;
  final String name;
  final String school;
  final Map<String, bool> payments;

  Student({
    this.id,
    required this.name,
    required this.school,
    Map<String, bool>? payments,
  }) : payments = payments ?? {
    'Enero': false, 'Febrero': false, 'Marzo': false, 'Abril': false,
    'Mayo': false, 'Junio': false, 'Julio': false, 'Agosto': false,
    'Septiembre': false, 'Octubre': false, 'Noviembre': false, 'Diciembre': false,
  };

  Map<String, dynamic> toJson() => {
    'name': name,
    'school': school,
    'payments': payments,
  };

  factory Student.fromJson(Map<String, dynamic> json) => Student(
    id: json['id'],
    name: json['name'] ?? '',
    school: json['schoolName'] ?? json['school'] ?? '',
    payments: json['payments'] != null ? Map<String, bool>.from(json['payments']) : null,
  );
}
