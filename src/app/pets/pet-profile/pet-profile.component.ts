import { Component, OnInit } from '@angular/core';
import { MatDialog, MatDialogConfig } from '@angular/material/dialog';
import { ActivatedRoute, Router } from '@angular/router';
import * as _ from 'lodash';
import { Pet } from 'src/app/models/pet.model';
import { AccountService } from 'src/app/services/account.service';
import { CustomValidatorService } from 'src/app/services/custom-validator.service';
import { ShowVaccinesComponent } from '../show-vaccines/show-vaccines.component';

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
  constructor(private dialog: MatDialog,private accountService: AccountService, private route: ActivatedRoute, private val: CustomValidatorService, private router:Router) { }

  ngOnInit(): void {
    this.sub = this.route.params.subscribe(params => {
    this.id = +params['id']; // (+) converts string 'id' to a number    

    this.getPet(this.id);
    
  });
}
  showVaccines() {
    const dialogConfig = new MatDialogConfig();
    dialogConfig.disableClose = false;
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
                      console.log(img_height, img_width);
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
                          this.editPet(this.id,this.pet);
                          //window.location.reload();
                      }
                  };
              };
              reader.readAsDataURL(fileInput.target.files[0]);
          }
      }

    editPet(id:number,pet:Pet) {
      this.accountService.editPet(id,pet).subscribe();
    }

}
