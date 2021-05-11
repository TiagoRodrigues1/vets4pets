import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { MatTableDataSource } from '@angular/material/table';
import { User } from 'src/app/models/user.model';
import { AccountService } from 'src/app/services/account.service';
import { AdminComponent } from '../admin.component';

@Component({
  selector: 'app-remove-vet-clinic',
  templateUrl: './remove-vet-clinic.component.html',
  styleUrls: ['./remove-vet-clinic.component.css']
})
export class RemoveVetClinicComponent implements OnInit {
  error:string;
  suc:string;
  ELEMENT_DATA: User[] = [];
  displayedColumns:string[] = ['name','contact','email','username','select'];
  dataSource = new MatTableDataSource<User>(this.ELEMENT_DATA);
  
  constructor(private accountService: AccountService,private dialogRef: MatDialogRef<AdminComponent>,@Inject(MAT_DIALOG_DATA) public data:any) { }

  ngOnInit(): void {
    this.getUsersVet();
  }

  removeVet(id:number,user:User) {
    this.accountService.remVetClinic(id,user).subscribe(response => {
      this.suc = response['message'];
    setTimeout(() => {
      this.dialogRef.close();
    },1000);
  },
  error => {
    this.error = error['message'];
  });
  } 

  getUsersVet() {
    let resp = this.accountService.getUsersVet(this.data);
    resp.subscribe(report => { 
      this.dataSource.data = report ['data'] as User[];
    },
    error => this.error = error);    
  }

  onNoClick() {
    this.dialogRef.close();
  }
}
