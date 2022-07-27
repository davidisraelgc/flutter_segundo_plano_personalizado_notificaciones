import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:segundo_plano_personalizado/notifications/notificaciones.dart';
import 'package:segundo_plano_personalizado/ui/configuracion/provider/configuracion_provider.dart';

class ConfiguracionScreen extends StatelessWidget {
  const ConfiguracionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<ConfiguracionProvider>(context).inicializa();
    Future.delayed(const Duration(seconds: 2));
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: const Color.fromARGB(255, 10, 120, 14),
        title: const Text(
          'Configuración',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
              margin: const EdgeInsets.all(3),
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 5),
                            child: Row(
                              children: <Widget>[
                                Consumer<ConfiguracionProvider>(
                                    builder: (context, cProvider, _) {
                                  return Switch(
                                    onChanged: (value) {
                                      cProvider
                                          .clickObtenerAsignacionesAutomaticamente(
                                              value);
                                    },
                                    value: cProvider
                                        .obtenerAsignacionesAutomaticamente,
                                    activeColor: Colors.green,
                                  );
                                }),
                                const SizedBox(
                                    width: 240,
                                    child: Text(
                                      'Obtener asignaciones automáticamente cada 15 minutos',
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      softWrap: true,
                                      style: TextStyle(fontSize: 13),
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 5),
                            child: Row(
                              children: <Widget>[
                                Consumer<ConfiguracionProvider>(
                                    builder: (context, cProvider, _) {
                                  return Switch(
                                    onChanged: (value) {
                                      cProvider.clickSincronizarAutomaticamente(
                                          value);
                                    },
                                    value: cProvider.sincronizarAutomaticamente,
                                    activeColor: Colors.green,
                                  );
                                }),
                                const SizedBox(
                                    width: 240,
                                    child: Text(
                                      'Sincronizar visitas terminadas automaticamente cuando esté conectado a wifi cada 15 minutos',
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      softWrap: true,
                                      style: TextStyle(fontSize: 13),
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              minimumSize: const Size(70, 22)
                            ),
                            onPressed: () {
                              Notificaciones().mostrar('AgroGeo Despachos', "Notificación personalizada");
                            },
                            child: const Text(
                                'Mostrar notificación',
                                style: TextStyle(fontSize: 12))),
                      ),
                    ]),
              )),
        ],
      ),
    );
  }
}
