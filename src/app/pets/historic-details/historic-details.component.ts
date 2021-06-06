import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Pet } from 'src/app/models/pet.model';
import { AccountService } from 'src/app/services/account.service';
import { CustomValidatorService } from 'src/app/services/custom-validator.service';
import { HistoricPetComponent } from '../historic-pet/historic-pet.component';

@Component({
  selector: 'app-historic-details',
  templateUrl: './historic-details.component.html',
  styleUrls: ['./historic-details.component.css']
})
export class HistoricDetailsComponent implements OnInit {
  pet:Pet;
  error:string;
  helper:string;
  medication: string[][] = [];
  constructor(private dialogRef:MatDialogRef<HistoricPetComponent>,@Inject(MAT_DIALOG_DATA) public data: any,private accountService:AccountService,private val:CustomValidatorService) { }

  ngOnInit(): void {
  this.getPet();
  this.helper = this.data.medication;
   let r = this.helper.split(";") //separar as varias medicaçoes
   for(let i = 0; i < r.length - 1; i++) {
     this.medication[i] = r[i].split("/");
   }
  }
  onNoClick() {
    this.dialogRef.close();
  }
  getPet() {
    this.accountService.getPet(this.data.AnimalID,this.val.getUserId()).subscribe(
      (response: Pet) => {
        this.pet = response['data'];
      },
      error => this.error = error);
  }
  get displayData() {
    return this.data;
  }
}
