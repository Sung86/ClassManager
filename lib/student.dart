class Student
{
  String? documentID;
  String name;
  String id;
  String profilePictureUrl;
  List<dynamic> scores;

  Student({
    required this.name, required this.id, required this.profilePictureUrl
  }):scores = ["0","0","0","0","0","0","0","0","0","0","0","0"];

  Student.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        id = json["id"],
        profilePictureUrl = json["profilePictureUrl"],
        scores = json["scores"];


  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'id' : id,
        'profilePictureUrl': profilePictureUrl,
        'scores': scores
      };
}
