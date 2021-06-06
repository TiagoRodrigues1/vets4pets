import { Component, Inject, OnInit, ViewChild } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { AccountService } from 'src/app/services/account.service';

import { Pet } from 'src/app/models/pet.model';
import { MatPaginator } from '@angular/material/paginator';
import { User } from 'src/app/models/user.model';
import { STEPPER_GLOBAL_OPTIONS } from '@angular/cdk/stepper';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { Appointment } from 'src/app/models/appointment.model';
import { CustomValidatorService } from 'src/app/services/custom-validator.service';
import { ClinicProfileComponent } from '../clinic-profile/clinic-profile.component';
import { first } from 'rxjs/operators';
import { enableRipple } from '@syncfusion/ej2-base';
enableRipple(true);

@Component({
  selector: 'app-choose-pet',
  templateUrl: './choose-pet.component.html',
  styleUrls: ['./choose-pet.component.css', 'styles.css'],
  providers: [{
    provide: STEPPER_GLOBAL_OPTIONS,
    useValue: { showError: true, displayDefaultIndicatorType: false },
  }]
})

export class ChoosePetComponent implements OnInit {
  @ViewChild(MatPaginator) paginator: MatPaginator;
  select; //id do pet
  selectVet; //id do vet
  selectApp;
  pets: Pet[] = []; //lista de pets user
  vets: User[] = []; //lista de vets clinica
  hours:String[] = [];
  vet: User;
  pet: Pet;
  appsp:any;
  startDate: Date;
  apps: Appointment[] = [];
  user: User; //ajudar no token
  selected = false; // se o pet tiver selecionado
  selectedVet = false; //se o pet tiver selecionado
  selectedApp = false;
  error: string; //erro do pet
  errorVet: string; //erro do vet 
  errorApp:string;
  errorAppApi: string;
  isEditable = true; //se dá para ir para trás ou não
  suc: string; //se o appintment foi bem sucedido
  valid = new FormControl(); // para ver se o pet foi selecionado
  valid2 = new FormControl(); //para ver o vet foi selecionado
  valid3 = new FormControl();
  form: FormGroup; //form para o appointment
  currentYear: number = new Date().getFullYear();
  currentDay: number = new Date().getDate();
  currentMonth: number = new Date().getMonth();
  app: Appointment;
  d: Date;
  d1: Date;
  loading = true;
  dateString: string;
  public date: Date = new Date();
  public minDate: Date = new Date(this.currentYear, this.currentMonth, this.currentDay);
  public maxDate: Date = new Date(this.currentYear + 2, this.currentMonth, this.currentDay); //só deixa marcar para 2 anos á frente
  public map: Map<String, String>;
  lastDate: Date;
  errorPetApi: string;
  errorVetApi: string;
  constructor(private formBuilder: FormBuilder, private accountService: AccountService, @Inject(MAT_DIALOG_DATA) public data: any, private val: CustomValidatorService, private dialogRef: MatDialogRef<ClinicProfileComponent>) {
    this.setState(this.valid, true);
    this.setState(this.valid2, true);
    this.setState(this.valid3, true);
  }

  ngOnInit(): void {
    this.getPets();
    this.getVets();
    this.form = this.formBuilder.group({
      date: ['', Validators.required],
      updateOn: 'blur',
    },
      { validator: this.getFreeSlots().bind(this) }
    );
    this.map = new Map();
    this.fillMap();
  }

  getPets() {
    let resp = this.accountService.getPets(this.val.getUserId());
    resp.subscribe(report => { this.pets = report['data'] as Pet[]; this.loading = false; },
      error => this.errorPetApi = error);
  }

  getVets() {
    let resp = this.accountService.getVetByClinic(this.data);
    resp.subscribe(report => { this.vets = report['data'] as User[]; }, error => this.errorVetApi = error);
  }

  getVetAppointments() {
    if(this.selectVet != null) {
    let resp = this.accountService.getAppointmentByVet2(this.selectVet);
    resp.subscribe(report => { this.apps = report['data'] as Appointment[]; }, error => this.errorAppApi = error);
    
  }
}

  onSelectCardVet(event: any, id: any, control: FormControl, state: boolean, vet: User) {
    if (this.selectVet != id) { //quer dizer que é um novo que selcionei
      this.selectVet = id;
      this.selectedVet = false;
      this.errorVet = null;
      this.vet = vet;
      control.reset();
    } else { //
      this.selectVet = null;
      this.errorVet = "Please Select a Vet first";
      control.setErrors({ "required": true })
    }
    this.selectedVet = !this.selectedVet;
  }

