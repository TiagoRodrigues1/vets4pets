import { Component, OnDestroy, OnInit } from '@angular/core';
import { MatDialog, MatDialogConfig } from '@angular/material/dialog';
import { ActivatedRoute } from '@angular/router';
import { Clinic } from 'src/app/models/clinic.model';
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

  constructor(private dialog: MatDialog,private route: ActivatedRoute) { 
  
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
    dialogConfig.disableClose = true;
    dialogConfig.autoFocus = true;  
    dialogConfig.width = "60%";
    dialogConfig.data = this.id;
    this.dialog.open(ChoosePetComponent,dialogConfig);  
  }

  ngOnDestroy() {
    this.sub.unsubscribe();
  }

}
