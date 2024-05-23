import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:youhealth/Entity/cita_medico.dart';
import 'package:youhealth/assets/colors.dart';

class DetalleCitaPage extends StatelessWidget {
  final Cita cita;

  DetalleCitaPage({required this.cita});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.barColor,
        title: const Text('Detalle de la Cita',
          style: TextStyle(color: Colors.white),
        )
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Card(
                child: ListTile(
                  title: Text('Tipo de Cita'),
                  subtitle: Text('${cita.tipoCita}'),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Card(
                child: ListTile(
                  title: Text('Fecha y Hora'),
                  subtitle: Text('${cita.fechaHoraCita}'),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Card(
                child: ListTile(
                  title: Text('Dirección'),
                  subtitle: Text('${cita.direccionHospital}'),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text('Ubicación en el mapa:'),
            Container(
              height: 200, // Ajusta esto para cambiar el tamaño del mapa
              child: GoogleMap(
                mapType: MapType.hybrid,
                initialCameraPosition: CameraPosition(
                  target: LatLng(cita.latitudHospital!, cita.longitudHospital!),
                  zoom: 14.0,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('hospital'),
                    position:
                        LatLng(cita.latitudHospital!, cita.longitudHospital!),
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
