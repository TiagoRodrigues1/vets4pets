import { Injectable } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { CustomValidatorService } from './custom-validator.service';
import * as _ from 'lodash';

@Injectable({
  providedIn: 'root'
})
export class AdoptionService {
  emailPattern = '^[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,4}$';
  phoneRegex = '^(?:2\d|9[1236])[0-9]{7}$';

  constructor(private formBuilder: FormBuilder,private val: CustomValidatorService) { }
    form: FormGroup = this.formBuilder.group({
    ID: null,
    name: ['',Validators.required],
    animaltype: ['',Validators.required],
    race: ['',Validators.required],
    text: ['',Validators.required],
    city: ['',Validators.required],
    phonenumber:['',[Validators.pattern(this.phoneRegex)]],
    email:['',[Validators.required,Validators.pattern(this.emailPattern),Validators.email]],
    birth:['',],
    UserID: [this.val.getUserId()],
    attachement1:[''],
    attachement2:[''],
    attachement3:[''],
    attachement4:[''],
  });

  populateForm(adoption) {
    this.form.setValue(_.omit(adoption,'CreatedAt','UpdatedAt','DeletedAt','attachament1','attachament2','attachament3','attachament4','adopted','username'));
  }

}