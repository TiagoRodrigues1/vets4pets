import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Pet } from 'src/app/models/pet.model';
import { Vaccines } from 'src/app/models/vaccines';
import { AccountService } from 'src/app/services/account.service';
import { ManageAppointmentComponent } from '../manage-appointment/manage-appointment.component';

@Component({
  selector: 'app-add-vaccine',
  templateUrl: './add-vaccine.component.html',
  styleUrls: ['./add-vaccine.component.css']
})

export class AddVaccineComponent implements OnInit {
  form:FormGroup;
  submitted = false;
  vaccine:Vaccines;
  constructor(private formBuilder: FormBuilder, private matDialogRef: MatDialogRef<ManageAppointmentComponent>, private accountService: AccountService,@Inject(MAT_DIALOG_DATA) public data:any) { }

  ngOnInit(): void {
    this.form = this.formBuilder.group({
      validity: ['',[Validators.required]], //Data de Validade da Vacina
      dateTaken: ['',[Validators.required]], //Quando a vacina foi tomada
      vaccineName:['',[Validators.required]], // Nome da vacina
      taken:['',[Validators.required]], // Tomou ou não
    });
  }

  onSubmit() {
    this.vaccine.taken = true;
    this.vaccine.dateTaken = new Date();
    if(!this.form.valid || this.form.errors) {
        return;
    }

    this.vaccine.validity = this.form.get('validity').value;
    this.vaccine.vaccineName = this.form.get('vaccineName').value;
    this.vaccine.AnimalID = this.data;
    console.log(this.vaccine);
  }

  onNoClick() {
    this.form.reset();
    this.matDialogRef.close();
  }
}
