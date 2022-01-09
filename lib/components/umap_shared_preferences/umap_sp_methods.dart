import 'package:shared_preferences/shared_preferences.dart';
import 'umap_shared_preferences.dart';
import 'dart:convert';

List<UmapSaved> umapSPList = <UmapSaved>[];

//Instantiating shared Prefs
late final  SharedPreferences umapSharedPreferences;

///initialising Shared Preferences
initUmapSharedPreferences() async {
  umapSharedPreferences = await SharedPreferences.getInstance();
  loadSPData();
}

///methods to add, remove, store and load data into a json list
void addToSavedList({required UmapSaved savedItem}) {
  umapSPList.add(savedItem);
  //setState(() {});
  saveSPData();
}

void removeFromSavedList(
    {required UmapSaved savedItem, required String locationID}) {
  umapSPList.removeWhere((savedItem) => savedItem.savedID == locationID);
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

void loadSPData() async {
  List<String> spList = umapSharedPreferences.getStringList('list')!;
  umapSPList = spList
      .map((savedItem) => UmapSaved.fromMap(json.decode(savedItem)))
      .toList();
  //setState(() {});
}
