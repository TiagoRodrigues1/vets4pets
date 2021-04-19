import { Component, OnInit } from '@angular/core';
import { MatDialog, MatDialogConfig } from '@angular/material/dialog';
import { Clinic } from 'src/app/models/clinic.model';
import { ChoosePetComponent } from '../choose-pet/choose-pet.component';

@Component({
  selector: 'app-clinic-profile',
  templateUrl: './clinic-profile.component.html',
  styleUrls: ['./clinic-profile.component.css']
})
export class ClinicProfileComponent implements OnInit {
  clinic: Clinic;
  currentUrl: string;
  previousUrl: string;
  constructor(private dialog: MatDialog) { 
  }

  ngOnInit(): void {
    if(history.state.data) {
    this.clinic = history.state.data;
    sessionStorage.setItem('clinicInfo',JSON.stringify(this.clinic)); //guradar na sessão para não desaparecer
  } else {
    this.clinic = JSON.parse(sessionStorage.getItem('clinicInfo'));
  }
}

  makeAppointment() {
    const dialogConfig = new MatDialogConfig();
    dialogConfig.disableClose = false;
    dialogConfig.autoFocus = true;  
    dialogConfig.width = "60%"
    this.dialog.open(ChoosePetComponent,dialogConfig);
  }
}
