import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class PreferencesProvider extends ChangeNotifier {
   static late SharedPreferences prefs;

  // Método estático para inicializarla UNA SOLA VEZ
  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    _loadPreferences();
  }




  //------Theme Mode---------------------------
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  set themeMode(String value){
    prefs.setString("themeMode", value);

    switch(value) {
      case "Claro":
        _themeMode = ThemeMode.light;
        break;
      case "Oscuro":
        _themeMode = ThemeMode.dark;
        break;
      case "Sistema":
        _themeMode = ThemeMode.system;
        break;
    }
    
    notifyListeners();
  }



  //------Only wifi download------------------
  bool _wifiDownload = true;

  bool get wifiDownload => _wifiDownload;

  set wifiDownload(bool value){
    prefs.setBool("wifiDownload", value);
    _wifiDownload = value;
    notifyListeners();
  }

  //------Downloads simultaneos--------------
  int _simultaneousDownloads = 3;

  int get simultaneousDownloads => _simultaneousDownloads;
  
  set simultaneousDownloads(int value){
    prefs.setInt("simultaneousDownloads", value);
    _simultaneousDownloads = value;
    notifyListeners();
  }

  //------Default File------------------------
  String _defaultFile = "Otros";

  String get defaultFile => _defaultFile;

  set defaultFile(String value){
    prefs.setString("defaultFile", value);
    _defaultFile = value;
    notifyListeners();
  }


   void _loadPreferences() {
    _wifiDownload = prefs.getBool("wifiDownload") ?? true;
    _simultaneousDownloads = prefs.getInt("simultaneousDownloads") ?? 3;
    _defaultFile = prefs.getString("defaultFile") ?? "Otros";
    notifyListeners();
  }
  
}