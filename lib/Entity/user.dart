class User {
  final String id;
  final String correo;
  final String nombre;
  final String apellido;
  final String contrasena;
  final String fechaNacimiento;
  final String estatura;
  final String peso;

  User({
    required this.id,
    required this.correo,
    required this.nombre,
    required this.apellido,
    required this.contrasena,
    required this.fechaNacimiento,
    required this.estatura,
    required this.peso,
  });


  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      correo: json['correo'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      contrasena: json['contrasena'],
      fechaNacimiento: json['fechaNacimiento'],
      estatura: json['estatura'],
      peso: json['peso'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'correo': correo,
      'nombre': nombre,
      'apellido': apellido,
      'contrasena': contrasena,
      'fechaNacimiento': fechaNacimiento,
      'estatura': estatura,
      'peso': peso,
    };
  }

  @override
  String toString() {
    return 'User{nombre: $nombre, apellido: $apellido}';
  }
}