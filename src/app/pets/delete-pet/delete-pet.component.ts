import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { AccountService } from 'src/app/services/account.service';
import { PetsComponent } from '../pets.component';

@Component({
  selector: 'app-delete-pet',
  templateUrl: './delete-pet.component.html',
  styleUrls: ['./delete-pet.component.css']
})
export class DeletePetComponent implements OnInit {
  status: string;

  constructor(private accountService: AccountService,@Inject(MAT_DIALOG_DATA) public data:any, private dialogRef: MatDialogRef<PetsComponent>) { }

  ngOnInit(): void {
  }
  onDelete() {
    this.accountService.deletePet(this.data).subscribe(() => this.status = 'Delete Sucessful');
  }
  onNoClick() {
    this.dialogRef.close();
  }

}