  onSelectCardApp(event: any, id: any, control: FormControl, state: boolean, app: any) {
    if (this.selectApp != id) { //quer dizer que é um novo que selcionei
      this.selectApp = id;
      this.selectedApp = false;
      this.errorApp = null;
      this.appsp = app;
      control.reset();
    } else { //
      this.selectApp = null;
      this.errorApp = "Please Select a Hour first";
      control.setErrors({ "required": true })
    }
    this.selectedVet = !this.selectedVet;
  }

  onSelectCard(event: any, id: any, control: FormControl, state: boolean,pet:Pet) {
    if (this.select != id) { //quer dizer que é um novo que selcionei
      this.select = id;
      this.selected = false;
      this.error = null;
      this.pet = pet;
      control.reset();
    } else { //
      this.select = null;
      this.error = "Please Select a Pet first";
      control.setErrors({ "required": true })
    }
    this.selected = !this.selected;
  }

  setState(control: FormControl, state: boolean) {
    if (state) {
      control.setErrors({ "required": true })
    } else {
      control.reset();
    }
  }

  onSubmit() {
    this.errorAppApi = '';
    if(this.selectApp == null) { //verficar se tem hora se não tiver 
      this.errorApp = "Please Select a Hour first";
      this.valid3.setErrors({ "required": true });
      return;
    }

    if (this.form.invalid) {
      return;
    }

    this.d = this.form.get('date').value; //atribuir o valo á data
    let split = this.selectApp.split(":");
    this.d.setHours(split[0]);
    this.d.setMinutes(split[1]);
    this.app = new Appointment(this.select, this.selectVet, this.d);
    this.accountService.createAppointment(this.app).pipe(first()).subscribe({
      next: () => {
        this.suc = 'Your Appointment was created, check your profile to see all of your appointments';
        this.form.controls.date.setErrors(null);
        this.isEditable = false;
        this.startDate = this.d;

        if (this.startDate.getMinutes() === 0) {
          this.dateString = `${this.startDate.getDate()}/${this.startDate.getMonth() + 1}/${this.startDate.getFullYear()} ${this.startDate.getHours()}:${this.startDate.getMinutes()}0`;
        } else {
          this.dateString = `${this.startDate.getDate()}/${this.startDate.getMonth() + 1}/${this.startDate.getFullYear()} ${this.startDate.getHours()}:${this.startDate.getMinutes()}`;
        }
      }, error: error => {
        this.errorAppApi = error;
        this.form.controls.date.setErrors({ 'appointmentExists': true });
      }
    });
  }

  getFreeSlots = () => {
    return (formGroup: FormGroup) => {
      const dateControl = formGroup.controls.date; //ir buscar o valor da data
      if (!dateControl) {
        return null;
      }

      if (dateControl.errors) {
        return null;
      }
      if (dateControl.value) {
        this.d = dateControl.value
        if (this.d != this.lastDate) { //quando seleciona um novo dia dar refill ao mapa
          this.fillMap();
          this.selectedApp = false;
          this.selectApp = null;
          this.valid3.setErrors(null);
        }
        for (var i = 0, len = this.apps.length; i < len; i++) { //percorrer o array de appointments
          let r = this.apps[i];
          let l = new Date(r.date);
          if (l.getFullYear() === this.d.getFullYear() && l.getDate() === this.d.getDate() && l.getMonth() === this.d.getMonth()) {//dia que quero comparar
            let s = `${l.getHours()}:${l.getMinutes()}`;
            if (this.map.get(s) != null) {
              this.map.delete(s); //remover do array de appointments data usada
              this.lastDate = this.d;
            }
          }
        }
        this.toarr();
      }
    }
  }

  onClose() {
    this.form.reset();
    this.dialogRef.close();
  }

  toarr() {
    this.hours = [];
    for(let entry of this.map.keys()){
      let s = entry.split(":");
      let aux
      if(s[1] == "0") {
        aux =  s[1] = `${s[0]}:${s[1]}0`
      } else {
        aux = entry;
      }
      entry = aux;
      this.hours.push(entry);
    }
  }

  fillMap() {
    this.map.clear();
    this.map.set("8:0", "8:0");
    this.map.set("8:30", "8:30");
    this.map.set("9:0", "9:0");
    this.map.set("9:30", "9:30");
    this.map.set("10:0", "10:0");
    this.map.set("10:30", "10:30");
    this.map.set("11:0", "11:0");
    this.map.set("11:30", "11:30");
    this.map.set("12:0", "12:0");
    this.map.set("12:30", "11:30");
    this.map.set("14:0", "14:0");
    this.map.set("14:30", "14:30");
    this.map.set("15:0", "15:0");
    this.map.set("15:30", "15:30");
    this.map.set("16:0", "16:0");
    this.map.set("16:30", "16:30");
    this.map.set("17:0", "17:0");
    this.map.set("17:30", "17:30");
    this.map.set("18:0", "18:0");
    this.map.set("18:30", "18:30");
  }

}