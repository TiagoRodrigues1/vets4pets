import { Component, OnDestroy, OnInit } from '@angular/core';
import { MatDialog, MatDialogConfig, MatDialogRef } from '@angular/material/dialog';
import { ActivatedRoute } from '@angular/router';
import { filter } from 'rxjs/operators';
import { Clinic } from 'src/app/models/clinic.model';
import { AlertService } from 'src/app/services/alert.service';
import { AppointmentComponent } from '../appointment/appointment.component';
import { ChoosePetComponent } from '../choose-pet/choose-pet.component';

@Component({
  selector: 'app-clinic-profile',
  templateUrl: './clinic-profile.component.html',
  styleUrls: ['./clinic-profile.component.css']
})
export class ClinicProfileComponent implements OnInit,OnDestroy {
  clinic: Clinic;
  currentUrl: string;
  previousUrl: string;
  id: number;
  private sub: any;

  constructor(private dialog: MatDialog,private route: ActivatedRoute, private alertService: AlertService) { 
  
  }

  ngOnInit(): void {
    if(history.state.data) {
    this.clinic = history.state.data;
    sessionStorage.setItem('clinicInfo',JSON.stringify(this.clinic)); //guradar na sessão para não desaparecer
  } else {
    this.clinic = JSON.parse(sessionStorage.getItem('clinicInfo'));
  }
  this.sub = this.route.params.subscribe(params => {
    this.id = +params['id']; // (+) converts string 'id' to a number    
 });

}

  makeAppointment() {
    const dialogConfig = new MatDialogConfig();
    dialogConfig.disableClose = false;
    dialogConfig.autoFocus = true;  
    dialogConfig.width = "60%";
    dialogConfig.data = this.id;
    this.dialog.open(ChoosePetComponent,dialogConfig);  
  }

  ngOnDestroy() {
    this.sub.unsubscribe();
  }

  private displayError(message: string) {
    this.alertService.error(message,
      { autoClose: true }
    );
  }

  private displaySuccess(message:string) {
    console.log(message)
    this.alertService.success(message,
      { autoClose: false }
    );
  }
}
