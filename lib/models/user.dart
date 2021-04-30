//import 'animal.dart';

class User{
  String email;
  String password;
 String username;
  String name;
  String userType;
  String contact;
  String numberOfAnsweredQuestions;
  //List<Animal> animals;

  User({this.email, this.password, this.username, this.name, this.userType, this.contact, this.numberOfAnsweredQuestions});

    factory User.fromJson(Map<String,dynamic> json){
        return User(
          email : json["email"],
          password : json["password"],
          username : json["username"],
          name : json["name"],
          userType : json["userType"],
          contact : json["contact"],
          numberOfAnsweredQuestions : json["numberOfAnsweredQuestions"],
        );


    }
     



}