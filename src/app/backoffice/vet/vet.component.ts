import { HttpErrorResponse } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { MatDialog, MatDialogConfig } from '@angular/material/dialog';
import { CalendarOptions, EventClickArg } from '@fullcalendar/angular';
import { Appointment } from 'src/app/models/appointment.model';
import { AccountService } from 'src/app/services/account.service';
import { CustomValidatorService } from 'src/app/services/custom-validator.service';
import { ManageAppointmentComponent } from './manage-appointment/manage-appointment.component';

@Component({
  selector: 'app-vet',
  templateUrl: './vet.component.html',
  styleUrls: ['./vet.component.css']
})
export class VetComponent implements OnInit {
  calendarOptions: CalendarOptions;
  eventstest = [{
    id: null,
    start: null,
    title: null,
    allday:false,
  }];
  app: Appointment[];
  name:string;
  date:string;

  constructor(private accountService: AccountService, private val: CustomValidatorService,private dialog: MatDialog) { }

  ngOnInit(): void {
    this.getAppointments();    
  }

  getAppointments() {
    this.accountService.getAppointmentByVet(this.val.getUserId()).subscribe(
      (response: Appointment[]) => {
      this.app = response['data'];      
      this.app.forEach(appoitment => this.eventstest.push({start:appoitment.date,title:"Consulta",allday:false,id:appoitment.AnimalID})); // precisar de passar a endDate depois
      this.calendarOptions = {
      initialView: 'dayGridMonth',
      height: '850px',
      events: this.eventstest,
      eventColor:'#52b788',
      eventClick:this.eventClick.bind(this),
      eventTimeFormat: {
        hour: '2-digit',
        minute: '2-digit',
        hour12: false,
      },
    };
    },
    (error: HttpErrorResponse) => {
      alert(error.message);
    });
  }

  eventClick(info:EventClickArg) {
    const dialogConfig = new MatDialogConfig();
    dialogConfig.disableClose = true;
    dialogConfig.autoFocus = true;  
    dialogConfig.width = "35%"
    dialogConfig.data = info.event;
    this.dialog.open(ManageAppointmentComponent,dialogConfig);
  }
}