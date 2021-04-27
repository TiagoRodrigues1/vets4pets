import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { VetComponent } from '../vet.component';

@Component({
  selector: 'app-manage-appointment',
  templateUrl: './manage-appointment.component.html',
  styleUrls: ['./manage-appointment.component.css']
})
export class ManageAppointmentComponent implements OnInit {

  constructor(@Inject(MAT_DIALOG_DATA) public data:any, private dialogRef: MatDialogRef<VetComponent>) { }

  ngOnInit(): void {
    
    console.log(this.data.id + this.data.title + this.data.start)
  }

  onNoClick() {
    this.dialogRef.close();
  }
  get displayData() {
    return this.data;
  }
}
