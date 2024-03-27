class QueryPlace {
  String? desc, placeId, address;
  QueryPlace({this.desc, this.placeId, this.address});

  factory QueryPlace.fromJSON(Map<String, dynamic> json) {
    return QueryPlace(
        desc: json["structured_formatting"]["main_text"],
        address: json["structured_formatting"]["secondary_text"],
        placeId: json["place_id"]);
  }
}
