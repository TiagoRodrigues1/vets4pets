import { Injectable } from '@angular/core';
import { FormGroup } from '@angular/forms';
import { User } from '../models/user.model';

@Injectable({
  providedIn: 'root'
})
export class CustomValidatorService {
  user: User;
  string : string;
  payload;
  constructor() { }

  passwordMatchValidator(password: string, passwordConfirm : string) {
    return (formGroup : FormGroup) => {
      const passwordControl = formGroup.controls[password];
      const passwordConfirmControl = formGroup.controls[passwordConfirm];

      if(!passwordControl || !passwordConfirmControl ) {
        return null;
      }

      if (passwordConfirmControl.errors && !passwordConfirmControl.errors.passwordMismatch) {
        return null;
      }

      if(passwordConfirmControl.value !== passwordControl.value) {
        passwordConfirmControl.setErrors ({passwordMismatch : true });
      } else {
        passwordConfirmControl.setErrors(null);
      }
    }
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


}
