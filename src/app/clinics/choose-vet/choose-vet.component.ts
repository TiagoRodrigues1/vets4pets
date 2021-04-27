import { Inject, ViewChild } from '@angular/core';
import { Component, OnInit } from '@angular/core';
import { MatDialog, MatDialogConfig, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { MatPaginator } from '@angular/material/paginator';
import { MatTableDataSource } from '@angular/material/table';
import { User } from 'src/app/models/user.model';
import { AccountService } from 'src/app/services/account.service';
import { CustomValidatorService } from 'src/app/services/custom-validator.service';
import { AppointmentComponent } from '../appointment/appointment.component';
import { ChoosePetComponent } from '../choose-pet/choose-pet.component';

@Component({
  selector: 'app-choose-vet',
  templateUrl: './choose-vet.component.html',
  styleUrls: ['./choose-vet.component.css']
})
export class ChooseVetComponent implements OnInit {
  @ViewChild(MatPaginator) paginator: MatPaginator;
  
  ELEMENT_DATA: User[] = [];
  displayedColumns:string[] = ['name','contact','email','button'];
  dataSource = new MatTableDataSource<User>(this.ELEMENT_DATA);


  constructor(private dialog: MatDialog, private accountService: AccountService, private dialogRef: MatDialogRef<ChoosePetComponent>,@Inject(MAT_DIALOG_DATA) public data:any) { }

  ngAfterViewInit() {
    this.dataSource.paginator = this.paginator;
  }

  ngOnInit(): void {
    this.getVets();
  }

  next(id:number) {
    //console.log(this.data);
    const dialogConfig = new MatDialogConfig();
    let ids:number[] = [this.data[0],this.data[1],id]; //0 - clinic 1 - Pet 2 - Vet
    dialogConfig.disableClose = false;
    dialogConfig.autoFocus = true;  
    dialogConfig.width = "35%"
    dialogConfig.data = ids; //id do vet
    this.dialog.open(AppointmentComponent,dialogConfig);
    this.dialogRef.close();
  }
  getVets() {
    //console.log(this.id);
    let resp = this.accountService.getVetByClinic(this.data[0]);
    resp.subscribe(report => this.dataSource.data = report['data'] as User[])
  }

  
}
