import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { first } from 'rxjs/operators';
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
  error:string;
  constructor(private formBuilder: FormBuilder, private matDialogRef: MatDialogRef<ManageAppointmentComponent>, private accountService: AccountService,@Inject(MAT_DIALOG_DATA) public data:any ) { }

  ngOnInit(): void {
    this.form = this.formBuilder.group({
      validity: ['',[Validators.required]], //Data de Validade da Vacina
      dateTaken: ['',[Validators.required]], //Quando a vacina foi tomada
      vaccineName:['',[Validators.required]], // Nome da vacina
      taken:['',[Validators.required]], // Tomou ou não
    });
  }

  onSubmit() {  
    if(!this.form.invalid || this.form.errors) {
      return;
  }
  this.vaccine = new Vaccines(this.data,null,true,this.form.get('validity').value,this.form.get('vaccineName').value,new Date());
  this.accountService.addVaccine(this.vaccine).pipe(first())
  .subscribe({
      next: () => {
        this.form.reset();
        this.matDialogRef.close();
      },
      error: error => {
        this.error = error;
      }
  });
  }

  onNoClick() {
    this.matDialogRef.close();
  }
}
