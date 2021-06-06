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
import { ThemePalette } from '@angular/material/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';



@Component({
  selector: 'app-myadoptions',
  templateUrl: './myadoptions.component.html',
  styleUrls: ['./myadoptions.component.css']
})

export class MyadoptionsComponent implements OnInit {
  ELEMENT_DATA : Adoption[]=[];
  dataSource = new MatTableDataSource<Adoption>(this.ELEMENT_DATA);
  status: string;
  displayedColumns: string[] = ['id','profilePicture', 'name', 'animaltype', 'race','delete/edit'];
  user: User;
  string : string;
  color: ThemePalette = 'accent';
  disabled = false;
  aux:boolean;

  payload;
  form:FormGroup;
  constructor(private accountService: AccountService,private dialog: MatDialog, private adoptionService: AdoptionService, private formBuilder:FormBuilder) { 
    this.form = this.formBuilder.group({
      adoption: ['',Validators.required],
  });
  
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

  cancelAdoption(element:Adoption) {
    if(element.adopted != this.form.get('adoption').value) {
      element.adopted = this.form.get('adoption').value;
      this.accountService.EditAdoption(element.ID,element).subscribe();
      this.ELEMENT_DATA.forEach(err => { 
        if(err == element) {
        err.adopted = !element.adopted    
      }});
    }
  }
  
 public adoptions()  {
  let resp =  this.accountService.getAdoptions(this.getUserId());
  resp.subscribe(report => {this.dataSource.data = report['data'] as Adoption[];})
  
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
    dialogConfig.disableClose = true;
    dialogConfig.autoFocus = false;  
    dialogConfig.width = "40%"
    dialogConfig.height = "90%"
    this.dialog.open(AddadoptionComponent,dialogConfig);
  }

  editAdoption(adoption) {
    this.adoptionService.populateForm(adoption);
    const dialogConfig = new MatDialogConfig();
    dialogConfig.disableClose = false;
    dialogConfig.autoFocus = true;  
    dialogConfig.width = "40%"
    dialogConfig.height = "80%"
    this.dialog.open(AddadoptionComponent,dialogConfig);
  }

  displayAdoption(adoption:Adoption){
    const dialogConfig = new MatDialogConfig();
    dialogConfig.disableClose = true;
    dialogConfig.autoFocus = true;  
    dialogConfig.width = "40%"
    dialogConfig.height = "85%"
    dialogConfig.data=adoption;
   
    this.dialog.open(DisplayadoptionComponent,dialogConfig);
  }

  deleteAdoption(id:number) {
    this.accountService.deleteAdoption(id).subscribe(() => this.status = 'Delete Sucessful');
    setTimeout(() => {
      window.location.reload();
    },500);

  }

  refresh() {
    window.location.reload();
  }
}
