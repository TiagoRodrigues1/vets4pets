import { Component, OnInit } from '@angular/core';
import { MatDialog, MatDialogConfig } from '@angular/material/dialog';
import { ActivatedRoute, Router } from '@angular/router';
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
  constructor(private dialog: MatDialog,private accountService: AccountService, private route: ActivatedRoute, private val: CustomValidatorService, private router:Router) { }

  ngOnInit(): void {
    /*if(history.state.data) {
      this.id = history.state.data;
      sessionStorage.setItem('petInfo',JSON.stringify(this.id));
      console.log(this.id);
    } else {
      this.id = JSON.parse(sessionStorage.getItem('petInfo')); //IR BUSCAR O ID AO URL PARA DPS ENVIAR NA QUERY PARA DPS NO BACKEND VERIFICAR SE O PET É DAQUELE É USER, SE NAO FOR RETORNAR UNOTHORIZED
      console.log(this.id);
    }
    */
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

}
