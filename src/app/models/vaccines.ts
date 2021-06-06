export class Vaccines {
    date: Date;
    taken: boolean;
    dateTaken:Date;
    validity:Date;
    vaccineName:String;
    AnimalID:Number;

    constructor(animalID:number,date:Date,taken:boolean,validity:Date,vaccineName:String,dateTaken:Date) {
        this.AnimalID = animalID;
        this.date = date;
        this.taken = taken;
        this.validity = validity;
        this.vaccineName = vaccineName;
        this.dateTaken = dateTaken
    }
}
