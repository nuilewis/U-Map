class UmapSaved {
  String savedName;
  String savedDescription;
  String savedDistance;
  double savedTapLocationLatitude;
  double savedTapLocationLongitude;
  //bool savedisSaved;

  UmapSaved({
    required this.savedName,
    required this.savedDescription,
    required this.savedDistance,
    required this.savedTapLocationLatitude,
    required this.savedTapLocationLongitude,
    // this.savedisSaved,
  });

  ///convert from map to flowSaved object
  UmapSaved.fromMap(Map map)
      : this.savedName = map[
            'Name'], // assigning ths SavedID from the constructor to the 'ID' property/Variable of our map
        this.savedDescription = map['Description'],
        this.savedDistance = map['Distance'],
        this.savedTapLocationLatitude = map['LocationLat'],
        this.savedTapLocationLongitude = map['LocationLong'];

  ///convert from flowSaved Object to a map
  Map toMap() {
    return {
      'ID': this.savedName,
      'Description': this.savedDescription,
      'Distance': this.savedDistance,
      'LocationLat': this.savedTapLocationLatitude,
      'LocationLong': this.savedTapLocationLongitude,
      // 'isSaved': this.savedisSaved,
    };
  }
}
