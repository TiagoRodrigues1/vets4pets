import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { ActivatedRoute, Router } from '@angular/router';
import { first } from 'rxjs/operators';
import { Appointment } from 'src/app/models/appointment.model';
import { AccountService } from 'src/app/services/account.service';
import { AlertService } from 'src/app/services/alert.service';
import { ChoosePetComponent } from '../choose-pet/choose-pet.component';

@Component({
  selector: 'app-appointment',
  templateUrl: './appointment.component.html',
  styleUrls: ['./appointment.component.css']
})
export class AppointmentComponent implements OnInit {
  form: FormGroup;
  currentYear:number =  new Date().getFullYear();
  currentDay:number = new Date().getDate();
  currentMonth:number = new Date().getMonth();
  d:Date;
  d1:Date;
  app: Appointment;
  public date:Date = new Date();
  public minDate:Date = new Date(this.currentYear,this.currentMonth,this.currentDay);
  public maxDate:Date = new Date(this.currentYear + 2,this.currentMonth,this.currentDay); //só deixa marcar para 2 anos á frente

  public minHour:Date = new Date(this.currentYear,this.currentMonth,this.currentDay,8);
  public maxHour:Date = new Date(this.currentYear,this.currentMonth,this.currentDay,19);


  constructor(private router: Router,private formBuilder: FormBuilder, private dialogRef: MatDialogRef<ChoosePetComponent>, @Inject(MAT_DIALOG_DATA) public data:any,private accountService: AccountService,private route: ActivatedRoute,private alertService:AlertService) { }

  ngOnInit(): void {
    this.form = this.formBuilder.group({
      date: ['', Validators.required],
      hour: ['',Validators.required],
    })
  }

  onSubmit() {
    this.alertService.clear();
    if(this.form.invalid) {

      return;
    }
    this.d = this.form.get('date').value; //atribuir o valo á data
    this.d1 = this.form.get('hour').value;
    
    this.d.setHours(this.d1.getHours());
    this.d.setMinutes(this.d1.getMinutes());
    this.app = new Appointment(this.data[1],this.data[2],this.d);
    this.accountService.createAppointment(this.app).pipe(first()).subscribe({
      next:() => {
        this.router.navigate([`../clinic/${this.data[0]}`],{relativeTo: this.route});
        this.displaySuccess("Appointment Created, Check your appointments on yor profile");
      }
    });
    //console.log(this.app); // 0 - Id da Clinica % 1 - Id do Pet % 2 - Id do Veterinario
    this.onClose();
  }
  onClose() {
    this.form.reset();
    this.dialogRef.close();
  }

  onNoClick() {
    this.dialogRef.close();
  }

  private displayError(message: string) {
    this.alertService.error(message,
      { autoClose: true }
    );
  }

  private displaySuccess(message:string) {
    this.alertService.success(message,
      { autoClose: false }
    );
  }

}
