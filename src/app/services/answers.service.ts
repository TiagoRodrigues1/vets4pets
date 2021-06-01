import { Injectable } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { CustomValidatorService } from './custom-validator.service';
import * as _ from 'lodash';

@Injectable({
  providedIn: 'root'
})
export class AnswersService {

  constructor(private formBuilder: FormBuilder,private val: CustomValidatorService) { }
  form: FormGroup = this.formBuilder.group({
  ID: null,
  answer: ['',Validators.required],
  questionID: ['',Validators.required],
  UserID: [this.val.getUserId()],
  attachement:[],
});

populateForm(question) {
  this.form.setValue(_.omit(question,'CreatedAt','UpdatedAt','DeletedAt'));
}

}
