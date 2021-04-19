import { Injectable } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { AddPetComponent } from '../add-pet/add-pet.component';
import { CustomValidatorService } from './custom-validator.service';
import * as _ from 'lodash';

@Injectable({
  providedIn: 'root'
})
export class PetService {

  constructor(private formBuilder: FormBuilder,private val: CustomValidatorService) { }
    form: FormGroup = this.formBuilder.group({
    ID: null,
    name: ['',Validators.required],
    //picture: ['',Validators.required],
    animaltype: ['',Validators.required],
    race: ['',Validators.required],
    UserID: [this.val.getUserId()]
  });

  populateForm(pet) {
    this.form.setValue(_.omit(pet,'CreatedAt','UpdatedAt','DeletedAt','picture','vaccinationCard'));
  }

}
