import { Component, OnInit, ViewChild } from '@angular/core';
import { MatDialog, MatDialogConfig } from '@angular/material/dialog';
import { MatPaginator } from '@angular/material/paginator';
import { MatSort } from '@angular/material/sort';
import { MatTableDataSource } from '@angular/material/table';
import { Adoption } from 'src/app/models/adoption.model';
import { User } from 'src/app/models/user.model';
import { AccountService } from 'src/app/services/account.service';
import { DisplayadoptionComponent } from '../displayadoption/displayadoption.component';

interface Headers {
  name: string;
  click: string;
}

@Component({
  selector: 'app-lastadoptions',
  templateUrl: './lastadoptions.component.html',
  styleUrls: ['./lastadoptions.component.css']
})
export class LastadoptionsComponent implements OnInit {

  ELEMENT_DATA : Adoption[]=[];
  dataSource = new MatTableDataSource<Adoption>(this.ELEMENT_DATA);
  displayedColumns: string[] = ['name','profilePicture', 'animaltype', 'race','birth'];
  user: User;
  string : string;
  payload;

  constructor(private accountService: AccountService,private dialog: MatDialog) { 
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
  let resp =  this.accountService.getRecentAdoptions();
  resp.subscribe(report => this.dataSource.data = report['data'] as Adoption[])
}
  
  refresh() {
    window.location.reload();
  }

  displayAdoption(adoption:Adoption){
     const dialogConfig = new MatDialogConfig();
     dialogConfig.disableClose = true;
     dialogConfig.autoFocus = false;  
     dialogConfig.width = "40%"
     dialogConfig.height = "85%"
     dialogConfig.data=adoption;
     console.log(adoption);
     this.dialog.open(DisplayadoptionComponent,dialogConfig);
   }


}
