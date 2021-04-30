
class Animal{
  String name;
  String animalType;
  String race;
  //List<Image> picture;

  Animal(this.name, this.animalType, this.race); //testar com bigodes dentro dos ()
  /* // TESTAR COMO FACTORY
  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
      name: json['name'],
      animalType: json['animaltype'],
      race: json['race'],
    );
  }
  */
  Animal.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        animalType = json["animaltype"],
        race = json["race"];
  
}