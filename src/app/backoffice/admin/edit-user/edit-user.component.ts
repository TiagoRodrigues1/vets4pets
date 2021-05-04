import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { User } from 'src/app/models/user.model';
import { AccountService } from 'src/app/services/account.service';
import { AdminComponent } from '../admin.component';

interface UserType {
  type : string,
  viewValue: string,
}

@Component({
  selector: 'app-edit-user',
  templateUrl: './edit-user.component.html',
  styleUrls: ['./edit-user.component.css']
})

export class EditUserComponent implements OnInit {
  form:FormGroup;
  user:User;
  public userType: UserType[] = [
    {type: 'normal',viewValue:'Normal'},
    {type: 'admin',viewValue:'Admin'},
    {type: 'vet',viewValue:'Vet'},
    {type: 'manager',viewValue:'Manager'},
  ];
  constructor(private formBuilder: FormBuilder, private dialogRef: MatDialogRef<AdminComponent>,@Inject(MAT_DIALOG_DATA) public data:any,private accountService: AccountService) { }

  ngOnInit(): void {
    this.form = this.formBuilder.group({
      userType: ['',Validators.required]
    });
}

  onSubmit() {
    delete this.data.password;
    delete this.data.idclinic;
    this.user = this.data;
    this.user.userType = this.form.get('userType').value;
    console.log(this.user);  
    
    this.accountService.editUser(parseInt(this.data.ID),this.user).subscribe();
    this.onNoClick();
    window.location.reload();
  }

  onNoClick() {
    this.dialogRef.close();

  }
}