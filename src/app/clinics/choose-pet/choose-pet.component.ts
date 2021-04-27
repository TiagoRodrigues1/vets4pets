import { Component, Inject, OnInit, ViewChild } from '@angular/core';
import { MatDialog, MatDialogConfig, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { AccountService } from 'src/app/services/account.service';
import { CustomValidatorService } from 'src/app/services/custom-validator.service';
import { AppointmentComponent } from '../appointment/appointment.component';

import { Pet } from 'src/app/models/pet.model';
import { MatTableDataSource } from '@angular/material/table';
import { MatPaginator } from '@angular/material/paginator';
import { ChooseVetComponent } from '../choose-vet/choose-vet.component';
import { User } from 'src/app/models/user.model';

@Component({
  selector: 'app-choose-pet',
  templateUrl: './choose-pet.component.html',
  styleUrls: ['./choose-pet.component.css']
})

export class ChoosePetComponent implements OnInit {
  @ViewChild(MatPaginator) paginator: MatPaginator;

  ELEMENT_DATA: Pet[] = [];
  displayedColumns:string[] = ['name','race','animaltype','button'];
  dataSource = new MatTableDataSource<Pet>(this.ELEMENT_DATA);
  string: string;
  user: User;
  payload: any;
  constructor(private dialog: MatDialog,private dialogRef: MatDialogRef<AppointmentComponent>, private accountService: AccountService,@Inject(MAT_DIALOG_DATA) public data:any) { }
  
  ngAfterViewInit() {
    this.dataSource.paginator = this.paginator;
  }

  ngOnInit(): void {
    this.getPets();
  }
  
  next(id:number) {
    let ids:number [] = [this.data,id];
    const dialogConfig = new MatDialogConfig();
    dialogConfig.disableClose = false;
    dialogConfig.autoFocus = true;  
    dialogConfig.width = "60%"
    dialogConfig.data = ids; //0 id da clinica - 1 id do animal
    this.dialog.open(ChooseVetComponent,dialogConfig);
    this.dialogRef.close();
  }

  getPets() {
    let resp = this.accountService.getPets(this.getUserId());
    resp.subscribe(report => this.dataSource.data = report['data'] as Pet[])
  }
  getUserId()  {
    this.string = localStorage.getItem('user');
    this.user = (JSON.parse(this.string));
    if (this.user.token) {
      this.payload = this.user.token.split(".")[1];
      this.payload = window.atob(this.payload);
      const userString =  JSON.parse(this.payload);
      return parseInt(userString.UserID);
    } 
  }
}
