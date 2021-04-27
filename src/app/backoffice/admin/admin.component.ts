import { Component, OnInit, ViewChild } from '@angular/core';
import { MatDialog, MatDialogConfig } from '@angular/material/dialog';
import { MatPaginator } from '@angular/material/paginator';
import { MatTableDataSource } from '@angular/material/table';
import { Clinic } from 'src/app/models/clinic.model';
import { AccountService } from 'src/app/services/account.service';
import { AdminService } from 'src/app/services/admin.service';
import { AddClinicComponent } from './add-clinic/add-clinic.component';

@Component({
  selector: 'app-admin',
  templateUrl: './admin.component.html',
  styleUrls: ['./admin.component.css']
})
export class AdminComponent implements OnInit {
  @ViewChild(MatPaginator) paginator: MatPaginator;
  status: string;

  ELEMENT_DATA: Clinic[] = [];
  displayedColumns:string[] = ['name','contact','email','address','delete/edit'];
  dataSource = new MatTableDataSource<Clinic>(this.ELEMENT_DATA);
  constructor(private accountService: AccountService,private adminService: AdminService,private dialog: MatDialog) { }

  ngOnInit(): void {
    this.getClinics();
  }
  ngAfterViewInit() {
    this.dataSource.paginator = this.paginator;
  }

  getClinics() {
    let resp = this.accountService.getClinics();
    resp.subscribe(report => this.dataSource.data = report['data'] as Clinic[]);
  }

  onCreate() {
    this.adminService.form.reset();
    const dialogConfig = new MatDialogConfig();
    dialogConfig.disableClose = false;
    dialogConfig.autoFocus = true;  
    dialogConfig.disableClose = true;
    dialogConfig.width = "35%"
    this.dialog.open(AddClinicComponent,dialogConfig);
  }

  editClinic(clinic) {
    this.adminService.populateForm(clinic);
    const dialogConfig = new MatDialogConfig();
    dialogConfig.disableClose = false;
    dialogConfig.autoFocus = true;  
    dialogConfig.disableClose = true;
    dialogConfig.width = "35%"
    this.dialog.open(AddClinicComponent,dialogConfig);
  }

  deleteClinic(id:number) {
    this.accountService.deleteClinic(id).subscribe(() => this.status = 'Delete Sucessful');
    window.location.reload();
  }
}

