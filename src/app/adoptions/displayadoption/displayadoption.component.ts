import { Component, Inject, OnInit , ViewChild} from '@angular/core';
import {  MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Adoption } from 'src/app/models/adoption.model';
import { LastadoptionsComponent } from '../lastadoptions/lastadoptions.component';


@Component({
  selector: 'app-displayadoption',
  templateUrl: './displayadoption.component.html',
  styleUrls: ['./displayadoption.component.css']
})
export class DisplayadoptionComponent implements OnInit  {
  adoption:Adoption;
  attachements:string[] = [];
  imageObject:any;
  adoptionString:String[] = [];

  constructor(@Inject(MAT_DIALOG_DATA) public data:any, private dialogRef: MatDialogRef<LastadoptionsComponent>) { 
    this.adoption=data;      //Remove informação inutil (createAt,updateAt,deletedAt)
    
  }
  ngOnInit(): void {
    this.imageObject = [{
      image: this.adoption.attachement1,
      thumbImage: this.adoption.attachement1,
  }, {
      image: this.adoption.attachement2,
      thumbImage: this.adoption.attachement2,
  }, {
    image: this.adoption.attachement3,
    thumbImage: this.adoption.attachement3,
  },{
    image: this.adoption.attachement4,
    thumbImage: this.adoption.attachement4,
  }];
  }

  onClose() {
    this.dialogRef.close();
  }
}
