import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatDialogRef } from '@angular/material/dialog';
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
  public date:Date = new Date();
  public minDate:Date = new Date(this.currentYear,this.currentMonth,this.currentDay);
  public maxDate:Date = new Date(this.currentYear + 2,this.currentMonth,this.currentDay); //só deixa marcar para 2 anos á frente
  constructor(private formBuilder: FormBuilder, private dialogRef: MatDialogRef<ChoosePetComponent>) { }

  ngOnInit(): void {
    this.form = this.formBuilder.group({
      date: ['', Validators.required],
    })
  }

  onSubmit() {
    if(this.form.valid) {console.log(this.form.value);}
    
    this.onClose();
  }

  onClose() {
    this.form.reset();
    this.dialogRef.close();
  
  }
}
