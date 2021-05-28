class Vaccine{
    String sn, name, address, phone;
    
    Vaccine({
        this.sn, 
        this.name, 
        this.address, 
        this.phone
    });
    //constructor

    factory Vaccine.fromJSON(Map<String, dynamic> json){
        return Vaccine( 
          sn: json["sn"],
          name: json["name"],
          address: json["address"],
          phone: json["phone"]
        );
    } 
}