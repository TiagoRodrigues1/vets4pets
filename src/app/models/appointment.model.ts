export class Appointment {
    ID: number;
    animalID: number;
    vetID: number;
    date: Date;
    showedUp: boolean;
    
    constructor(animalID:number,vetID:number,date:Date) {
        this.animalID = animalID;
        this.vetID = vetID;
        this.date = date;
    }
}
