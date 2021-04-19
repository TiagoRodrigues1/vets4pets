import { Component, OnInit, ViewChild } from '@angular/core';
import { MatDialog, MatDialogConfig, MatDialogRef } from '@angular/material/dialog';
import { AccountService } from 'src/app/services/account.service';
import { CustomValidatorService } from 'src/app/services/custom-validator.service';
import { AppointmentComponent } from '../appointment/appointment.component';

import { Pet } from 'src/app/models/pet.model';
import { MatTableDataSource } from '@angular/material/table';
import { MatPaginator } from '@angular/material/paginator';

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
  constructor(private dialog: MatDialog,private dialogRef: MatDialogRef<AppointmentComponent>, private accountService: AccountService,private val: CustomValidatorService) { }
  
  ngAfterViewInit() {
    this.dataSource.paginator = this.paginator;
  }

  ngOnInit(): void {
    this.getPets();
  }
  next() {
    const dialogConfig = new MatDialogConfig();
    dialogConfig.disableClose = false;
    dialogConfig.autoFocus = true;  
    dialogConfig.width = "35%"
    this.dialog.open(AppointmentComponent,dialogConfig);
    this.dialogRef.close();
  }

  getPets() {
    let resp = this.accountService.getPets(this.val.getUserId());
    resp.subscribe(report => this.dataSource.data = report['data'] as Pet[])
  }
}
