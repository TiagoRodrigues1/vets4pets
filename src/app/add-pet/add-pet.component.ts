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

@Component({
  selector: 'app-add-pet',
  templateUrl: './add-pet.component.html',
  styleUrls: ['./add-pet.component.css']
})
export class AddPetComponent implements OnInit {

  public animalType: AnimalType[] = [
    {type: 'dog',viewValue:'Dog'},
    {type: 'cat',viewValue:'Cat'},
    {type: 'turtle',viewValue:'Turtle'},
    {type: 'hamster',viewValue:'Hamster'},
    {type: 'snake',viewValue:'Snake'},
    {type: 'guinea-pig',viewValue:'Guinea Pig'},
    {type: 'bird',viewValue:'Bird'},
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
  console.log(this.petService.form.value);
  this.accountService.createPet(this.petService.form.value).pipe(first()).subscribe({
    next: () => {
      this.router.navigate(['../pets'],{relativeTo: this.route});
    }
  });
  this.onClose();
  window.location.reload();
} else {
  if (this.petService.form.invalid) {
    return;
}
  //console.log(this.petService.form.get('ID').value);
  this.accountService.editPet(this.petService.form.get('ID').value,this.petService.form.value).subscribe();
  this.onClose();
  window.location.reload();
  }
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


