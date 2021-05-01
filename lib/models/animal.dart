
class Animal{
  int id;
  int user_id;
  String name;
  String animaltype;
  String race;

  //List<Image> picture;

 Animal({this.id, this.user_id, this.name, this.animaltype, this.race});

    factory Animal.fromJson(Map<String,dynamic> json){
        return Animal(
          id : json["ID"],
          user_id : json["UserID"],
          name : json["name"],
          animaltype : json["animaltype"],
          race: json["race"]
         
        );


    }
  
}