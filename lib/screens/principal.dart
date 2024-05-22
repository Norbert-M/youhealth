import 'package:flutter/material.dart';
import 'package:youhealth/Widgets/top_bar_widget.dart';

class Treatment {
  final String name;
  final String time;

  Treatment({required this.name, required this.time});
}

class TreatmentListPage extends StatefulWidget {
  @override
  _TreatmentListPageState createState() => _TreatmentListPageState();
}

class _TreatmentListPageState extends State<TreatmentListPage> {
  late Future<List<Treatment>> futureTreatments;

  Future<List<Treatment>> getTreatments() async {
    // Aquí debes implementar la lógica para obtener los tratamientos del usuario actual
    // Por ahora, devolveré una lista de tratamientos de ejemplo
    return [
      Treatment(name: 'Tratamiento 1', time: '08:00'),
      Treatment(name: 'Tratamiento 2', time: '12:00'),
      Treatment(name: 'Tratamiento 3', time: '16:00'),
      Treatment(name: 'Tratamiento 4', time: '20:00'),
    ];
  }

  @override
  void initState() {
    super.initState();
    futureTreatments = getTreatments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Treatment>>(
        future: futureTreatments,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].name),
                  subtitle: Text(snapshot.data![index].time),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}