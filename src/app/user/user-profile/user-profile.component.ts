import { Component, OnInit } from '@angular/core';
import { MatDialog, MatDialogConfig } from '@angular/material/dialog';
import * as _ from 'lodash';
import { User } from 'src/app/models/user.model';
import { AccountService } from 'src/app/services/account.service';
import { AlertService } from 'src/app/services/alert.service';
import { CustomValidatorService } from 'src/app/services/custom-validator.service';
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
  imageError: any;
  userAux:User;

  constructor(private dialog: MatDialog, private accountService:AccountService, private val:CustomValidatorService, private alertService: AlertService) { }

  ngOnInit(): void {
    this.getUser();
  }

  getUser() {
    this.string = localStorage.getItem('user');
    this.userAux = (JSON.parse(this.string));
    this.user = (JSON.parse(this.string));
    if (this.userAux.token) {
      this.payload = this.userAux.token.split(".")[1];
      this.payload = window.atob(this.payload);
      const userString =  JSON.parse(this.payload);
      this.user = userString;
      this.user.profilePicture = this.userAux.profilePicture;
      this.user.token = this.userAux.token;
      this.userAux = null;
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

  fileChangeEvent(fileInput) {
    this.imageError = null;
          if (fileInput.target.files && fileInput.target.files[0]) {
              // Size Filter Bytes
              const max_size = 20971520;
              const allowed_types = ['image/png', 'image/jpeg'];
              const max_height = 15200;
              const max_width = 25600;
  
              if (fileInput.target.files[0].size > max_size) {
                  this.imageError = 'Maximum size allowed is ' + max_size / 1000 + 'MB';
                      this.displayError(this.imageError);
                      return false;
              }
  
              if (!_.includes(allowed_types, fileInput.target.files[0].type)) {
                  this.imageError = 'Only allowed images are of type JPG or PNG';
                  this.displayError(this.imageError);
                  return false;
              }
              const reader = new FileReader();
              reader.onload = (e: any) => {
                  const image = new Image();
                  image.src = e.target.result;
                  image.onload = rs => {
                      const img_height = rs.currentTarget['height'];
                      const img_width = rs.currentTarget['width'];
                      console.log(img_height, img_width);
                      if (img_height > max_height && img_width > max_width) {
                          this.imageError =
                              'Maximum dimentions allowed ' +
                              max_height +
                              'x' +
                              max_width +
                              'px';
                              this.displayError(this.imageError);
                          return false;
                      } else {
                          const imgBase64Path = e.target.result;
                          this.user.profilePicture = imgBase64Path;
                          
                          this.accountService.editUser(this.val.getUserId(),this.user).subscribe();
                          
                          localStorage.setItem('user',JSON.stringify(this.user));
                          
                          window.location.reload();
                      }
                  };
              };
              reader.readAsDataURL(fileInput.target.files[0]);
          }
      }
      
      private displayError(message: string) {
        this.alertService.error(message,
          { autoClose: false }
        );
      }
   
}