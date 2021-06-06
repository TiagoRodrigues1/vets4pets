import { Injectable } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
//import { AddPetComponent } from 'src/app/pets/add-pet/add-pet.component';
import { CustomValidatorService } from './custom-validator.service';
import * as _ from 'lodash';

@Injectable({
  providedIn: 'root'
})
export class QuestionService {

  constructor(private formBuilder: FormBuilder,private val: CustomValidatorService) { }
    form: FormGroup = this.formBuilder.group({
    ID: null,
    questiontitle: ['',Validators.required],
    question: ['',[Validators.required,Validators.maxLength(1000)]],
    UserID: [this.val.getUserId()],
    attachement:[],
    username:[this.val.getUsername()],
  });

  populateForm(question) {
    this.form.setValue(_.omit(question,'CreatedAt','UpdatedAt','DeletedAt'));
  }

}
