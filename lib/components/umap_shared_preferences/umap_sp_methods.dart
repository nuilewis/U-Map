import 'package:shared_preferences/shared_preferences.dart';
import 'umap_shared_preferences.dart';
import 'dart:convert';

List<UmapSaved> umapSPList = <UmapSaved>[];

//Instantiating shared Prefs
late SharedPreferences umapSharedPreferences;

///initialising Shared Preferences
initUmapSharedPreferences() async {
  umapSharedPreferences = await SharedPreferences.getInstance();
  loadSPData();
}

///methods to add, remove, store and load data into a json list
void addToSavedList(UmapSaved savedItem) {
  umapSPList.add(savedItem);
  //setState(() {});
  saveSPData();
}

void removeFromSavedList(UmapSaved savedItem, locationName) {
  umapSPList.removeWhere((savedItem) => savedItem.savedName == locationName);
  if (umapSPList.isEmpty)
    //setState(() {});
    saveSPData();
}

void saveSPData() async {
  List<String> spList = umapSPList.map((savedItem) {
    return json.encode(savedItem.toMap());
  }).toList();
  umapSharedPreferences.setStringList('list', spList);
  //setState(() {});
  // await FlowSharedPreferences.setString(SavedID, widget.bottomSheetID);

  print(spList);
}

void loadSPData() {
  List<String> spList = umapSharedPreferences.getStringList('list')!;
  umapSPList = spList
      .map((savedItem) => UmapSaved.fromMap(json.decode(savedItem)))
      .toList();
  //setState(() {});
}
