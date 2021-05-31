import { HttpErrorResponse } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { User } from 'src/app/models/user.model';
import { Pet } from '../models/pet.model';
import { AccountService } from '../services/account.service';
import { MatDialog, MatDialogConfig } from '@angular/material/dialog';
import { AddPetComponent } from '../add-pet/add-pet.component';
import { PetService } from '../services/pet.service';
import { AlertService } from '../services/alert.service';
import { DeletePetComponent } from './delete-pet/delete-pet.component';
import { Router } from '@angular/router';

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
  loading:boolean = true;
  titleSelected;
  constructor(private accountService: AccountService, private dialog: MatDialog, private petService: PetService,private alertService: AlertService,private router: Router) {}

  ngOnInit(): void {
    this.pets();
  }

  public pets() {
    this.accountService.getPets(this.getUserId()).subscribe(
      (response: Pet[]) => {
      this.Pet = response['data'];
      this.loading = false;
    },
    (error: HttpErrorResponse) => {
      //alert(error.message);
      this.alertService.error(error.message)
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
    this.petService.form.reset();
    const dialogConfig = new MatDialogConfig();
    dialogConfig.disableClose = true;
    dialogConfig.autoFocus = true;  
    dialogConfig.width = "35%"
    dialogConfig.height = "50%"
    this.dialog.open(AddPetComponent,dialogConfig);
  }

  
 
  goProfile(id:number) {
    this.titleSelected = id;
    this.router.navigate([`/pets/${id}`],{state: {data: id}});
  }
}
