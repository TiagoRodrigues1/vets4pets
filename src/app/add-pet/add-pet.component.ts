import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { first } from 'rxjs/operators';
import { AccountService } from 'src/app/services/account.service';
import { MatDialogRef } from '@angular/material/dialog';
import { PetsComponent } from '../pets/pets.component';
import { PetService } from '../services/pet.service';
import { CustomValidatorService } from '../services/custom-validator.service';

interface AnimalType {
  type : string,
  viewValue: string,
}

interface AnimalRace {
  race:string,
  viewValue:string,
  key:string,
}

@Component({
  selector: 'app-add-pet',
  templateUrl: './add-pet.component.html',
  styleUrls: ['./add-pet.component.css']
})
export class AddPetComponent implements OnInit {
  selectedFile = null;
  departure:string;
  public animalType: AnimalType[] = [
    {type: 'Dog',viewValue:'Dog'},
    {type: 'Cat',viewValue:'Cat'},
    {type: 'Turtle',viewValue:'Turtle'},
    {type: 'Hamster',viewValue:'Hamster'},
    {type: 'Snake',viewValue:'Snake'},
    {type: 'Guinea-pig',viewValue:'Guinea-pig'},
    {type: 'Bird',viewValue:'Bird'},
    {type: 'N/A',viewValue:'Other'},
  ];

  public animalRace: AnimalRace[]  = [
    {race: 'Labrador Retriever',viewValue : 'Labrador Retriever',key: 'Dog'},
    {race: 'German Shepherd',viewValue : 'German Shepherd',key: 'Dog'},
    {race: 'Golden Retriever',viewValue : 'Golden Retriever',key: 'Dog'},
    {race: 'Bulldog',viewValue : 'Bulldog',key: 'Dog'},
    {race: 'Beagle',viewValue : 'Beagle',key:'Dog'},
    {race: 'French Bulldog',viewValue : 'French Bulldog',key:'Dog'},
    {race: 'Yorkshire Terrier',viewValue : 'Yorkshire Terrier',key:'Dog'},
    {race: 'Poodle',viewValue : 'Poodle',key:'Dog'},
    {race: 'Rottweiler',viewValue : 'Rottweiler',key:'Dog'},
    {race: 'Boxer',viewValue : 'Boxer',key:'Dog'},
    {race: 'Husky',viewValue : 'Husky',key:'Dog'},
    {race: 'N/A',viewValue:'Other',key:'Dog'},

    {race: 'Devon Rex',viewValue : 'Devon Rex',key:'Cat'},
    {race: 'Abyssinian',viewValue : 'Abyssinian',key:'Cat'},
    {race: 'Sphynx',viewValue : 'Sphynx ',key:'Cat'},
    {race: 'Scottish Fold',viewValue : 'Scottish Fold',key:'Cat'},
    {race: 'American Shorthair',viewValue : 'American Shorthair',key:'Cat'},
    {race: 'Maine Coon',viewValue : 'Maine Coon',key:'Cat'},
    {race: 'Persian',viewValue : 'Persian',key:'Cat'},
    {race: 'British Shorthair',viewValue : 'British Shorthair',key:'Cat'},
    {race: 'Ragdoll Cats',viewValue : 'Ragdoll Cats',key:'Cat'},
    {race: 'Exotic Shorthair',viewValue : 'Exotic Shorthair',key:'Cat'},
    {race: 'N/A',viewValue:'Other',key:'Cat'},

    {race: 'Chelidae',viewValue : 'Chelidae',key:'Turtle'},
    {race: 'Red-Eared Slider',viewValue : 'Red-Eared Slider',key:'Turtle'},
    {race: 'Yellow-Bellied Slider',viewValue : 'Yellow-Bellied Slider',key:'Turtle'},
    {race: 'Eastern Box',viewValue : 'Eastern Box',key:'Turtle'},
    {race: 'N/A',viewValue:'Other',key:'Turtle'},

    {race: 'Syrian',viewValue : 'Syrian',key:'Hamster'},
    {race: 'Winter White',viewValue : 'Winter White',key:'Hamster'},
    {race: 'Campbell’s Dwarf',viewValue: 'Campbell’s Dwarf',key:'Hamster'},
    {race: 'Roborovski',viewValue : 'Roborovski',key:'Hamster'},
    {race: 'Chinese',viewValue : 'Chinese',key:'Hamster'},
    {race: 'N/A',viewValue:'Other',key:'Hamster'},

    {race: 'Budgerigar',viewValue : 'Budgerigar',key:'Bird'},
    {race: 'Cockatiel',viewValue : 'Cockatiel',key:'Bird'},
    {race: 'Cockatoo',viewValue: 'Cockatoo',key:'Bird'},
    {race: 'Hyacinth Macaw',viewValue : 'Hyacinth Macaw',key:'Bird'},
    {race: 'Parrotlet',viewValue : 'Parrotlet',key:'Bird'},
    {race: 'Green-Cheeked Conure',viewValue : 'Green-Cheeked Conure',key:'Bird'},
    {race: 'Hahn’s Macaw',viewValue : 'Hahn’s Macaw',key:'Bird'},
    {race: 'N/A',viewValue:'Other',key:'Bird'},

    {race: 'Smooth Green',viewValue : 'Smooth Green',key:'Snake'},
    {race: 'Ringneck Snake',viewValue : 'Ringneck Snake',key:'Snake'},
    {race: 'Rainbow Boa',viewValue : 'Rainbow Boa',key:'Snake'},
    {race: 'Carpet Python',viewValue : 'Carpet Python',key:'Snake'},
    {race: 'Corn Snake',viewValue : 'Corn Snake',key:'Snake'},
    {race: 'California King',viewValue : 'California King',key:'Snake'},
    {race: 'N/A',viewValue:'Other',key:'Snake'},

    {race: 'Abyssinian',viewValue : 'Abyssinian',key:'Guinea-pig'},
    {race: 'Alpaca',viewValue : 'Alpaca',key:'Guinea-pig'},
    {race: 'American',viewValue : 'American',key:'Guinea-pig'},
    {race: 'Baldwin',viewValue : 'Baldwin',key:'Guinea-pig'},
    {race: 'Coronet',viewValue : 'Coronet',key:'Guinea-pig'},
    {race: 'Himalayan',viewValue : 'Himalayan',key:'Guinea-pig'},
    {race: 'N/A',viewValue:'Other',key:'Guinea-pig'},
   ];


  constructor(private accountService: AccountService,private router: Router,private route: ActivatedRoute,private dialogRef: MatDialogRef<PetsComponent>,private petService: PetService, private val : CustomValidatorService) { }

  ngOnInit(): void {

  }

onSubmit() {
  if(!this.service.form.get('ID').value) {
    if (this.petService.form.invalid) {
      return;
  }
  this.petService.form.get('UserID').setValue(this.val.getUserId());
  this.accountService.createPet(this.petService.form.value).pipe(first()).subscribe({
    next: () => {
      this.router.navigate(['../pets'],{relativeTo: this.route});
    }
  });
  this.onClose();
  //window.location.reload();
} else {
  if (this.petService.form.invalid) {
    return;
}
  this.accountService.editPet(this.petService.form.get('ID').value,this.petService.form.value).subscribe();
  this.onClose();
  window.location.reload();
  }
}

onImageChange(e) {
  this.selectedFile = <File>e.target.files[0];
}

onClose() {
  this.petService.form.reset();
  this.dialogRef.close();
}

populateForm() {
    console.log(this.petService);
    this.petService.form.setValue(this.petService);
  }

get service() {
    return this.petService;
  }

onNoClick() {
    this.dialogRef.close();
  }
  

}


