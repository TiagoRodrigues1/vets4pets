export class Appointment {
    ID: number;
    AnimalID: number;
    vetID: number;
    date: Date;
    showedUp: boolean;
    
    constructor(animalID:number,vetID:number,date:Date) {
        this.AnimalID = animalID;
        this.vetID = vetID;
        this.date = date;
    }
    
}
