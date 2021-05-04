import { Component, OnInit } from '@angular/core';
import { MatDialog, MatDialogConfig } from '@angular/material/dialog';
import { User } from 'src/app/models/user.model';
import { DisplayAppointmentComponent } from '../display-appointment/display-appointment.component';
import { EditUserProfileComponent } from '../edit-user-profile/edit-user-profile.component';

@Component({
  selector: 'app-user-profile',
  templateUrl: './user-profile.component.html',
  styleUrls: ['./user-profile.component.css']
})
export class UserProfileComponent implements OnInit {
  user:User;
  string: string;
  payload: string;
  toggle = true;

  constructor(private dialog: MatDialog) { }

  ngOnInit(): void {
    this.getUser();

  }

  getUser() {
    this.string = localStorage.getItem('user');
    this.user = (JSON.parse(this.string));
    if (this.user.token) {
      this.payload = this.user.token.split(".")[1];
      this.payload = window.atob(this.payload);
      const userString =  JSON.parse(this.payload);
      this.user = userString;
   }
  }

  get userH() {
    return this.user;
  }

  editProfile() {
    this.toggle = !this.toggle;
    const dialogConfig = new MatDialogConfig();
    dialogConfig.disableClose = true;
    dialogConfig.autoFocus = true;
    dialogConfig.width = "35%"
    this.dialog.open(EditUserProfileComponent,dialogConfig);
  }

  showAppointments() {
    const dialogConfig = new MatDialogConfig();
    dialogConfig.disableClose = false;
    dialogConfig.autoFocus = true;
    dialogConfig.width = "60%"
    this.dialog.open(DisplayAppointmentComponent,dialogConfig);
  }

}