import { Injectable } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import * as _ from 'lodash-es';
import { User } from '../models/user.model';

@Injectable({
  providedIn: 'root'
})
export class PetService {
  string: string;
  user: User;
  payload: any;
  constructor(private formBuilder: FormBuilder) { 
  }
    form: FormGroup = this.formBuilder.group({
    ID: null,
    name: ['',[Validators.required,Validators.maxLength(20)]],
    //picture: ['',Validators.required],
    animaltype: ['',Validators.required],
    race: ['',Validators.required],
    UserID: []
  });

  populateForm(pet) {
    console.log(pet);
    this.form.setValue(_.omit(pet,'CreatedAt','UpdatedAt','DeletedAt','picture','vaccinationCard'));
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
