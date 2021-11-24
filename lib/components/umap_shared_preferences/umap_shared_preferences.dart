class UmapSaved {
  String savedName;
  String savedID;
  String savedCategory;
  String savedDescription;
  String savedImgUrl;



  UmapSaved({
    required this.savedName,
    required this.savedID,
    required this.savedDescription,
    required this.savedCategory,
    required this.savedImgUrl,
    // this.savedisSaved,
  });

  ///convert from map to flowSaved object
  UmapSaved.fromMap(Map map)
      : this.savedName = map[
            'Name'], // assigning ths SavedID from the constructor to the 'Name' property/Variable of our map

        this.savedID = map['ID'],
  this.savedCategory = map['Category'],
        this.savedDescription = map['Description'],
        this.savedImgUrl = map['ImageUrl'];


  ///convert from flowSaved Object to a map
  Map toMap() {
    return {
      'Name': this.savedName,
      'ID': this.savedID,
      'Category': this.savedCategory,
      'Description': this.savedDescription,
      'ImageUrl': this.savedImgUrl,
    };
  }
}
