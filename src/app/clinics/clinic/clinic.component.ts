import { HttpErrorResponse } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { Clinic } from 'src/app/models/clinic.model';
import { AccountService } from 'src/app/services/account.service';

@Component({
  selector: 'app-clinic',
  templateUrl: './clinic.component.html',
  styleUrls: ['./clinic.component.css']
})
export class ClinicComponent implements OnInit {
  Clinic : Clinic[];
  defaultElevation = 2;
  raisedElevation = 8;
  titleSelected;
  s: string;
  constructor(private accountService: AccountService, private router: Router) { }

  ngOnInit(): void {
    this.clinics();
  }

  public clinics() {
    this.accountService.getClinics().subscribe(
    (response: Clinic[]) => {
      this.Clinic = response['data'];
    },
    (error: HttpErrorResponse) => {
      alert(error.message);
    }); 
  }

  goProfile(id: number, clinic: Clinic) { 
    this.titleSelected = clinic.name;
    this.router.navigate([`/clinic/${id}`],{state: {data: clinic}});
  }

}
