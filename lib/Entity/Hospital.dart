class Hospital {
  final String nombre;
  final String direccion;
  final double latitud;
  final double longitud;

  Hospital({
    required this.nombre,
    required this.direccion,
    required this.latitud,
    required this.longitud,
  });

  // Método fromJson
  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      nombre: json['nombre'],
      direccion: json['direccion'],
      latitud: json['latitud'],
      longitud: json['longitud'],
    );
  }

  // Método toJson
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'direccion': direccion,
      'latitud': latitud,
      'longitud': longitud,
    };
  }
}