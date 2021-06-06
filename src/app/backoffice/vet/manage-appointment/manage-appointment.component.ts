import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { MatDialog, MatDialogConfig, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Appointment } from 'src/app/models/appointment.model';
import { Pet } from 'src/app/models/pet.model';
import { AccountService } from 'src/app/services/account.service';
import { AddPrescriptionComponent } from '../add-prescription/add-prescription.component';
import { AddVaccineComponent } from '../add-vaccine/add-vaccine.component';
import { VetComponent } from '../vet.component';

interface Showed {
  viewValue: string,
  value: boolean,
}

@Component({
  selector: 'app-manage-appointment',
  templateUrl: './manage-appointment.component.html',
  styleUrls: ['./manage-appointment.component.css'],
})

export class ManageAppointmentComponent implements OnInit {
  pet: Pet;
  date: string;
  year: number;
  day: number;
  month: number;
  hour: number;
  minutes: number;
  error: string;
  app: Appointment;
  form: FormGroup;
  public showed: Showed[] = [
    { viewValue: 'Yes', value: true },
    { viewValue: 'No', value: false }
  ]

  constructor(@Inject(MAT_DIALOG_DATA) public data: any, private dialogRef: MatDialogRef<VetComponent>, private accountService: AccountService, private formBuilder: FormBuilder, private dialog: MatDialog) { }

  ngOnInit(): void {
    this.app = this.data.extendedProps.appointment;
    this.getPet();
    this.form = this.formBuilder.group({
      showedUp: [],
    });
    this.form.get('showedUp').setValue(this.app.showedUp);
  }

  onSubmit() {
    if(this.pet) {
    this.app.showedUp = this.form.get('showedUp').value;
    this.accountService.editAppointment(this.app.ID, this.app).subscribe();
  }
  }
  onNoClick() {
    this.dialogRef.close();
  }

  get displayData() {
    return this.data;
  }

  getPet() {
    this.error = '';
    this.accountService.getPetVet(this.app.AnimalID).subscribe(
      (response: Pet) => {
        this.pet = response['data'];

      }, error => this.error = error);
    this.year = this.data.start.getFullYear();
    this.month = this.data.start.getMonth();
    this.day = this.data.start.getDate();
    this.hour = this.data.start.getHours();
    this.minutes = this.data.start.getMinutes();
    if (this.minutes === 0) {
      this.date = `${this.day}/${this.month + 1}/${this.year} ${this.hour}:${this.minutes}0`;
    } else {
      this.date = `${this.day}/${this.month + 1}/${this.year} ${this.hour}:${this.minutes}`;
    }
  }
  get selected() {
    return this.form.controls.showedUp.value;
  }

  openAddVaccine(id:number) {
    const dialogConfig = new MatDialogConfig();
    dialogConfig.disableClose = false;
    dialogConfig.autoFocus = false;
    dialogConfig.width = "35%"
    if(id){
    dialogConfig.data = id;
  }
    this.dialog.open(AddVaccineComponent, dialogConfig);
  }

  openAddPrescription(pet:Pet) {
    let arr: (Pet | Appointment) [] = [pet,this.app];
    const dialogConfig = new MatDialogConfig();
    dialogConfig.disableClose = true;
    dialogConfig.autoFocus = false;
    dialogConfig.width = "70%"
    if(arr) {
    dialogConfig.data = arr;
    }
    this.dialog.open(AddPrescriptionComponent, dialogConfig);
  }

  cancelAppointment() {
    if(!this.app.canceled) {
    this.app.canceled = true;
    this.accountService.editAppointment(this.app.ID,this.app).subscribe();
    }
  }

}
