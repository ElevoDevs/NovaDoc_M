class Invoice {
  final int? id;
  final String schoolName;
  final double price;
  final String? nit;
  final String? address;
  final String? concept;
  final String? observations;
  final String generatedBy;
  final String? studentName;
  final DateTime? createdAt;

  Invoice({
    this.id,
    required this.schoolName,
    required this.price,
    this.nit,
    this.address,
    this.concept,
    this.observations,
    required this.generatedBy,
    this.studentName,
    this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'schoolName': schoolName,
    'price': price,
    'nit': nit,
    'address': address,
    'concept': concept,
    'observations': observations,
    'generatedBy': generatedBy,
  };

  factory Invoice.fromJson(Map<String, dynamic> json) {
    double parsePrice(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return Invoice(
      id: json['id'],
      schoolName: json['schoolName'] ?? json['companyName'] ?? '',
      price: parsePrice(json['amount'] ?? json['price'] ?? json['total']),
      nit: json['nit'] ?? json['companyNit'],
      address: json['address'] ?? json['companyAddress'],
      concept: json['concept'],
      observations: json['observations'],
      generatedBy: json['generatedBy'] ?? json['monitorName'] ?? '',
      studentName: json['studentName'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
}
