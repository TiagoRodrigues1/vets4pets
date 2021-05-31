import { Component, Inject, OnInit , ViewChild} from '@angular/core';
import {  MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Adoption } from 'src/app/models/adoption.model';


@Component({
  selector: 'app-displayadoption',
  templateUrl: './displayadoption.component.html',
  styleUrls: ['./displayadoption.component.css']
})
export class DisplayadoptionComponent implements OnInit  {
  adoption:Adoption;
  
  constructor(@Inject(MAT_DIALOG_DATA) public data:any) { 
    this.adoption=data;      //Remove informação inutil (createAt,updateAt,deletedAt)
  }
  ngOnInit(): void {
  }
}
