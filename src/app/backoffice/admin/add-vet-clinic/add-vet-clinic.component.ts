import { HttpErrorResponse } from '@angular/common/http';
import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { MatTableDataSource } from '@angular/material/table';
import { User } from 'src/app/models/user.model';
import { AccountService } from 'src/app/services/account.service';
import { AdminComponent } from '../admin.component';

@Component({
  selector: 'app-add-vet-clinic',
  templateUrl: './add-vet-clinic.component.html',
  styleUrls: ['./add-vet-clinic.component.css']
})
export class AddVetClinicComponent implements OnInit {
  ELEMENT_DATA: User[] = [];
  displayedColumns:string[] = ['name','contact','email','username','select'];
  dataSource = new MatTableDataSource<User>(this.ELEMENT_DATA);
  suc:string;
  error:string;
  constructor(private accountService:AccountService, private dialogRef:MatDialogRef<AdminComponent>,@Inject(MAT_DIALOG_DATA) public data:any) { }

  ngOnInit(): void {
    this.getUsers();
  }

  getUsers() {
    let resp = this.accountService.getUsersNormal();
    resp.subscribe(report => { 
      this.dataSource.data = report ['data'] as User[];
    },
    error => this.error = error);    

  }

  addVet(id:number,user:User) {
  this.accountService.addVetToClinic(id,this.data,user).subscribe(response => {
    this.suc = response['message'];
    setTimeout(() => {
      this.dialogRef.close();
    },1000);
  },
  error => {
    this.error = error['message'];
  });
  }
  onNoClick() {
    this.dialogRef.close();
  
  }
}
