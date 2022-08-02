import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:segundo_plano_personalizado/notifications/notificaciones.dart';
import 'package:segundo_plano_personalizado/ui/configuracion/configuracion_screen.dart';
import 'package:segundo_plano_personalizado/ui/configuracion/provider/configuracion_provider.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    Notificaciones().mostrar('AgroGeo Despachos', task);
    if (Platform.isIOS) {
      Workmanager().registerOneOffTask(
          task, "Sincronizando visitas terminadas...",
          tag: task,
          constraints: Constraints(
              networkType: NetworkType.not_required,
              requiresBatteryNotLow: false,
              requiresCharging: false),
          initialDelay: const Duration(minutes: 15));
    }
    return Future.value(true);
  });
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Notificaciones.init();
    Workmanager().initialize(
        callbackDispatcher, // The top level function, aka callbackDispatcher
        isInDebugMode:
            false // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
        );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ConfiguracionProvider>(
            create: (_) => ConfiguracionProvider()),
      ],
      child: const MaterialApp(
          home: ConfiguracionScreen(), debugShowCheckedModeBanner: false),
    );
  }
}
