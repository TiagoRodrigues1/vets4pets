import { AfterViewInit, Component, OnInit } from '@angular/core';
import { MatDialog, MatDialogConfig } from '@angular/material/dialog';
import { CalendarOptions, EventClickArg } from '@fullcalendar/angular'; 
import { Appointment } from 'src/app/models/appointment.model';
import { AccountService } from 'src/app/services/account.service';
import { CustomValidatorService } from 'src/app/services/custom-validator.service';
import { AppointmentDetailsComponent } from '../appointment-details/appointment-details.component';

@Component({
  selector: 'app-display-appointment',
  templateUrl: './display-appointment.component.html',
  styleUrls: ['./display-appointment.component.css']
})
export class DisplayAppointmentComponent implements OnInit,AfterViewInit {
  calendarOptions: CalendarOptions;
  error:string;
  eventstest = [{
    id: null,
    start: null,
    title: null,
    allday:false,
  }];
  app: Appointment[];
  loading:boolean = true;
  isDisabled = true;
  constructor(private accountService: AccountService, private val: CustomValidatorService, private dialog: MatDialog) { }

  ngOnInit(): void {
    
  }

  ngAfterViewInit() {
    setTimeout(() => {
    this.getAppointments();
    this.loading = false;
    }, 1000);
  }

  getAppointments() {
    this.accountService.getAppointmentsUser(this.val.getUserId()).subscribe(
      (response: Appointment[]) => {
      this.app = response['data'];      
      this.app.forEach(appoitment => this.eventstest.push({start:appoitment.date,title:"Doctors Appointment",allday:false,id:appoitment.AnimalID})); // precisar de passar a endDate depois
      this.calendarOptions = {
      initialView: 'dayGridMonth',
      height: '850px',
      dayMaxEventRows:true,
      events: this.eventstest,
      eventColor:'#52b788',
      headerToolbar: {
        left : 'prev next today',
        center :'title',
        right: 'dayGridMonth dayGridWeek dayGridDay'
      },
      views: {
        timeGrid:{
          dayMaxEventRows:6
        }
      },
      eventClick:this.eventClick.bind(this),
      eventTimeFormat: {
        hour: '2-digit',
        minute: '2-digit',
        hour12: false,
      },
    };
    },
    error => {
      this.error = "You don't have any appointments";
    });
  }

  eventClick(info:EventClickArg) {
    console.log(info.event.id);
    const dialogConfig = new MatDialogConfig();
    dialogConfig.disableClose = false;
    dialogConfig.autoFocus = true;  
    dialogConfig.width = "35%"
    dialogConfig.data = info.event;
    this.dialog.open(AppointmentDetailsComponent,dialogConfig);
  }
}
