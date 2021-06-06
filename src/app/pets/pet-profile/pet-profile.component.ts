import { Component, OnInit } from '@angular/core';
import { MatDialog, MatDialogConfig } from '@angular/material/dialog';
import { ActivatedRoute, Router } from '@angular/router';
import * as _ from 'lodash';
import { AddPetComponent } from 'src/app/add-pet/add-pet.component';
import { Pet } from 'src/app/models/pet.model';
import { AccountService } from 'src/app/services/account.service';
import { CustomValidatorService } from 'src/app/services/custom-validator.service';
import { PetService } from 'src/app/services/pet.service';
import { DeletePetComponent } from '../delete-pet/delete-pet.component';
import { HistoricPetComponent } from '../historic-pet/historic-pet.component';
import { ShowVaccinesComponent } from '../show-vaccines/show-vaccines.component';
import { StatsComponent } from '../stats/stats.component';

@Component({
  selector: 'app-pet-profile',
  templateUrl: './pet-profile.component.html',
  styleUrls: ['./pet-profile.component.css']
})
export class PetProfileComponent implements OnInit {
  pet:Pet;
  id: number;
  private sub: any;
  error;
  imageError:string;
  constructor(private dialog: MatDialog,private accountService: AccountService, private route: ActivatedRoute, private val: CustomValidatorService, private router:Router, private petService: PetService) { }

  ngOnInit(): void {
    this.sub = this.route.params.subscribe(params => {
    this.id = +params['id']; // (+) converts string 'id' to a number    

    this.getPet(this.id);
    
  });
}
  showVaccines() {
    const dialogConfig = new MatDialogConfig();
    dialogConfig.disableClose = true;
    dialogConfig.autoFocus = true;  
    dialogConfig.width = "60%"
    dialogConfig.data = this.id;
    this.dialog.open(ShowVaccinesComponent,dialogConfig);
  }

  getPet(id:number) {
    let resp = this.accountService.getPet(id,this.val.getUserId());
    resp.subscribe(report => {this.pet = report['data'] as Pet},
    error => {
      this.error = error;
      this.router.navigate([`/404`]); // Se não existir leva para a página de 404 - erro
    });
  }

  fileChangeEvent(fileInput) {
    this.imageError = null;
          if (fileInput.target.files && fileInput.target.files[0]) {
              // Size Filter Bytes
              const max_size = 20971520;
              const allowed_types = ['image/png', 'image/jpeg'];
              const max_height = 15200;
              const max_width = 25600;
  
              if (fileInput.target.files[0].size > max_size) {
                  this.imageError =
                      'Maximum size allowed is ' + max_size / 1000 + 'MB';
                      return false;
              }
  
              if (!_.includes(allowed_types, fileInput.target.files[0].type)) {
                  this.imageError = 'Only allowed images are of type JPG or PNG';
                  return false;
              }
              const reader = new FileReader();
              reader.onload = (e: any) => {
                  const image = new Image();
                  image.src = e.target.result;
                  image.onload = rs => {
                      const img_height = rs.currentTarget['height'];
                      const img_width = rs.currentTarget['width'];
                      if (img_height > max_height && img_width > max_width) {
                          this.imageError =
                              'Maximum dimentions allowed ' +
                              max_height +
                              'x' +
                              max_width +
                              'px';
                          return false;
                      } else {
                          const imgBase64Path = e.target.result;
                          this.pet.profilePicture = imgBase64Path;
                          this.accountService.editPet(this.id,this.pet).subscribe();
                          
                          //window.location.reload();
                      }
                  };
              };
              reader.readAsDataURL(fileInput.target.files[0]);
          }
      }

      

    deletePet(pet:Pet) {
      this.petService.form.reset();
      const dialogConfig = new MatDialogConfig();
      dialogConfig.disableClose = true;
      dialogConfig.autoFocus = true;  
      dialogConfig.width = "20%"
      dialogConfig.data = pet;
      this.dialog.open(DeletePetComponent,dialogConfig);
    }
  
    editPet(id:number,pet:Pet) {
      this.petService.populateForm(pet);
      const dialogConfig = new MatDialogConfig();
      dialogConfig.autoFocus = true;  
      dialogConfig.disableClose = true;
      dialogConfig.width = "35%"
      this.dialog.open(AddPetComponent,dialogConfig);
    }

    showHistoric(pet:Pet) {
      const dialogConfig = new MatDialogConfig();
      dialogConfig.autoFocus = true;  
      dialogConfig.disableClose = true;
      dialogConfig.width = "35%"
      dialogConfig.data = pet;
      this.dialog.open(HistoricPetComponent,dialogConfig);
    }

    showStats(pet:Pet) {
      const dialogConfig = new MatDialogConfig();
      dialogConfig.autoFocus = true;  
      dialogConfig.disableClose = false;
      dialogConfig.width = "40%"
      dialogConfig.data = pet;
      this.dialog.open(StatsComponent,dialogConfig);
    }

}
