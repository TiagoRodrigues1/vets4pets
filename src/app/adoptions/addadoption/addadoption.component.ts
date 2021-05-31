import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { first } from 'rxjs/operators';
import { MatDialogRef } from '@angular/material/dialog';
import { AdoptionService } from 'src/app/services/adoption.service';
import { AccountService } from 'src/app/services/account.service';


interface AnimalType {
  type : string,
  viewValue: string,
}

interface City {
  type : string,
  viewValue: string,
}

@Component({
  selector: 'app-addadoption',
  templateUrl: './addadoption.component.html',
  styleUrls: ['./addadoption.component.css']
})

export class AddadoptionComponent implements OnInit {
  urls = new Array<string>();
  urls2 = new Array<string>();
    
  public animalType: AnimalType[] = [
    {type: 'dog',viewValue:'Dog'},
    {type: 'cat',viewValue:'Cat'},
    {type: 'turtle',viewValue:'Turtle'},
    {type: 'hamster',viewValue:'Hamster'},
    {type: 'snake',viewValue:'Snake'},
    {type: 'guinea-pig',viewValue:'Guinea Pig'},
    {type: 'bird',viewValue:'Bird'},
  ];

  public citys: City[] = [
    {type: 'aveiro',viewValue:'Aveiro'},
    {type: 'beja',viewValue:'Beja'},
    {type: 'braga',viewValue:'Braga'},
    {type: 'braganca',viewValue:'Bragança'},
    {type: 'castelo_branco',viewValue:'Castelo Branco'},
    {type: 'coimbra',viewValue:'Coimbra'},
    {type: 'evora',viewValue:'Évora'},
    {type: 'faro',viewValue:'Faro'},
    {type: 'guarda',viewValue:'Guarda'},
    {type: 'leiria',viewValue:'Leiria'},
    {type: 'lisboa',viewValue:'Lisboa'},
    {type: 'portalegre',viewValue:'Portalegre'},
    {type: 'porto',viewValue:'Porto'},
    {type: 'santarem',viewValue:'Santarem'},
    {type: 'setubal',viewValue:'Setubal'},
    {type: 'viana_do_castelo',viewValue:'Viana do Castelo'},
    {type: 'vila_real',viewValue:'Vila Real'},
    {type: 'viseu',viewValue:'Viseu'},
  ];


  constructor(private accountService: AccountService,private router: Router,private route: ActivatedRoute,private dialogRef: MatDialogRef< AddadoptionComponent>,private adoptionService: AdoptionService) { }

  ngOnInit(): void {
  }

  onSubmit() {
    
    console.log(this.service.form.get('ID').value)
    if(!this.service.form.get('ID').value) {
      if (this.adoptionService.form.invalid) {
        return;
    }
    console.log(this.adoptionService.form.value);
    this.accountService.createAdoption(this.adoptionService.form.value).pipe(first()).subscribe({
      next: () => {
        this.router.navigate(['../myadoptions'],{relativeTo: this.route});
      }
    });
    this.onClose();
    //window.location.reload();
  } else {
    if (this.adoptionService.form.invalid) {
      return;
  }
    console.log(this.adoptionService.form.get('ID').value);
    this.accountService.EditAdoption(this.adoptionService.form.get('ID').value,this.adoptionService.form.value).subscribe();
    this.onClose();
    window.location.reload();
  }
}

  onClose() {
    this.adoptionService.form.reset();
    this.dialogRef.close();
  }

  populateForm() {
    console.log(this.adoptionService);
    this.adoptionService.form.setValue(this.adoptionService);
  }

  get service() {
    return this.adoptionService;
  }

 

  
  onSelectFile(event) {
    this.urls = [];
    
    let files = event.target.files;
    if (files) {
      for (let file of files) {
        let reader = new FileReader();
        reader.onload = (e: any) => {
          this.urls.push(e.target.result);
        }
        reader.readAsDataURL(file);
      }
    }
  }



}
