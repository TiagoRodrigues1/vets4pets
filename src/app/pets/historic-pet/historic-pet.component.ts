import { Component, Inject, OnInit } from '@angular/core';
import { MatDialog, MatDialogConfig, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Prescription } from 'src/app/models/prescription.model';
import { AccountService } from 'src/app/services/account.service';
import { AppointmentDetailsComponent } from 'src/app/user/appointment-details/appointment-details.component';
import { UserProfileComponent } from 'src/app/user/user-profile/user-profile.component';
import { HistoricDetailsComponent } from '../historic-details/historic-details.component';

@Component({
  selector: 'app-historic-pet',
  templateUrl: './historic-pet.component.html',
  styleUrls: ['./historic-pet.component.css']
})
export class HistoricPetComponent implements OnInit {
  loading:boolean = true;
  presc:Prescription[];
  errorPrescApi:string;
  titleSelected;

  constructor(private accountService:AccountService,@Inject(MAT_DIALOG_DATA) public data: any,private dialogRef:MatDialogRef<UserProfileComponent>,private dialog: MatDialog) { }

  ngOnInit(): void {
    this.getPrescriptions();
  }

  getPrescriptions() {
    let resp = this.accountService.getPrescription(this.data.ID);
    resp.subscribe(report => { this.presc = report['data'] as Prescription[]; this.loading = false; },
      error => this.errorPrescApi = error);
  }

  onNoClick() {
    this.dialogRef.close();
  }
  
  showDetails(pres:Prescription) {
      const dialogConfig = new MatDialogConfig();
      dialogConfig.disableClose = true;
      dialogConfig.autoFocus = true;  
      dialogConfig.width = "35%"
      dialogConfig.height = "91%"
      dialogConfig.data = pres;
      this.dialog.open(HistoricDetailsComponent,dialogConfig);
  }

}
