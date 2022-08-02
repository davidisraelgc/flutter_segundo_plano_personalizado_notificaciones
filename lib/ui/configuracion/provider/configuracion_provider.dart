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
            spLlaveObtieneAsignAuto, "Obteniendo asignaciones...",
            tag: spLlaveObtieneAsignAuto,
            frequency: const Duration(minutes: 15),
            constraints: Constraints(
                networkType: NetworkType.connected,
                requiresBatteryNotLow: true),
            initialDelay: const Duration(minutes: 15));
      } else {
        Workmanager().registerOneOffTask(
            spLlaveObtieneAsignAuto, "Obteniendo asignaciones...",
            tag: spLlaveObtieneAsignAuto,
            constraints: Constraints(
                networkType: NetworkType.not_required,
                requiresBatteryNotLow: false,
                requiresCharging: false),
            initialDelay: const Duration(minutes: 15));
      }
    } else {
      Workmanager().cancelByTag(spLlaveObtieneAsignAuto);
    }
    notifyListeners();
  }

  clickSincronizarAutomaticamente(bool value) {
    sincronizarAutomaticamente = value;
    _guardaValorBoolPorLlave(spLlaveSincronizaAuto, value);
    if (value) {
      if (Platform.isAndroid) {
        Workmanager().registerPeriodicTask(
            spLlaveSincronizaAuto, "Sincronizando visitas terminadas...",
            tag: spLlaveSincronizaAuto,
            frequency: const Duration(minutes: 15),
            constraints: Constraints(
                networkType: NetworkType.connected,
                requiresBatteryNotLow: true),
            initialDelay: const Duration(minutes: 15));
      } else {
        Workmanager().registerOneOffTask(
            spLlaveSincronizaAuto, "Sincronizando visitas terminadas...",
            tag: spLlaveSincronizaAuto,
            constraints: Constraints(
                networkType: NetworkType.not_required,
                requiresBatteryNotLow: false,
                requiresCharging: false),
            initialDelay: const Duration(minutes: 15));
      }
    } else {
      Workmanager().cancelByTag(spLlaveSincronizaAuto);
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
