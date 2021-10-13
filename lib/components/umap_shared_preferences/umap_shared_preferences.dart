class UmapSaved {
  String savedName;
  String savedDescription;
  String? savedDistance;
  String savedImgUrl;
  double savedLocationLatitude;
  double savedLocationLongitude;
  //bool savedisSaved;

  UmapSaved({
    required this.savedName,
    required this.savedDescription,
    this.savedDistance,
    required this.savedLocationLatitude,
    required this.savedLocationLongitude,
    required this.savedImgUrl,
    // this.savedisSaved,
  });

  ///convert from map to flowSaved object
  UmapSaved.fromMap(Map map)
      : this.savedName = map[
            'Name'], // assigning ths SavedID from the constructor to the 'Name' property/Variable of our map
        this.savedDescription = map['Description'],
        this.savedDistance = map['Distance'],
        this.savedImgUrl = map['ImageUrl'],
        this.savedLocationLatitude = map['LocationLat'],
        this.savedLocationLongitude = map['LocationLong'];

  ///convert from flowSaved Object to a map
  Map toMap() {
    return {
      'Name': this.savedName,
      'Description': this.savedDescription,
      'Distance': this.savedDistance ?? "N/A Km",
      'ImageUrl': this.savedImgUrl,
      'LocationLat': this.savedLocationLatitude,
      'LocationLong': this.savedLocationLongitude,
      // 'isSaved': this.savedisSaved,
    };
  }
}
