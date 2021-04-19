import { HttpErrorResponse } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { User } from 'src/app/models/user.model';
import { Pet } from '../models/pet.model';
import { AccountService } from '../services/account.service';
import { MatDialog, MatDialogConfig } from '@angular/material/dialog';
import { AddPetComponent } from '../add-pet/add-pet.component';
import { PetService } from '../services/pet.service';

@Component({
  selector: 'app-pets',
  templateUrl: './pets.component.html',
  styleUrls: ['./pets.component.css']
})
export class PetsComponent implements OnInit {
  user: User;
  string : string;
  payload;
  Pet : Pet[];
  status: string;
  constructor(private accountService: AccountService, private dialog: MatDialog, private petService: PetService) { 
  }

  ngOnInit(): void {
    this.pets();
  }

  public pets() {
    this.accountService.getPets(this.getUserId()).subscribe(
      (response: Pet[]) => {
      this.Pet = response['data'];
    },
    (error: HttpErrorResponse) => {
      alert(error.message);
    });
  }

  getUserId()  {
    this.string = localStorage.getItem('user');
    this.user = (JSON.parse(this.string));
    if (this.user.token) {
      this.payload = this.user.token.split(".")[1];
      this.payload = window.atob(this.payload);
      const userString =  JSON.parse(this.payload);
      return parseInt(userString.UserID);
    } 
  }

  onCreate() {
    const dialogConfig = new MatDialogConfig();
    dialogConfig.disableClose = false;
    dialogConfig.autoFocus = true;  
    dialogConfig.width = "35%"
    this.dialog.open(AddPetComponent,dialogConfig);
  }

  deletePet(id:number) {
    this.accountService.deletePet(id).subscribe(() => this.status = 'Delete Sucessful');
    window.location.reload();
  }

  editPet(pet) {
    this.petService.populateForm(pet);
    const dialogConfig = new MatDialogConfig();
    dialogConfig.disableClose = false;
    dialogConfig.autoFocus = true;  
    dialogConfig.width = "35%"
    this.dialog.open(AddPetComponent,dialogConfig);
  }
 

}
