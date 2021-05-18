import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Pet } from 'src/app/models/pet.model';
import { AccountService } from 'src/app/services/account.service';
import { CustomValidatorService } from 'src/app/services/custom-validator.service';
import { DisplayAppointmentComponent } from '../display-appointment/display-appointment.component';

@Component({
  selector: 'app-appointment-details',
  templateUrl: './appointment-details.component.html',
  styleUrls: ['./appointment-details.component.css']
})
export class AppointmentDetailsComponent implements OnInit {
  pet:Pet;
  date:string;
  year: number;
  day:number;
  month:number;
  hour:number;
  minutes:number;
  error:string;
  constructor(@Inject(MAT_DIALOG_DATA) public data:any, private dialogRef: MatDialogRef<DisplayAppointmentComponent>, private accountService: AccountService, private val: CustomValidatorService) { }

  ngOnInit(): void {
    this.getPet();
  }

  onNoClick() {
    this.dialogRef.close();
  }

  get displayData() {
    return this.data;
  }

  getPet() {
    this.accountService.getPet(this.data.id,this.val.getUserId()).subscribe(
      (response: Pet) => {
        this.pet = response['data'];
      },
      error => this.error = error);
      this.year = this.data.start.getFullYear();
      this.month = this.data.start.getMonth();
      this.day = this.data.start.getDate();
      this.hour = this.data.start.getHours();
      this.minutes = this.data.start.getMinutes();
      if(this.minutes === 0 ) {
      this.date = `${this.day}/${this.month + 1}/${this.year} ${this.hour}:${this.minutes}0`;
    } else {
      this.date = `${this.day}/${this.month + 1}/${this.year} ${this.hour}:${this.minutes}`;
    }
  }
}

