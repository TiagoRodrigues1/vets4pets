import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatDialogRef } from '@angular/material/dialog';
import { User } from 'src/app/models/user.model';
import { AccountService } from 'src/app/services/account.service';
import { CustomValidatorService } from 'src/app/services/custom-validator.service';
import { UserProfileComponent } from '../user-profile/user-profile.component';

@Component({
  selector: 'app-edit-user-profile',
  templateUrl: './edit-user-profile.component.html',
  styleUrls: ['./edit-user-profile.component.css']
})
export class EditUserProfileComponent implements OnInit {
  form:FormGroup;
  string: string;
  payload: any;
  user:User;
  phoneRegex = '^(?:2\d|9[1236])[0-9]{7}$';
  constructor(private dialogRef:MatDialogRef<UserProfileComponent>, private formBuilder: FormBuilder,private accountService:AccountService, private val: CustomValidatorService) { }

  ngOnInit(): void {
    this.getUser();
    this.fillForm();
  }
  onSubmit() { 
    this.user = this.form.value;

    this.accountService.editUser(this.val.getUserId(),this.user).subscribe();
    this.onNoClick();
    window.location.reload();
  }

  getUser() {
    this.string = localStorage.getItem('user');
    this.user = (JSON.parse(this.string));
    if (this.user.token) {
      this.payload = this.user.token.split(".")[1];
      this.payload = window.atob(this.payload);
      const userString =  JSON.parse(this.payload);
      this.user = userString;
      console.log(userString);
   }
  }

  fillForm() {
    this.form = this.formBuilder.group({
       name: ['',Validators.required],
       contact: ['',[Validators.required,Validators.pattern(this.phoneRegex)]],
       gender: ['',Validators.required],
      });
     this.form.get('name').setValue(this.user.name);
     this.form.get('contact').setValue(this.user.contact);
     this.form.get('gender').setValue(this.user.gender);
   }

  onNoClick() {
    this.dialogRef.close();
  }
}