import { Component, OnInit, QueryList, ViewChild, ViewChildren } from '@angular/core';
import { MatDialog, MatDialogConfig } from '@angular/material/dialog';
import { MatPaginator } from '@angular/material/paginator';
import { MatSort } from '@angular/material/sort';
import { MatTableDataSource } from '@angular/material/table';
import { Clinic } from 'src/app/models/clinic.model';
import { User } from 'src/app/models/user.model';
import { AccountService } from 'src/app/services/account.service';
import { AdminService } from 'src/app/services/admin.service';
import { AddClinicComponent } from './add-clinic/add-clinic.component';
import { AddVetClinicComponent } from './add-vet-clinic/add-vet-clinic.component';
import { EditUserComponent } from './edit-user/edit-user.component';
import { RemoveVetClinicComponent } from './remove-vet-clinic/remove-vet-clinic.component';


@Component({
  selector: 'app-admin',
  templateUrl: './admin.component.html',
  styleUrls: ['./admin.component.css']
})
export class AdminComponent implements OnInit {
  @ViewChildren(MatPaginator) paginator = new QueryList<MatPaginator>();
  @ViewChildren(MatSort) sort = new QueryList<MatSort>();
  status: string;

  ELEMENT_DATA: Clinic[] = [];
  displayedColumns:string[] = ['name','contact','email','address','addVet','removeVet','delete/edit'];
  dataSource = new MatTableDataSource<Clinic>(this.ELEMENT_DATA);


  ELEMENT_DATAUser: User[] = [];
  displayedColumnsUser:string [] = ['name','contact','email','username','userType','delete/edit'];
  dataSourceUser = new MatTableDataSource<User>(this.ELEMENT_DATAUser);

  constructor(private accountService: AccountService,private adminService: AdminService,private dialog: MatDialog) { }

  ngOnInit(): void {
    this.getClinics();
    this.getUsers();
  }

  ngAfterViewInit() {
    this.dataSource.paginator = this.paginator.toArray()[0];
    this.dataSource.sort = this.sort.toArray()[0];
    this.dataSourceUser.paginator = this.paginator.toArray()[1];
    this.dataSource.sort = this.sort.toArray()[1];
  }

  getClinics() {
    let resp = this.accountService.getClinics();
    resp.subscribe(report => this.dataSource.data = report['data'] as Clinic[]);
  }

  onCreate() {
    this.adminService.form.reset();
    const dialogConfig = new MatDialogConfig();
    dialogConfig.autoFocus = true;  
    dialogConfig.disableClose = true;
    dialogConfig.width = "35%"
    this.dialog.open(AddClinicComponent,dialogConfig);
  }

  editClinic(clinic) {
    this.adminService.populateForm(clinic);
    const dialogConfig = new MatDialogConfig();
    dialogConfig.autoFocus = true;  
    dialogConfig.disableClose = true;
    dialogConfig.width = "35%"
    this.dialog.open(AddClinicComponent,dialogConfig);
  }

  deleteClinic(id:number) {
    this.accountService.deleteClinic(id).subscribe(() => this.status = 'Delete Sucessful');
    window.location.reload();
  }

  getUsers() {
    let resp = this.accountService.getUsers();
    resp.subscribe(report => this.dataSourceUser.data = report ['data'] as User[]);    
  }
 
  editUser(user:User) {
    const dialogConfig = new MatDialogConfig();
    dialogConfig.autoFocus = true;  
    dialogConfig.disableClose = true;
    dialogConfig.width = "35%"
    dialogConfig.data = user;
    this.dialog.open(EditUserComponent,dialogConfig);
  }

  addVet(idClinic:number) {
    const dialogConfig = new MatDialogConfig();
    dialogConfig.autoFocus = true;  
    dialogConfig.disableClose = true;
    dialogConfig.width = "50%"
    dialogConfig.data = idClinic;
    this.dialog.open(AddVetClinicComponent,dialogConfig);
  }
  removeVet(idClinic:number) {
    const dialogConfig = new MatDialogConfig();
    dialogConfig.autoFocus = true;  
    dialogConfig.disableClose = true;
    dialogConfig.width = "50%"
    dialogConfig.data = idClinic;
    this.dialog.open(RemoveVetClinicComponent,dialogConfig);
  }
}