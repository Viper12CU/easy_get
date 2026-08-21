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

  //------Automatic retry--------------------
  bool _automaticRetry = true;

  bool get automaticRetry => _automaticRetry;

  set automaticRetry(bool value) {
    prefs.setBool("autommaticRetry", value);
    _automaticRetry = value;
    notifyListeners();
  }

  //------Max download retrys-----------------
  int _maxRetries = 3;

  int get maxRetries => _maxRetries;

  set maxRetries(int value) {
    prefs.setInt("maxRetrys", value);
    _maxRetries = value;
    notifyListeners();
  }

  //------Application language----------------
  String _language = "system";

  String get language => _language;

  set language(String value) {
    prefs.setString("language", value);
    _language = value;
    notifyListeners();
  }

  //------Download notifications-------------
  bool _notificationsEnabled = true;

  bool get notificationsEnabled => _notificationsEnabled;

  set notificationsEnabled(bool value) {
    prefs.setBool("notificationsEnabled", value);
    _notificationsEnabled = value;
    notifyListeners();
  }

  //------Default download priority----------
  int _defaultPriority = 5;

  int get defaultPriority => _defaultPriority;

  set defaultPriority(int value) {
    prefs.setInt("defaultPriority", value);
    _defaultPriority = value;
    notifyListeners();
  }

  //------Completion behavior----------------
  String _completionBehavior = "keep";

  String get completionBehavior => _completionBehavior;

  set completionBehavior(String value) {
    prefs.setString("completionBehavior", value);
    _completionBehavior = value;
    notifyListeners();
  }

  //------Download location------------------
  String _downloadLocation = "Almacenamiento de la aplicación";

  String get downloadLocation => _downloadLocation;

  set downloadLocation(String value) {
    prefs.setString("downloadLocation", value);
    _downloadLocation = value;
    notifyListeners();
  }


   void _loadPreferences() {
    _wifiDownload = prefs.getBool("wifiDownload") ?? true;
    _simultaneousDownloads = prefs.getInt("simultaneousDownloads") ?? 3;
    _defaultFile = prefs.getString("defaultFile") ?? "Otros";
    _automaticRetry = prefs.getBool("autommaticRetry") ?? true;
    _maxRetries = prefs.getInt("maxRetrys") ?? 3;
    _language = prefs.getString("language") ?? "system";
    _notificationsEnabled = prefs.getBool("notificationsEnabled") ?? true;
    _defaultPriority = prefs.getInt("defaultPriority") ?? 5;
    _completionBehavior =
      prefs.getString("completionBehavior") ?? "keep";
    _downloadLocation = prefs.getString("downloadLocation") ??
      "Almacenamiento de la aplicación";
    notifyListeners();
  }
  
}