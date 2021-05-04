import { Component, Inject, OnInit, ViewChild } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { MatPaginator } from '@angular/material/paginator';
import { MatTableDataSource } from '@angular/material/table';
import { catchError } from 'rxjs/operators';
import { Vaccines } from 'src/app/models/vaccines';
import { AccountService } from 'src/app/services/account.service';

@Component({
  selector: 'app-show-vaccines',
  templateUrl: './show-vaccines.component.html',
  styleUrls: ['./show-vaccines.component.css']
})
export class ShowVaccinesComponent implements OnInit {
  @ViewChild(MatPaginator) paginator: MatPaginator;
  ELEMENT_DATA: Vaccines[] = [];
  displayedColumns:string[] = ['vaccineName','date','taken','dateTaken','validity'];
  dataSource = new MatTableDataSource<Vaccines>(this.ELEMENT_DATA);
  constructor(private accountService: AccountService, private dialogRef:MatDialogRef<Vaccines>,@Inject(MAT_DIALOG_DATA) public data:any) { }

  ngOnInit(): void {
    this.getVaccines();
  }
  ngAfterViewInit() {
    this.dataSource.paginator = this.paginator;
  }

  getVaccines() {
    let resp = this.accountService.getVaccinesByPet(this.data);
    resp.subscribe(
      report => this.dataSource.data = report['data'] as Vaccines[])
  }

  onClose() {
    this.dialogRef.close();
  }
}
