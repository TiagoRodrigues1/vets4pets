import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Router } from '@angular/router';
import { Pet } from 'src/app/models/pet.model';
import { AccountService } from 'src/app/services/account.service';
import { PetsComponent } from '../pets.component';

@Component({
  selector: 'app-delete-pet',
  templateUrl: './delete-pet.component.html',
  styleUrls: ['./delete-pet.component.css']
})
export class DeletePetComponent implements OnInit {
  status: string;
  pet:Pet;
  constructor(private accountService: AccountService,@Inject(MAT_DIALOG_DATA) public data:any, private dialogRef: MatDialogRef<PetsComponent>,private router:Router) { }

  ngOnInit(): void {
    
  }
  onDelete() {
    this.accountService.deletePet(this.data.ID).subscribe(response => {
      this.status = response['message'];
      setTimeout(() => {
      this.router.navigate(['/pets']);

      },1000);
    },);
    this.onNoClick();
    
  }
  onNoClick() {
    this.dialogRef.close();
  }

}
