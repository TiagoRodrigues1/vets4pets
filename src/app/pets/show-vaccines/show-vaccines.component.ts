import { Component, Inject, OnInit, ViewChild } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { MatPaginator } from '@angular/material/paginator';
import { MatTableDataSource } from '@angular/material/table';
import { Vaccines } from 'src/app/models/vaccines';
import { AccountService } from 'src/app/services/account.service';

@Component({
  selector: 'app-show-vaccines',
  templateUrl: './show-vaccines.component.html',
  styleUrls: ['./show-vaccines.component.css']
})
export class ShowVaccinesComponent implements OnInit {
  error:string;
  constructor(private accountService: AccountService, private dialogRef:MatDialogRef<Vaccines>,@Inject(MAT_DIALOG_DATA) public data:any) { }
  vac:Vaccines[] = [];
  titleSelected;
  ngOnInit(): void {
    this.getVaccines();
  }

  getVaccines() {
    let resp = this.accountService.getVaccinesByPet(this.data);
    resp.subscribe(
      report => {this.vac = report['data'] as Vaccines[];
      if(this.vac.length == 0)  {
        this.error = "You dont have any Vaccines";
      } 
    });
  }

  onClose() {
    this.dialogRef.close();
  }
}
