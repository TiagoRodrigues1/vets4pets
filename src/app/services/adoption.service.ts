import { Injectable } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { AddadoptionComponent } from 'src/app/adoptions/addadoption/addadoption.component';
import { CustomValidatorService } from './custom-validator.service';
import * as _ from 'lodash';

@Injectable({
  providedIn: 'root'
})
export class AdoptionService {

  constructor(private formBuilder: FormBuilder,private val: CustomValidatorService) { }
    form: FormGroup = this.formBuilder.group({
    ID: null,
    name: ['',Validators.required],
    animaltype: ['',Validators.required],
    race: ['',Validators.required],
    text: ['',Validators.required],
    city: ['',Validators.required],
    phonenumber:['',],
    email:['',Validators.required],
    birth:['',],
    UserID: [this.val.getUserId()]
  });

  populateForm(adoption) {
    this.form.setValue(_.omit(adoption,'CreatedAt','UpdatedAt','DeletedAt','attachament1','attachament2','attachament3','attachament4'));
  }

}