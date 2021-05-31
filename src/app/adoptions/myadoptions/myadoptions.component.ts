import { Component, OnInit,ViewChild,AfterViewInit } from '@angular/core';
import { MatTableDataSource } from '@angular/material/table';
import { User } from 'src/app/models/user.model';
import { Adoption } from 'src/app/models/adoption.model';
import { AccountService } from 'src/app/services/account.service';
import {MatPaginator} from '@angular/material/paginator';
import { MatSort } from '@angular/material/sort';
import { MatDialog, MatDialogConfig } from '@angular/material/dialog';
import { AddadoptionComponent } from '../addadoption/addadoption.component';
import {DisplayadoptionComponent} from '../displayadoption/displayadoption.component'
import { AdoptionService } from 'src/app/services/adoption.service';



@Component({
  selector: 'app-myadoptions',
  templateUrl: './myadoptions.component.html',
  styleUrls: ['./myadoptions.component.css']
})

export class MyadoptionsComponent implements OnInit {
  ELEMENT_DATA : Adoption[]=[];
  dataSource = new MatTableDataSource<Adoption>(this.ELEMENT_DATA);
  status: string;
  displayedColumns: string[] = ['id', 'name', 'animaltype', 'race','delete/edit'];
  user: User;
  string : string;
  payload;
  
  

  constructor(private accountService: AccountService,private dialog: MatDialog, private adoptionService: AdoptionService) { 
  }

  @ViewChild(MatPaginator) paginator: MatPaginator;
  @ViewChild(MatSort) sort: MatSort;

  ngAfterViewInit() {
    this.dataSource.sort = this.sort;
    this.dataSource.paginator = this.paginator;
  }

  ngOnInit(): void {
    this.adoptions();
  }


 public adoptions()  {
  let resp =  this.accountService.getAdoptions(this.getUserId());
  resp.subscribe(report => this.dataSource.data = report['data'] as Adoption[])
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

  onCreate() {
    const dialogConfig = new MatDialogConfig();
    dialogConfig.disableClose = false;
    dialogConfig.autoFocus = true;  
    dialogConfig.width = "55%"
    dialogConfig.height = "80%"
    this.dialog.open(AddadoptionComponent,dialogConfig);
  }

  editAdoption(adoption) {
    this.adoptionService.populateForm(adoption);
    const dialogConfig = new MatDialogConfig();
    dialogConfig.disableClose = false;
    dialogConfig.autoFocus = true;  
    dialogConfig.width = "55%"
    dialogConfig.height = "80%"
    this.dialog.open(AddadoptionComponent,dialogConfig);
  }

  displayAdoption(adoption:Adoption){
   // console.log(id);
    const dialogConfig = new MatDialogConfig();
    dialogConfig.disableClose = false;
    dialogConfig.autoFocus = true;  
    dialogConfig.width = "55%"
    dialogConfig.height = "80%"
    dialogConfig.data=adoption;
   
    this.dialog.open(DisplayadoptionComponent,dialogConfig);
  }

  deleteAdoption(id:number) {
    this.accountService.deleteAdoption(id).subscribe(() => this.status = 'Delete Sucessful');
    window.location.reload();
  }

  refresh() {
    window.location.reload();
  }
}
