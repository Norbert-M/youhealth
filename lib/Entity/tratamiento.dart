class Tratamiento {
  final String idTratamiento;
  final String idMedicamento;
  final String idUser;
  final String dosis;
  final int frecuenciaHoras;
  final DateTime fechaInicio;
  final DateTime fechaFin;

  Tratamiento({
    required this.idTratamiento,
    required this.idMedicamento,
    required this.idUser,
    required this.dosis,
    required this.frecuenciaHoras,
    required this.fechaInicio,
    required this.fechaFin,
  });

  factory Tratamiento.fromJson(Map<String, dynamic> json) {
    return Tratamiento(
      idTratamiento: json['idTratamiento'],
      idMedicamento: json['idMedicamento'],
      idUser: json['idUser'],
      dosis: json['dosis'],
      frecuenciaHoras: json['frecuenciaHoras'],
      fechaInicio: DateTime.parse(json['fechaInicio']),
      fechaFin: DateTime.parse(json['fechaFin']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idTratamiento': idTratamiento,
      'idMedicamento': idMedicamento,
      'idUser': idUser,
      'dosis': dosis,
      'frecuenciaHoras': frecuenciaHoras,
      'fechaInicio': fechaInicio.toIso8601String(),
      'fechaFin': fechaFin.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Tratamiento{ idMedicamento: $idMedicamento}';
  }
}