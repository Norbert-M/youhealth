class Medicamento {
  final String idMedicamento;
  final String nombre;
  final int cantidadStock;
  final String dosis;

  Medicamento({
    required this.idMedicamento,
    required this.nombre,
    required this.cantidadStock,
    required this.dosis,
  });

  factory Medicamento.fromJson(Map<String, dynamic> json) {
    return Medicamento(
      idMedicamento: json['idMedicamento'],
      nombre: json['nombre'],
      cantidadStock: json['cantidadStock'],
      dosis: json['dosis'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idMedicamento': idMedicamento,
      'nombre': nombre,
      'cantidadStock': cantidadStock,
      'dosis': dosis,
    };
  }

  @override
  String toString() {
    return 'Medicamento{nombre: $nombre, dosis: $dosis}';
  }
}
