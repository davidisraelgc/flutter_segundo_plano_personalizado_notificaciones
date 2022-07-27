import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfiguracionProvider extends ChangeNotifier {
  bool obtenerAsignacionesAutomaticamente = false;
  bool sincronizarAutomaticamente = false;
  String spLlaveObtieneAsignAuto = 'obtieneasignauto';
  String spLlaveSincronizaAuto = 'sincronizaauto';

  inicializa() async {
    obtenerAsignacionesAutomaticamente =
        await _obtieneValorBoolPorLlave(spLlaveObtieneAsignAuto) ?? false;
    sincronizarAutomaticamente =
        await _obtieneValorBoolPorLlave(spLlaveSincronizaAuto) ?? false;
    notifyListeners();
  }

  clickObtenerAsignacionesAutomaticamente(bool value) {
    obtenerAsignacionesAutomaticamente = value;
    _guardaValorBoolPorLlave(spLlaveObtieneAsignAuto, value);
    if (value) {
      if (Platform.isAndroid) {
        Workmanager().registerPeriodicTask(
            "tagobtieneasignacionesauto", "Obteniendo asignaciones...",
            tag: "tagobtieneasignacionesauto",
            frequency: const Duration(minutes: 15),
            constraints: Constraints(
                networkType: NetworkType.connected,
                requiresBatteryNotLow: true),
            initialDelay: const Duration(minutes: 15));
      } else {
        Workmanager().registerOneOffTask(
            "tagobtieneasignacionesauto", "Obteniendo asignaciones...",
            tag: "tagobtieneasignacionesauto",
            constraints: Constraints(
                networkType: NetworkType.connected,
                requiresBatteryNotLow: true),
            initialDelay: const Duration(minutes: 15));
      }
    } else {
      Workmanager().cancelByTag("tagobtieneasignacionesauto");
    }
    notifyListeners();
  }

  clickSincronizarAutomaticamente(bool value) {
    sincronizarAutomaticamente = value;
    _guardaValorBoolPorLlave(spLlaveSincronizaAuto, value);
    if (value) {
      if (Platform.isAndroid) {
        Workmanager().registerPeriodicTask(
            "SincVisitasTerminadas", "Sincronizando visitas terminadas...",
            tag: "tagsincronizavisitasterminadas",
            frequency: const Duration(minutes: 15),
            constraints: Constraints(
                networkType: NetworkType.connected,
                requiresBatteryNotLow: true),
            initialDelay: const Duration(minutes: 15));
      } else {
        Workmanager().registerOneOffTask(
            "SincVisitasTerminadas", "Sincronizando visitas terminadas...",
            tag: "tagsincronizavisitasterminadas",
            constraints: Constraints(
                networkType: NetworkType.connected,
                requiresBatteryNotLow: true),
            initialDelay: const Duration(minutes: 15));
      }
    } else {
      Workmanager().cancelByTag("tagsincronizavisitasterminadas");
    }
    notifyListeners();
  }

  _guardaValorBoolPorLlave(String llave, bool val) async {
    final dataConf = await SharedPreferences.getInstance();
    dataConf.setBool(llave, val);
  }

  Future<bool?> _obtieneValorBoolPorLlave(String llave) async {
    final dataConf = await SharedPreferences.getInstance();
    final valor = dataConf.getBool(llave);
    return valor;
  }
}
