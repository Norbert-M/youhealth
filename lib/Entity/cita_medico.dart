import 'package:cloud_firestore/cloud_firestore.dart';

class Cita {
  final String idUsuario;
  final String tipoCita;
  final String nombreHospital;
  final DateTime fechaHoraCita;
  final String direccionHospital;
  final double? latitudHospital;
  final double? longitudHospital;

  Cita({
    required this.idUsuario,
    required this.tipoCita,
    required this.nombreHospital,
    required this.fechaHoraCita,
    required this.direccionHospital,
    this.latitudHospital,
    this.longitudHospital,
  });

  // Convertir la cita a un mapa para guardar en Firestore
  Map<String, dynamic> toJson() {
    return {
      'idUsuario': idUsuario,
      'tipoCita': tipoCita,
      'nombreHospital': nombreHospital,
      'fechaHoraCita': fechaHoraCita,
      'direccionHospital': direccionHospital,
      'latitudHospital': latitudHospital,
      'longitudHospital': longitudHospital,
    };
  }

  // Crear una cita a partir de un mapa
  factory Cita.fromJson(Map<String, dynamic> json) {
    return Cita(
      idUsuario: json['idUsuario'],
      tipoCita: json['tipoCita'],
      nombreHospital: json['nombreHospital'],
      fechaHoraCita: (json['fechaHoraCita'] as Timestamp).toDate(),
      direccionHospital: json['direccionHospital'],
      latitudHospital: json['latitudHospital'],
      longitudHospital: json['longitudHospital'],
    );
  }
}