import { HttpErrorResponse } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { MatDialog, MatDialogConfig } from '@angular/material/dialog';
import { Router } from '@angular/router';
import { AddPetComponent } from '../add-pet/add-pet.component';
import { onMainContentChange } from '../animations/animations';
import { Appointment } from '../models/appointment.model';
import { Pet } from '../models/pet.model';
import { User } from '../models/user.model';
import { AccountService } from '../services/account.service';
import { CustomValidatorService } from '../services/custom-validator.service';
import { PetService } from '../services/pet.service';
import { SidenavService } from '../services/sidenav.service';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css'],
  animations: [ onMainContentChange ]

})
export class HomeComponent implements OnInit {
  user: User;
  onSideNavChange: boolean;
  error:string
  loading:boolean = true;
  Pet:Pet[];
  dates:Date[] = [];
  todaysDate:Date;
  app:Appointment[];
  constructor(private accountService: AccountService,private _sidenavService: SidenavService, public router: Router,private customValidator:CustomValidatorService,private petService:PetService,private dialog: MatDialog) {
      this.user = this.accountService.userValue;
      this._sidenavService.sideNavState$.subscribe(res => {
        this.onSideNavChange = res;
    })
    
  }

  ngOnInit(): void {
    this.getPets();
    this.todaysDate = new Date();
    setTimeout(() => {
      this.getAppointments();
    },1000);
    
  }
  
  getPets() {
    this.accountService.getPets(this.customValidator.getUserId()).subscribe(
      (response: Pet[]) => {
      this.Pet = response['data'];
      this.loading = false;
      
    },
    (error: HttpErrorResponse) => {
      this.error = "You don't have any pets"
    });
  }

  onCreate() {
    this.petService.form.reset();
    const dialogConfig = new MatDialogConfig();
    dialogConfig.disableClose = true;
    dialogConfig.autoFocus = false;  
    dialogConfig.width = "35%"
    dialogConfig.height = "50%"
    this.dialog.open(AddPetComponent,dialogConfig);
  }

  getAppointments() {
    this.accountService.getAppointmentsUser(this.customValidator.getUserId()).subscribe(
      (response: Appointment[]) => {
      this.app = response['data'];
      this.app.forEach(ap => {
        let date = new Date(ap.date);
        if(date.getTime() >=this.todaysDate.getTime() && this.dates.length < 3) {
          this.dates.push(ap.date);
        }
      });
    },
    error => {
      this.error = "You don't have any appointments";
    });
  }
}
