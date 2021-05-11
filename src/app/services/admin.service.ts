import { Injectable } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import * as _ from 'lodash-es';

@Injectable({
  providedIn: 'root'
})
export class AdminService {
  emailPattern = '^[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,4}$';
  constructor(private formBuilder: FormBuilder) { }
  form: FormGroup = this.formBuilder.group({
    ID: null,
    name: ['',[Validators.required,Validators.maxLength(20)]],
    contact: ['',Validators.required],
    email: ['',[Validators.required,Validators.pattern(this.emailPattern)]],
    address: ['',Validators.required],
    profilePicture:[],
    UserID: []
  });
  populateForm(clinic) {
    console.log(clinic);
    this.form.setValue(_.omit(clinic,'CreatedAt','UpdatedAt','DeletedAt','latitude','longitude'));
  }
}
