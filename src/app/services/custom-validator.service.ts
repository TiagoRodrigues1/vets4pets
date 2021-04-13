import { Injectable } from '@angular/core';
import { FormGroup } from '@angular/forms';

@Injectable({
  providedIn: 'root'
})
export class CustomValidatorService {

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
}
