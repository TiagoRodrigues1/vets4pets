import { Component, Inject, OnInit } from '@angular/core';
import { FormArray, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { first } from 'rxjs/operators';
import { Prescription } from 'src/app/models/prescription.model';
import { AccountService } from 'src/app/services/account.service';
import { CustomValidatorService } from 'src/app/services/custom-validator.service';
import { ManageAppointmentComponent } from '../manage-appointment/manage-appointment.component';

interface Hours {
  viewValue: string,
}

interface Duration {
  viewValue: string,
  value : number,
}

@Component({
  selector: 'app-add-prescription',
  templateUrl: './add-prescription.component.html',
  styleUrls: ['./add-prescription.component.css']
})


export class AddPrescriptionComponent implements OnInit {
  form: FormGroup;
  medicineList: FormArray;
  hoursList:FormArray;
  secondForm:FormGroup;
  medicine:string = "";
  error:string;
  date:Date;
  prescription:Prescription;
  public hours: Hours[] = [
    {viewValue:'8:00'},
    {viewValue:'8:30'},
    {viewValue:'9:00'},
    {viewValue:'9:30'},
    {viewValue:'10:00'},
    {viewValue:'10:30'},
    {viewValue:'11:00'},
    {viewValue:'11:30'},
    {viewValue:'12:00'},
    {viewValue:'12:30'},
    {viewValue:'13:00'},
    {viewValue:'13:30'},
    {viewValue:'14:00'},
    {viewValue:'14:30'},
    {viewValue:'15:00'},
    {viewValue:'15:30'},
    {viewValue:'14:00'},
    {viewValue:'14:30'},
    {viewValue:'15:00'},
    {viewValue:'15:30'},
    {viewValue:'14:00'},
    {viewValue:'14:30'},
    {viewValue:'15:00'},
    {viewValue:'15:30'},
    {viewValue:'16:00'},
    {viewValue:'16:30'},
    {viewValue:'17:00'},
    {viewValue:'17:30'},
    {viewValue:'18:00'},
    {viewValue:'17:30'},
    {viewValue:'19:00'},
    {viewValue:'19:30'},
    {viewValue:'20:00'},
    {viewValue:'20:30'},
    {viewValue:'21:00'},
    {viewValue:'21:30'},
    {viewValue:'22:00'},
    {viewValue:'22:30'},
    {viewValue:'23:00'},
    {viewValue:'23:30'},
    {viewValue:'00:00'},
  ];

  public durations: Duration[] = [
    {viewValue:'1 Week',value:7},
    {viewValue:'2 Weeks',value:14},
    {viewValue:'1 Month',value:31},
    {viewValue:'2 Months',value:62},
    {viewValue:'Forever',value:9999},
  ];

  get medicineFormGroup() {  
    return this.form.get('medication') as FormArray;
  }

  constructor(private formBuilder: FormBuilder, private dialogRef:MatDialogRef<ManageAppointmentComponent>, private accountService: AccountService,@Inject(MAT_DIALOG_DATA) public data:any,private val:CustomValidatorService) { }

  ngOnInit(): void { 
    this.form = this.formBuilder.group({
      weight: ['',[Validators.required,Validators.maxLength(3)]],
      price: ['',[Validators.required,Validators.maxLength(5)]],
      description:['',Validators.required],
      medication: this.formBuilder.array([this.createMedicine()]),
    });
    this.medicineList = this.form.get('medication') as FormArray;
    
  }

  onNoClick() {
    this.dialogRef.close();
  }

  onSubmit() {
    if(this.form.invalid || this.form.errors) {
      return;
    }
    if(this.form.get('price').value < 0 || this.form.get('weight').value < 0)  {
      return;
    }
    //console.log(this.medicineList.length)
    for(let medicine of this.medicineList.controls) {
      if(medicine.get('medicine').value) {
      this.date = medicine.get('start').value;
      this.date.setHours(this.date.getHours() + 1);
      if(medicine.get('hour1').value && medicine.get('hour2').value) {
      this.medicine += `${medicine.get('medicine').value}/${this.date.toISOString()}/${medicine.get('howlong').value}/${medicine.get('hour').value}|${medicine.get('hour1').value}|${medicine.get('hour2').value};`;
    } else if (medicine.get('hour1').value) {
      this.medicine += `${medicine.get('medicine').value}/${this.date.toISOString()}/${medicine.get('howlong').value}/${medicine.get('hour').value}|${medicine.get('hour1').value};`;
    } else {
      this.medicine += `${medicine.get('medicine').value}/${this.date.toISOString()}/${medicine.get('howlong').value}/${medicine.get('hour').value}|${medicine.get('hour2').value};`;
    }
  }
}

    this.prescription = this.form.value;
    this.prescription.medication = this.medicine;
    this.prescription.animalID = this.data[0].ID;
    this.prescription.petname = this.data[0].name;
    this.prescription.date = this.data[1].date;
    this.prescription.vetID = this.val.getUserId();
    this.accountService.addPrescription(this.prescription).pipe(first())
    .subscribe({
        next: () => {
          this.form.reset();
          this.dialogRef.close();
        },
        error: error => {
          this.error = error;
        }
    });
  
  }

  addMedicine() {  
    this.medicineList.push(this.createMedicine());
  }

  removeMedicine(index) {
    this.medicineList.removeAt(index);
  }

  getMedicineFormGroup(index): FormGroup {
    const formGroup = this.medicineList.controls[index] as FormGroup;
    return formGroup;
  }

  createMedicine(): FormGroup {
      return this.formBuilder.group({
        medicine:[''],
        howlong:[''],
        start:[''],
        hour:[''],
        hour1:[''],
        hour2:[''],
      });
  }

}
