import { Component, Inject, OnInit, ViewChild } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { AccountService } from 'src/app/services/account.service';

import { Pet } from 'src/app/models/pet.model';
import { MatPaginator } from '@angular/material/paginator';
import { User } from 'src/app/models/user.model';
import { STEPPER_GLOBAL_OPTIONS } from '@angular/cdk/stepper';
import {  FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { Appointment } from 'src/app/models/appointment.model';
import { CustomValidatorService } from 'src/app/services/custom-validator.service';
import { ClinicProfileComponent } from '../clinic-profile/clinic-profile.component';
import { first } from 'rxjs/operators';

@Component({
  selector: 'app-choose-pet',
  templateUrl: './choose-pet.component.html',
  styleUrls: ['./choose-pet.component.css'],
  providers:[{
    provide:  STEPPER_GLOBAL_OPTIONS,
    useValue: { showError: true }
  }]
})

export class ChoosePetComponent implements OnInit {
  @ViewChild(MatPaginator) paginator: MatPaginator;
  select; //id do pet
  selectVet; //id do vet
  pets: Pet[] = []; //lista de pets user
  vets:User[] = []; //lista de vets clinica
  vet:User;
  pet:Pet; 
  startDate:Date;
  apps:Appointment[] = [];
  string: string; //para ajudar no token
  user: User; //ajudar no token
  payload: any; //ajudar no token
  selected = false; // se o pet tiver selecionado
  selectedVet = false; //se o pet tiver selecionado
  error:string; //erro do pet
  errorVet:string; //erro do vet 
  errorAppApi:string;
  isEditable = true; //se dá para ir para trás ou não
  suc:string; //se o appintment foi bem sucedido
  valid = new FormControl(); // para ver se o pet foi selecionado
  valid2 = new FormControl(); //para ver o vet foi selecionado
  form:FormGroup; //form para o appointment
  currentYear:number =  new Date().getFullYear();
  currentDay:number = new Date().getDate();
  currentMonth:number = new Date().getMonth();
  app:Appointment;
  d:Date;
  d1:Date;
  loading = true;
  public date:Date = new Date();
  public minDate:Date = new Date(this.currentYear,this.currentMonth,this.currentDay);
  public maxDate:Date = new Date(this.currentYear + 2,this.currentMonth,this.currentDay); //só deixa marcar para 2 anos á frente

  public minHour:Date = new Date(this.currentYear,this.currentMonth,this.currentDay,8);
  public maxHour:Date = new Date(this.currentYear,this.currentMonth,this.currentDay,19);
  errorPetApi:string;
  errorVetApi:string;
  
  constructor(private formBuilder: FormBuilder, private accountService: AccountService,@Inject(MAT_DIALOG_DATA) public data:any, private val:CustomValidatorService,private dialogRef: MatDialogRef<ClinicProfileComponent>) { 
    this.setState(this.valid,true);
    this.setState(this.valid2,true);
  }
  
  ngOnInit(): void {
    this.getPets();
    this.getVets();
    this.form = this.formBuilder.group({
      date: ['',Validators.required ],
      hour: ['',Validators.required], 
      updateOn: 'blur',
    },
    {validator: this.appointmentExists().bind(this)}
    );  
  }

  getPets() {
    let resp = this.accountService.getPets(this.val.getUserId());
    resp.subscribe(report => 
      {this.pets  = report['data'] as Pet[]; this.loading = false;},
      error => this.errorPetApi = error);
    
    
  }

  getVets() {
    let resp = this.accountService.getVetByClinic(this.data);
    resp.subscribe(report => { this.vets = report['data'] as User[];},error =>  this.errorVetApi = error);
  }

  getVetAppointments() {
    let resp = this.accountService.getAppointmentByVet2(this.selectVet);
    resp.subscribe(report => {this.apps = report['data'] as Appointment[];},  error => this.errorAppApi = error)
  }

  onSelectCardVet(event:any, id:any,control:FormControl,state:boolean, vet:User) {
    if(this.selectVet != id) { //quer dizer que é um novo que selcionei
      this.selectVet = id;
      this.selectedVet = false;
      this.errorVet = null;
      this.vet = vet;
      control.reset();
    } else { //
      this.selectVet = null;
      this.errorVet = "Please Select a Vet first";
      control.setErrors({"required":true})
    }
    this.selectedVet = !this.selectedVet;
    console.log(this.selectVet);
    }

    onSelectCard(event:any, id:any,control:FormControl,state:boolean) {
      if(this.select != id) { //quer dizer que é um novo que selcionei
        this.select = id;
        this.selected = false;
        this.error = null;
        control.reset();
      } else { //
        this.select = null;
        this.error = "Please Select a Pet first";
        control.setErrors({"required":true})
      }
      this.selected = !this.selected;
      }

  setState(control:FormControl,state:boolean) {
    if(state) {
      control.setErrors({"required":true})
    } else {
      control.reset();
    }
  }

   onSubmit() {
      this.errorAppApi = '';
    if(this.form.invalid) {
      return;
    }

    this.d = this.form.get('date').value; //atribuir o valo á data
    this.d1 = this.form.get('hour').value;
    
    this.d.setHours(this.d1.getHours());
    this.d.setMinutes(this.d1.getMinutes());
    this.app = new Appointment(this.select,this.selectVet,this.d);
    this.accountService.createAppointment(this.app).pipe(first()).subscribe({
      next:() => {
        //this.router.navigate([`../clinic/${this.data[0]}`],{relativeTo: this.route});
        this.suc = 'Your Appointment was created, check your profile to see all of your appointments';
        this.form.controls.date.setErrors(null);
        this.form.controls.hour.setErrors(null);
        this.isEditable = false;
        this.startDate = this.d;
      }, error: error => {
        this.errorAppApi = error;
        this.form.controls.date.setErrors({'appointmentExists':true});
        this.form.controls.hour.setErrors({'appointmentExists':true});
      }
    }); 
     
  } 

  appointmentExists = () => {
    return(formGroup: FormGroup) => {
      const dateControl = formGroup.controls.date;
      const hourControl = formGroup.controls.hour;
    
      if(!dateControl || !hourControl) {
        return null;
      }

      if(dateControl.errors && !dateControl.errors.appointmentExists) {
        return null;
      }

      if(dateControl.value && hourControl.value) {
        this.d = dateControl.value;
        this.d1 = hourControl.value;
        this.d.setHours(this.d1.getHours());
        this.d.setMinutes(this.d1.getMinutes());
        console.log(this.d);
      
        for(var i = 0, len = this.apps.length; i < len; i++) {
        let r = this.apps[i];
        let l = new Date(r.date);
          if(l.getFullYear() === this.d.getFullYear() && l.getHours() === this.d.getHours() && l.getMinutes() === this.d.getMinutes() && l.getDate() === this.d.getDate() && l.getMonth() === this.d.getMonth() ) {
            this.form.controls.date.setErrors({'appointmentExists':true})
            this.form.controls.hour.setErrors({'appointmentExists1':true})
          break;
          } else {
            this.form.controls.date.setErrors(null) //sem erro
            this.form.controls.hour.setErrors(null) //sem erro
          }
        }
      }
    }
  }

  onClose() {
    this.form.reset();
    this.dialogRef.close();
  }
}